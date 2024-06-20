import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';






 CollectionReference users = FirebaseFirestore.instance.collection('users');
 final messaging = FirebaseMessaging.instance;
 String? uid = FirebaseAuth.instance.currentUser?.uid;
 List listofpoints = [];
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
 Position position = await Geolocator.getCurrentPosition();
 final SharedPreferences prefs =  await SharedPreferences.getInstance();
 await prefs.setDouble('latitude', position.latitude);
 await prefs.setDouble('longitude', position.longitude);
  users.doc(uid).update({
    
      'lat': position.latitude,
      'lng': position.longitude,
    });
  
  return position;
}











  






Future<List<User>> getNearbyUsers(double longitude, double latitude ) async {
  String? base = dotenv.env["URL"];
  print(base); 
  try {
    final response = await http.get(Uri.parse('$base/nearby?longitude=$longitude&latitude=$latitude&uid=$uid'))
        .timeout(const Duration(milliseconds: 60000));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<User> users = jsonList.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      // If the server returns an error response, log the response body for debugging.
      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to get nearby users');
    }
  } catch (e) {
    // Handle timeout or other network-related errors.
    print('Network error: $e');
    throw Exception('Failed to connect to server');
  }
}

Future<String> getLocationName() async {
  Position position = await determinePosition();
    double latitude = position.latitude;
    double longitude = position.longitude;
    String? token = await messaging.getToken();
    users.doc(uid).update({
      'FCM': token,
      'lat': latitude,
      'lng': longitude,
    });

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
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


  Map<String, double> calculateMidpoint(double lat1, double lon1, double lat2, double lon2) {
  // Convert latitude and longitude from degrees to radians
  lat1 = lat1 * pi / 180;
  lon1 = lon1 * pi / 180;
  lat2 = lat2 * pi / 180;
  lon2 = lon2 * pi / 180;

  // Cartesian coordinates for the two points
  double X1 = cos(lat1) * cos(lon1);
  double Y1 = cos(lat1) * sin(lon1);
  double Z1 = sin(lat1);
  
  double X2 = cos(lat2) * cos(lon2);
  double Y2 = cos(lat2) * sin(lon2);
  double Z2 = sin(lat2);

  // Average the Cartesian coordinates
  double Xm = (X1 + X2) / 2;
  double Ym = (Y1 + Y2) / 2;
  double Zm = (Z1 + Z2) / 2;

  // Convert back to latitude and longitude
  double lonm = atan2(Ym, Xm);
  double hyp = sqrt(Xm * Xm + Ym * Ym);
  double latm = atan2(Zm, hyp);

  // Convert back to degrees
  latm = latm * 180 / pi;
  lonm = lonm * 180 / pi;

  return {'latitude': latm, 'longitude': lonm};
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











Future<Map> getuserdata() async{
 DocumentSnapshot userdata =  await users.doc(uid).get();
   return {'imgurl': userdata['profile picture'], 'Longtitude': userdata['lng'], 'Latitude': userdata['lat']};
      }



Future<Map<String, dynamic>> getuserinfoo(uiddd) async{
 DocumentSnapshot userdata =  await users.doc(uiddd).get();
   return {'imgurl': userdata['profile picture'], 'name': userdata['firstname'] + " " +userdata["lastname"]};
      }










Future<String> getLocationNameside(double lat, double long) async {
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


Future<List<LatLng>> getroute(Position startpoint , Position endpoint) async {
  print("https://api.mapbox.com/directions/v5/mapbox/driving/${startpoint.longitude},${startpoint.latitude};${endpoint.longitude},${endpoint.latitude}?alternatives=false&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1IjoiZGFtaWxvbGE1NTUiLCJhIjoiY2x2dGllYm1pMTg2bzJpbnZ3cDQ2cWVhcCJ9.zcbC4fyWaZcf5LNeXUVmkA");
  var response = await http.get(Uri.parse("https://api.mapbox.com/directions/v5/mapbox/driving/${startpoint.longitude},${startpoint.latitude};${endpoint.longitude},${endpoint.latitude}?alternatives=false&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1IjoiZGFtaWxvbGE1NTUiLCJhIjoiY2x2dGllYm1pMTg2bzJpbnZ3cDQ2cWVhcCJ9.zcbC4fyWaZcf5LNeXUVmkA"));
  if(response.statusCode == 200 ){
      var data = jsonDecode(response.body);
      
      listofpoints = data['routes'][0]['geometry']['coordinates'];
     
      List<LatLng> points = listofpoints.map((e) => LatLng(e[1].toDouble(), e[0].toDouble())).toList();
      print(points);
      return points;

  }
  else{
    throw Exception('Failed to get route');
  }
}

