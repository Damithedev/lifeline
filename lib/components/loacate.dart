import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:http/http.dart' as http;
/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
    
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}



  Future<String> getLocationName(CollectionReference userref) async {
  Position position = await determinePosition();
    if (position != null) {
      double latitude = position.latitude;
      double longitude = position.longitude;
      
      userref.doc(FirebaseAuth.instance.currentUser?.uid).update({
      
        'lat': latitude,
        'lng': longitude,
      });

      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks != null && placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          return "${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        } else {
          return "Unknown Location";
        }
      } catch (e) {
        print('Error: $e');
        return "Unknown Location";
      }
    }
    return "Error in getting location try again";
  }
Future<List<User>> getNearbyUsers(double longitude, double latitude) async {
  final response = await http.get(Uri.parse('https://getclosebyusers-api.onrender.com/nearby?longitude=$longitude&latitude=$latitude'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    print("Good response");
    List<dynamic> jsonList = jsonDecode(response.body);
    List<User> users = jsonList.map((json) =>  User.fromJson(json)).toList();
    print( await users);
    return users;
  } else {
    // If the server does not return a 200 OK response, throw an exception.
    throw Exception('Failed to load users');
  }
}

class User {

  final String fcmToken;
  final String uid;

  const User({
  
    required this.fcmToken,
    required this.uid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fcmToken: json['FCM'] as String,
      uid: json['uid'] as String,
    );
  }

   @override
  String toString() {
    return 'User{fcmToken: $fcmToken, uid: $uid}';
  }
}
