
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lottie/lottie.dart';

class Scanpage extends StatefulWidget {
  final dynamic Longtitude;
  final dynamic Latitude;
  const Scanpage({super.key, required this.Latitude, required this.Longtitude});

  @override
  State<Scanpage> createState() => _ScanpageState();
}

class _ScanpageState extends State<Scanpage> {
  
 CollectionReference users = FirebaseFirestore.instance.collection('users');
  
  
    
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent,),
            backgroundColor: const Color.fromARGB(255, 233, 16, 0),
            body: Center(
              child: Column(
                
                children: [
                  DefaultTextStyle(
    style: const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    child: AnimatedTextKit(
      animatedTexts: [
           WavyAnimatedText('Looking For Help ...'),
      WavyAnimatedText('Finding Closeby Responders ...'),
       WavyAnimatedText('Sending request to Responders ...'),
      ],
        isRepeatingAnimation: true,
      
    ),
  ),
                 
  
   

                
                
                 InkWell(
                 
                   child: Stack(
                     children: [
                       Lottie.asset('images/scan.json', width: double.infinity),
                       const Positioned.fill(
                      child: Align(
        alignment: Alignment.center,
                         child: Hero(
                          tag: 'mainbtn',
                           child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 110,
                            child: Center(child: Icon(Icons.add, color: Colors.red, size: 95,),),
                           ),
                         ),
                       ),),
                     ],
                   ),
                 ),
                 const Expanded(child: SizedBox()),
                  
  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          );
  }


@override
void initState() {
  super.initState();
  _fetchNearbyUsers();
}

Future<void> _fetchNearbyUsers() async {
  try {
    await getNearbyUsers(widget.Longtitude, widget.Latitude);
  } catch (e) {
    _showMyDialog();
  }
}

Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Failed to Find Responders'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('An error occurred while fetching nearby users.'),
              Text('Please try again later or check internet connection'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              
            },
          ),
        ],
      );
    },
  );
}
}