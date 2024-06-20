import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lottie/lottie.dart' as lt;

class FAMapVieww extends StatefulWidget {
  final Position Help;
  final Position Responder;
  final String role;
  final Map<String, dynamic> data;
  const FAMapVieww({super.key, required this.Help, required this.Responder, required this.role, required this.data});

  @override
  State<FAMapVieww> createState() => _FAMapViewwState();
}

class _FAMapViewwState extends State<FAMapVieww> {
  Map<String, dynamic>? userdataa;
  
  @override
  void initState() {
    super.initState();
    getuserdetails();
  }

  Future<void> getuserdetails() async {
    if (widget.role == "HE") {
      var userinfoo = await getuserinfoo(widget.data['responderuid']);
      
      setState(() {
        userdataa = userinfoo;
      });
    }
    else{
      var userinfoo = await getuserinfoo(widget.data['helpuid']);
      
      setState(() {
        userdataa = userinfoo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getroute(widget.Help, widget.Responder),
        builder: (context, snapshot) {
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
            Map<String, double> centerpoint = calculateMidpoint(
              widget.Help.latitude,
              widget.Help.longitude,
              widget.Responder.latitude,
              widget.Responder.longitude
            );

            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(centerpoint['latitude']!, centerpoint['longitude']!),
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
                    PolylineLayer(polylines: [
                      Polyline(
                        points: snapshot.data!,
                        color: const Color.fromARGB(255, 221, 113, 105),
                        strokeWidth: 3,
                      )
                    ]),
                    MarkerLayer(markers: [
                      Marker(
                        point: LatLng(widget.Responder.latitude, widget.Responder.longitude),
                        child: Stack(
                          children: [
                            widget.role == "RE" ? lt.Lottie.asset('images/scan.json', width: 200) : Container(),
                            Center(
                              child: Icon(Icons.add, size: 20,)
                            ),
                          ],
                        ),
                      ),
                      Marker(
                        width: 100.0,
                        height: 100.0,
                        point: LatLng(widget.Help.latitude, widget.Help.longitude),
                        child: Stack(
                          children: [

                            
                            widget.role == "HE" ? lt.Lottie.asset('images/scan.json', width: double.infinity) : Container(),
                            const Center(
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.ac_unit_sharp,
                                  size: 20,
                                  color: Colors.white,
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
                  bottom: 30,
                  left: 0,
                  right: 0,
                
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey[400],
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: CircleAvatar(
                                    backgroundImage: userdataa != null
                                        ? NetworkImage(userdataa!['imgurl'])
                                        : null,
                                    radius: 25,
                                    child: userdataa == null ? CircularProgressIndicator() : null,
                                  ),
                                ),
                                if (userdataa != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        userdataa!['name'],
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                                      ),
                                      Text(
                                        "First Aid Service",
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 14),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    "Loading user data...",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12),
                                  ),
                                InkWell(
                                  onTap: () {
                                    // Add your onTap logic here
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.green[400],
                                    child: Icon(Icons.call, color: Colors.white,),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
