import 'package:date_format_field/date_format_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:page_transition/page_transition.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Accountsetup extends StatefulWidget {
  const Accountsetup({Key? key}) : super(key: key);

  @override
  State<Accountsetup> createState() => _AccountsetupState();
}

class _AccountsetupState extends State<Accountsetup> {
  final fname = TextEditingController();
  final lname = TextEditingController();
  final DOB = TextEditingController();
  int _pageindex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': "fullName", // John Doe
            'company': "company", // Stokes and Sons
            'age': "age" // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    final List<String> items = [
      'Item1',
      'Item2',
      'Item3',
      'Item4',
      'Item5',
      'Item6',
      'Item7',
      'Item8',
    ];
    DateTime? date;

    var selectedValue;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 246, 249),
      body: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: Text(
              "LifeLine",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Personal details",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 28),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 28),
                        child: Text(
                          "Profile Picture",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              radius:
                                  50, // Adjust the radius as per your requirement
                              backgroundImage:
                                  AssetImage('assets/images/your_image.jpg'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Positioned(
                              left: 75,
                              bottom: 3,
                              child: CircleAvatar(
                                radius:
                                    20, // Adjust the radius as per your requirement
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      xInputfield(
                          label: 'First Name',
                          Hinttext: 'Enter First Name',
                          icon: Icons.person,
                          controller: fname),
                      xInputfield(
                          label: 'Last Name',
                          Hinttext: 'Enter Last Name',
                          icon: Icons.person,
                          controller: lname),
                      DateFormatField(
                        onComplete: (DateTime? dateTime) {
                          if (dateTime == null) {
                          } else {
                            if (dateTime.isAfter(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please select a valid date'),
                                  duration: Duration(milliseconds: 300),
                                ),
                              );
                            } else {
                              print('Selected date: $dateTime');
                            }
                          }
                        },
                        controller: DOB,
                        type: DateFormatType.type2,
                        addCalendar: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide
                                .none, // Transparent border in normal state
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          fillColor: Colors.white,
                          labelText: 'Date Of Birth',
                          hintText: 'Date of Birth',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Text(
                              'Select Gender',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            items: items
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                                print(selectedValue);
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 55,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                boxShadow: [],
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              elevation: 2,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: 65,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Color.fromARGB(255, 221, 12, 12),
              ),
              child: TextButton(
                onPressed: addUser,
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Dotindicator extends StatelessWidget {
  const Dotindicator({Key? key, this.isActive = false}) : super(key: key);
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.red.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
