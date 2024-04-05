import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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



  Future<String> getLocationName() async {
  Position position = await determinePosition();
    if (position != null) {
      double latitude = position.latitude;
      double longitude = position.longitude;

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
