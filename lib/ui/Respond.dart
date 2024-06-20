import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lifeline/rth.dart';
import 'package:lifeline/ui/Splashscreen.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Responder extends StatefulWidget {
  final String uid;
  final double distance;
  const Responder({Key? key, required this.uid, required this.distance}) : super(key: key);

  @override
  State<Responder> createState() => _ResponderState();
}

class _ResponderState extends State<Responder> {
  
  late IO.Socket socket;

  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>?;
      } else {
        print('No such document!');
        return null;
      }
    } catch (e) {
      print('Error getting user info: $e');
      return null;
    }
  }

  Future<String> getLocationName(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
      return "No address available";
    } catch (e) {
      print(e);
      return "Error: Unable to get address";
    }
  }

  @override
  void initState() {
    super.initState();
    // Ensure that dotenv is properly loaded
    
    // Initialize socket connection
    initializeSocket();
  }

  
  void initializeSocket() {
    socket = IO.io("https://getclosebyusers-api.onrender.com", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {
        'userId': uid, // Customize this as needed
      },
    });

    // Handle connection
    socket.onConnect((_) {
      print(uid);
      
      print('Connected to socket');
    });

    // Handle custom event
    
    // Handle disconnection
    socket.onDisconnect((_) {
      print('Disconnected from socket');
    });
  
    socket.onConnectError((err) {
      print('Connection error: $err');
    });

    socket.onError((err) {
      print('Socket error: $err');
    });

    // Connect the socket
    socket.connect();
   socket.on('accept', (data) async {
    print("DATA: $data");
  final SharedPreferences prefs =  await SharedPreferences.getInstance();
  
      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => MapVieww(Help: Position(longitude: data['longitude'], latitude:data['latitude'], timestamp: DateTime.now(),      // Example timestamp in milliseconds since Unix epoch (July 2, 2021 07:00:00 GMT)
    accuracy: 5.0,                 // Example accuracy in meters
    altitude: 30.0,                // Example altitude in meters
    altitudeAccuracy: 10.0,        // Example altitude accuracy in meters
    heading: 180.0,                // Example heading in degrees (south)
    headingAccuracy: 5.0,          // Example heading accuracy in degrees
    speed: 10.0,                   // Example speed in meters per second
    speedAccuracy: 0.5  ), Responder: Position(longitude: prefs.getDouble('longitude')!, latitude:prefs.getDouble('latitude')!,  timestamp: DateTime.now(),      // Example timestamp in milliseconds since Unix epoch (July 2, 2021 07:00:00 GMT)
    accuracy: 5.0,        
    altitude: 30.0,       
    altitudeAccuracy: 10.0,        
    heading: 180.0,               
    headingAccuracy: 5.0,          
    speed: 10.0,                 
    speedAccuracy: 0.5  ), role: "RE", data: data,)),
  (Route<dynamic> route) => false,
);
    },);
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserInfo(widget.uid),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('User not found'));
        } else {
          Map<String, dynamic>? userInfo = snapshot.data;
          String fname = userInfo?['firstname'] ?? '';
          String lname = userInfo?['lastname'] ?? '';
          double lat = userInfo?['lat'] ?? 0.0;
          double long = userInfo?['lng'] ?? 0.0;

          return FutureBuilder<String>(
            future: getLocationName(lat, long),
            builder: (BuildContext context, AsyncSnapshot<String> locationSnapshot) {
              if (locationSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (locationSnapshot.hasError) {
                return Center(child: Text('Error: ${locationSnapshot.error}'));
              } else if (!locationSnapshot.hasData || locationSnapshot.data == null) {
                return const Center(child: Text('Location not found'));
              } else {
                String locationName = locationSnapshot.data ?? 'Unknown location';
                double distance = widget.distance;
                return Scaffold(
                  backgroundColor: const Color.fromARGB(227, 245, 245, 255),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 50,),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "$fname $lname needs Help",
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "$locationName ($distance miles Away)",
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                        ),
                        const Spacer(),
                        HelpOption('images/firstaid.jpeg', 'First Aid Service', (){}),
                        const Spacer(),
                        HelpOption('images/drive.jpeg', 'Offer Ride to Hospital', (){
                            print("tap nigga");
                            showtimer("ride");
                          
                        }),
                        const Spacer(),
                        HelpOption('images/call.jpeg', 'Call to Assist', (){
                          showtimer("FA");
                        }),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
  Future<void> showtimer(String help) async {
    
  Position userposition = await determinePosition();
  socket.emit('RTH', {
    "responderuid": uid,
    "helpuid": widget.uid,
    "help": help,
    "distance": widget.distance,
    "longitude": userposition.longitude,
    "latitude": userposition.latitude
  });

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('Sending request'),
        content: SizedBox(
          width: 50,
          height: 40,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}
}


Widget HelpOption(String imageLocation, String title, Function helpfunc) {
  return InkWell(
    onTap: () => helpfunc(),
    child: Stack(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(31)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(31)), // Match the border radius
            child: Image.asset(
              imageLocation,
              fit: BoxFit.cover, // Use BoxFit.cover for better scaling
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 35,
            width: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(31), bottomRight: Radius.circular(31)),
              color: Colors.red,
            ),
            child: const Center(
              child: Text("Help   ->", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 20,
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
        ),
      ],
    ),
  );
}

