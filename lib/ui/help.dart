import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lifeline/rth.dart';
import 'package:lifeline/ui/Splashscreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lt;

class Scanpage extends StatefulWidget {
  final dynamic Longtitude;
  final dynamic Latitude;
  const Scanpage({super.key, required this.Latitude, required this.Longtitude});

  @override
  State<Scanpage> createState() => _ScanpageState();
}

class _ScanpageState extends State<Scanpage> {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final StreamController<Map<String, dynamic>> helpers = StreamController<Map<String, dynamic>>();
  late IO.Socket socket;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    findhelp();
    _fetchNearbyUsers();
  }

  @override
  void dispose() {
    socket.disconnect();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.Latitude, widget.Longtitude),
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/damilola555/clx8pn9m601zz01pn1ew5egs8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFtaWxvbGE1NTUiLCJhIjoiY2x2dGllYm1pMTg2bzJpbnZ3cDQ2cWVhcCJ9.zcbC4fyWaZcf5LNeXUVmkA',
                userAgentPackageName: 'com.example.app',
                additionalOptions: const {
                  "accesstoken": 'pk.eyJ1IjoiZGFtaWxvbGE1NTUiLCJhIjoiY2x2dGllYm1pMTg2bzJpbnZ3cDQ2cWVhcCJ9.zcbC4fyWaZcf5LNeXUVmkA',
                  "id": "mapbox.mapbox-streets-v8"
                },
              ),
              MarkerLayer(markers: [
                Marker(
                  width: 100.0,
                  height: 100.0,
                  point: LatLng(widget.Latitude, widget.Longtitude),
                  child: Stack(
                    children: [
                      lt.Lottie.asset('images/scan.json', width: double.infinity),
                      const Center(
                        child: CircleAvatar(
                          radius: 15, // Adjust the radius to control the size of the circle
                          backgroundColor: Colors.red, // Background color for the circle
                          child: Icon(
                            Icons.ac_unit_sharp,
                            size: 20,
                            color: Colors.white, // Color of the icon
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
               ListView.builder(
      shrinkWrap: true, // Add this
      // Add this
      itemBuilder: (context, index) {
         String helpofferd = '';
         double distance = items[index]['distance'];
       switch (items[index]['help']) {

        case "ride" :
        helpofferd = "Ride to Clinic";
        break;

        case "call":
        helpofferd = "Offer Call help";
        break;

        case "FA":
        helpofferd = "First Aid Service";
        break;
      }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color.fromARGB(255, 83, 79, 79)),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(items[index]['imgurl']),
                        radius: 20,
                       
                      ),
                    ),
                    
                
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                
                        Text(items[index]['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                        Text("$helpofferd ($distance Miles away)",style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12),),
                        
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 22,
                        child: ElevatedButton(
                        
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {},
                        
                                  child: const Text('Decline', style: TextStyle(color: Colors.white, fontSize: 13)),
                                ),
                      ),
                      SizedBox(
                        height: 22,
                        child: ElevatedButton(
                        
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    socket.emit('accept', items[index] );
                                    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Splashscreen(),
        ),
      );
                                  },
                        
                                  child: const Text('Accept', style: TextStyle(color: Colors.white, fontSize: 13)),
                                ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        );
      },
      itemCount: items.length,
    ),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20) )
                    
                  ),
                  child: const Center(child: Text("Looking For Help", style: TextStyle(fontWeight:  FontWeight.bold),))),
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("CANCEL REQUEST" , style: TextStyle(color: Colors.grey),),
                        ),
                      ),
                      const Text("|"),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("CALL AMBULANCE"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void findhelp() {
    // Create the socket instance
    socket = IO.io(dotenv.env["URL"], <String, dynamic>{
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
    socket.on('RTH', (data) async {
   Map<String,dynamic> info = await getuserinfoo(data['responderuid']);
   print(info);
   info['responderuid'] = data['responderuid'];
   info["distance"] = data["distance"];
   info["help"] = data["help"];
   info['helpuid'] = data['helpuid'];
      if(mounted){
        setState(() {
        items.add(info);
      });
      }
      
      print('Received data: $data');
    });

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
