import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Responder extends StatefulWidget {
  final String uid;
  final double distance;
  Responder({Key? key, required this.uid, required this.distance}) : super(key: key);

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
    socket = IO.io("http://10.0.2.2:7000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {
        'userId': uid, // Customize this as needed
      },
    });

    // Handle connection
    socket.onConnect((_) {
      
      
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('User not found'));
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
                return Center(child: CircularProgressIndicator());
              } else if (locationSnapshot.hasError) {
                return Center(child: Text('Error: ${locationSnapshot.error}'));
              } else if (!locationSnapshot.hasData || locationSnapshot.data == null) {
                return Center(child: Text('Location not found'));
              } else {
                String locationName = locationSnapshot.data ?? 'Unknown location';
                double distance = widget.distance;
                return Scaffold(
                  backgroundColor: const Color.fromARGB(227, 245, 245, 255),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: 50,),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "$fname $lname needs Help",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "$locationName ($distance miles Away)",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                        ),
                        Spacer(),
                        HelpOption('images/firstaid.jpeg', 'First Aid Service', (){}),
                        Spacer(),
                        HelpOption('images/drive.jpeg', 'Offer Ride to Hospital', (){
                            print("tap nigga");
                            showtimer("ride");
                          
                        }),
                        Spacer(),
                        HelpOption('images/call.jpeg', 'Call to Assist', (){}),
                        Spacer(),
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
  
  Future<void> showtimer(String help) {
    socket.emit('RTH', {"responderuid": widget.uid, "helpuid": widget.uid , "help": help});
     return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sending request'),
          content: SizedBox(
            width: 50,
            height: 40,
            child: Center(
              child: CircularProgressIndicator(
                
              ),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(31), bottomRight: Radius.circular(31)),
              color: Colors.red,
            ),
            child: Center(
              child: Text("Help   ->", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 20,
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
        ),
      ],
    ),
  );
}

