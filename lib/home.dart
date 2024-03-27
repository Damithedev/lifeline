import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lifeline/components/loacate.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getLocationName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Fetching Location...'),
              centerTitle: true,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
              centerTitle: true,
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
         String? loacationname = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 20),
                  Text(
                    loacationname!,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Expanded(child: SizedBox()),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                  ),
                ],
              ),
            ),
            backgroundColor: Color.fromARGB(227, 245, 245, 255),
            body: Center(
              child: Column(
                
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Need Emergency Health \n  Services?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Just hold the button to call",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                Expanded(child: SizedBox()),
                 Stack(
                   children: [
                     CircleAvatar(
                      backgroundColor: const Color.fromARGB(105, 117, 117, 117),
                      radius: 120,
                     
                     ),
                     Positioned(
                      left: 10,
                      top: 10,
                       child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 233, 16, 0),
                        radius: 110,
                        child: Center(child: Icon(Icons.add, color: Colors.white, size: 95,),),
                       ),
                     ),
                   ],
                 ),
                 Expanded(child: SizedBox()),
                  Text(
                    "Or",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                   Text(
                    "Emergency Call",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color:  Color.fromARGB(255, 233, 16, 0),),
                  ),
  Expanded(child: SizedBox()),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
