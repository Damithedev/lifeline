import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/auth.dart';
import 'package:page_transition/page_transition.dart';

class Accountsetup extends StatefulWidget {
  const Accountsetup({super.key});

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
    // TODO: implement initState
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? date;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 246, 249),
        body: Column(children: [
          SizedBox(
            height: 50,
          ),
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
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _pageindex = index;
                });
              },
              children: [
                Page1(
                  fname: fname,
                  lname: lname,
                  DOB: DOB,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: ListView(
                    children: [],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    ...List.generate(
                        2,
                        (index) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Dotindicator(
                                  isActive: index == _pageindex,
                                ),
                              ),
                            ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
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
                    onPressed: () {
                      print(_pageController.page);
                      // Add your button action here
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                      if (_pageindex == 2) {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: Signup()));
                      }
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}

class Page1 extends StatelessWidget {
  const Page1({
    super.key,
    required this.fname,
    required this.lname,
    required this.DOB,
  });

  final TextEditingController fname;
  final TextEditingController lname;
  final TextEditingController DOB;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListView(children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "Personal details",
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
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
                radius: 50, // Adjust the radius as per your requirement
                backgroundImage: AssetImage('assets/images/your_image.jpg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Positioned(
                left: 75,
                bottom: 3,
                child: CircleAvatar(
                  radius: 20, // Adjust the radius as per your requirement
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
              if (dateTime!.isAfter(DateTime.now())) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select a  valid date'),
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
              borderSide: BorderSide.none, // Transparent border in normal state
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
        )
      ]),
    );
  }
}

class Dotindicator extends StatelessWidget {
  const Dotindicator({super.key, this.isActive = false});
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
