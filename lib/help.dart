import 'dart:async';


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
      appBar: AppBar(backgroundColor: Colors.transparent),
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
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.red,
                              size: 95,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

             Expanded(child: ListView.builder(itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]['helpuid'] as String),
            );
          } ,
          itemCount: items.length,
          )),
           ],
        ),
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
   Map info = await getuserinfoo(data['responderuid']);
   print(info);
      if(mounted){
        setState(() {
        items.add(data);
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
