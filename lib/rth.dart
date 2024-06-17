import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lottie/lottie.dart' as lt;

class MapVieww extends StatefulWidget {
    final dynamic Longtitude;
  final dynamic Latitude;
  const MapVieww({super.key, this.Longtitude, this.Latitude});

  @override
  State<MapVieww> createState() => _MapViewwState();
}

class _MapViewwState extends State<MapVieww> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(future: getroute(  Position(
    longitude: -122.084,           // Example longitude for a location in California
    latitude: 37.422,              // Example latitude for a location in California
    timestamp: DateTime.now(),      // Example timestamp in milliseconds since Unix epoch (July 2, 2021 07:00:00 GMT)
    accuracy: 5.0,                 // Example accuracy in meters
    altitude: 30.0,                // Example altitude in meters
    altitudeAccuracy: 10.0,        // Example altitude accuracy in meters
    heading: 180.0,                // Example heading in degrees (south)
    headingAccuracy: 5.0,          // Example heading accuracy in degrees
    speed: 10.0,                   // Example speed in meters per second
    speedAccuracy: 0.5             // Example speed accuracy in meters per second
  ),  Position(
    longitude: -73.935242,         // Example longitude for a location in New York
    latitude: 40.730610,           // Example latitude for a location in New York
    timestamp: DateTime.parse("2024-06-17T10:00:00Z"), // Specific timestamp
    accuracy: 3.0,                 // Example accuracy in meters
    altitude: 15.0,                // Example altitude in meters
    altitudeAccuracy: 8.0,         // Example altitude accuracy in meters
    heading: 90.0,                 // Example heading in degrees (east)
    headingAccuracy: 3.0,          // Example heading accuracy in degrees
    speed: 8.0,                    // Example speed in meters per second
    speedAccuracy: 0.3             // Example speed accuracy in meters per second
  )), builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 18),
            ),
          );
        } else if (snapshot.hasData) {
        // Extracting data from snapshot object
        return FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(widget.Latitude, widget.Longtitude),
                initialZoom: 16,
              ),
              children: [
                PolylineLayer(polylines: [
                  Polyline(points: snapshot.data!,
                  color: Colors.red
                  )
                  
                ]),
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
                  point: LatLng(37.422, -122.084),
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
          );
      }
      return Center(
              child: CircularProgressIndicator(),
            );
    }
    
  ) ,
    );
    
  
  } 
  }
