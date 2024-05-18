import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Responder extends StatelessWidget {
  final String uid;
  const Responder({super.key, required this.uid});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     
       backgroundColor: const Color.fromARGB(227, 245, 245, 255),
       body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 24),
         child: Column(
          children: [
            SizedBox(height: 50,),
            Align(child: Text("Damilola Abiola needs Help", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),), alignment: Alignment.bottomLeft,),
             Align(child: Text("Ikega,Lagos State (0.00 miles Away)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 13),), alignment: Alignment.bottomLeft,),
             Spacer(),
           Helpoption('images/firstaid.jpeg', 'First Aid Service', 'FA'),
           Spacer(),
            Helpoption('images/drive.jpeg', 'Offer Ride to Hospital', 'RIDE'),
           Spacer(),
            Helpoption('images/call.jpeg', 'Call to Assist', 'CALL'),
           Spacer(),
         ],),
       ),
    );
  }
}
Widget Helpoption(String imagelocation, String title, String option){
  return Stack(
    children: [
     
      Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(31)),
           boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        spreadRadius: 4,
        blurRadius: 5,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
        ),
       child: ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(31)), // Match the border radius
    child: Image.asset(
      imagelocation,
      
      fit: BoxFit.cover, // Use BoxFit.cover for better scaling
    ),
  )),

Positioned(
  bottom: 0,
  right: 0,
  child: Container(
    height: 35,
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(31), bottomRight: Radius.circular(31) ),
      color: Colors.red
    ),
    child: Center(child: Text("Help   ->", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,color: Colors.white),)),
  ),
),
Positioned(top: 08, left: 20, child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,color: Colors.white),),)
  ],
  
  );
}