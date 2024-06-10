import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lifeline/Accountsetup.dart';
import 'package:lifeline/Respond.dart';
import 'package:lifeline/Splashscreen.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lifeline/onboarding.dart';
import 'package:rxdart/rxdart.dart';
  
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());

  await _initializeFirebaseMessaging();
}

Future<void> _initializeFirebaseMessaging() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final messageStreamController = BehaviorSubject<RemoteMessage>();

  // Request notification permissions
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Request location permissions
  await _requestLocationPermission();

  // Get and print the token
  String? token = await messaging.getToken();
  if (kDebugMode) {
    print('Registration Token=$token');
  }

  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
    messageStreamController.sink.add(message);
  });

  // Handle messages when the app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a message opened from a notification: ${message.messageId}');
      print('Message data: ${message.data}');
    }
    // Handle navigation based on the message data
    _handleMessageNavigation(message);
  });

  // Handle messages when the app is launched from a terminated state
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    _handleMessageNavigation(initialMessage);
  }
}

void _handleMessageNavigation(RemoteMessage message) {
  final data = message.data;
  if (data['route'] == 'Responder') {
String uid = data['uid'].toString();
double distance = double.parse(data['distance']);
    Navigator.push(
      MyApp.navigatorKey.currentState!.context,
      MaterialPageRoute(builder: (context) =>  Responder(uid: uid, distance: distance,)),
    );
  }
}

Future<void> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied, we cannot request permissions.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Splashscreen(),
      navigatorKey: navigatorKey,
    );
  }
}