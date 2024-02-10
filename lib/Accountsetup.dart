import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/auth.dart';

class Accountsetup extends StatefulWidget {
  const Accountsetup({super.key});

  @override
  State<Accountsetup> createState() => _AccountsetupState();
}

class _AccountsetupState extends State<Accountsetup> {
  final fname = TextEditingController();
  final lname = TextEditingController();
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
              children: [
                Page1(fname: fname, lname: lname),
                Page1(fname: fname, lname: lname)
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
  });

  final TextEditingController fname;
  final TextEditingController lname;

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
