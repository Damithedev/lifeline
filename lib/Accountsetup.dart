import 'dart:async';
import 'dart:io';

import 'package:date_format_field/date_format_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:lifeline/ui/Splashscreen.dart';
import 'package:lifeline/components/loacate.dart';
import 'ui/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_loading_button/easy_loading_button.dart';


class Accountsetup extends StatefulWidget {
  const Accountsetup({Key? key}) : super(key: key);

  @override
  State<Accountsetup> createState() => _AccountsetupState();
}

class _AccountsetupState extends State<Accountsetup> {
  final picker = ImagePicker();
  File? _imageFile;
  final fname = TextEditingController();
  final lname = TextEditingController();
  final DOB = TextEditingController();
  String? selectedValue;
  final finstance = FirebaseAuth.instance;

  late PageController _pageController;
   final messaging = FirebaseMessaging.instance;

    

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    selectedValue = null;
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
    CollectionReference users = FirebaseFirestore.instance.collection('users');
   
    Reference ref = FirebaseStorage.instance.ref().child('ProfilePictures/');
    final storageref = FirebaseStorage.instance.ref();
  
    Object dateparser(datestring) {
      DateFormat inputFormat = DateFormat('dd/MM/yyyy');

      try {
        // Parse the date string using the input format
        DateTime dob = inputFormat.parse(datestring);

        return dob; // Output the parsed DateTime object
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing date: $e");
        }
        return e;
      }
    }

  

Future<void> addUser() async {
  if (_imageFile == null) {
    // No image selected
    return;
  }

  try {
    // Upload the image to Firebase Storage
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    UploadTask uploadTask = ref.child('images/$uid').putFile(_imageFile!);
     TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print('Image uploaded successfully!');
    String? token = await messaging.getToken();

    // Add user data to Firestore after image upload is successful
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
          'profile picture': downloadUrl,
          'firstname': fname.text,
          'lastname': lname.text,
          'FCM':token,
          'uid': uid,
          'date_of_birth': dateparser(DOB.text),
          'gender': selectedValue,
         
        })
        .then((value) =>  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Splashscreen()),
      ))
        .catchError((error) =>  ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Failed to add user: $error")),
                                      ));
  } on TimeoutException catch (e){
     ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Upload task timed out: $e'),
                                      ));
  }
  
  catch (e) {
    print(e);
    ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Error uploading image or adding user: $e'),

                                      ));
  }
}



    final List<String> items = ['Male', 'Female', 'Others'];
    DateTime? date;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 246, 249),
      body: Form(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Center(
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
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Personal details",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 28),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 28),
                          child: Text(
                            "Profile Picture",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ),
                         Stack(
  children: [
    Align(
      alignment: Alignment.topLeft,
      child: _imageFile == null ? const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('images/dp.jpg') 
      ) :  CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_imageFile!)
      ),
    ),
    Positioned(
      left: 75,
      bottom: 3,
      child: InkWell(
        onTap: _getImage,
        child: const CircleAvatar(
          radius: 20,
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
                                  const SnackBar(
                                    content: Text('Please select a valid date'),
                                    duration: Duration(milliseconds: 300),
                                  ),
                                );
                              } else {
                                print('Selected date: $dateTime');
                                setState(() {
                                  date = dateTime;
                                  DOB.text = DateFormat('dd/MM/yyyy').format(
                                      date!); // Assigning date to the controller
                                });
                              }
                            }
                          },
                          controller: DOB,
                          type: DateFormatType.type1,
                          addCalendar: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            fillColor: Colors.white,
                            labelText: 'Date Of Birth',
                            hintText: 'Date of Birth',
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
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
                                  .map((String item) =>
                                      DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 55,
                                width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  boxShadow: const [],
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
                        // Display the selected gender
                              EasyButton(
  type: EasyButtonType.elevated,

  // Content inside the button when the button state is idle.
  idleStateWidget: const Text(
    'Submit',
    style: TextStyle(
      color: Colors.white,
    ),
  ),
  loadingStateWidget: const CircularProgressIndicator(
    strokeWidth: 3.0,
    valueColor: AlwaysStoppedAnimation<Color>(
      Colors.white,
    ),
  ),

  useWidthAnimation: true,


  useEqualLoadingStateWidgetDimension: true,


  width: 50.0,
  height: 40.0,
  borderRadius: 16.0,
  elevation: 3.0,


  contentGap: 6.0,
  buttonColor: const Color.fromARGB(255, 233, 16, 0),

  onPressed: () async {
    print(uid);
    await addUser();
  },
),
                    
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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