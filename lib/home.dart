import 'package:flutter/material.dart';

import 'package:lifeline/help.dart';

class Home extends StatefulWidget {
  String locationname;
  Map userdata;
  Home({super.key, required this.locationname, required this.userdata});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 20),
                  Text(
                    widget.locationname,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const Expanded(child: SizedBox()),
                  widget.userdata['imgurl'] == null ? const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('images/dp.jpg') 
                              ) :  CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(widget.userdata['imgurl'].toString())
                              ),
                            
                ],
              ),
            ),
            backgroundColor: const Color.fromARGB(227, 245, 245, 255),
            body: Center(
              child: Column(
                
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    "Need Emergency Health \n  Services?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "Just hold the button to call",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                const Expanded(child: SizedBox()),
                 InkWell(
                  onTap: () async{
                    Navigator.of(context).push(
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 800), // Forward Duration
    reverseTransitionDuration: const Duration(milliseconds: 800), // Reverse Duration
    pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Scanpage(Latitude: widget.userdata['Latitude'] , Longtitude: widget.userdata['Longtitude'],);
    },
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);
                 

                  },
                   child: const Stack(
                     children: [
                       CircleAvatar(
                        backgroundColor: Color.fromARGB(105, 117, 117, 117),
                        radius: 120,
                       
                       ),
                       Positioned(
                        left: 10,
                        top: 10,
                         child: Hero(
                          tag: 'mainbtn',
                           child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 233, 16, 0),
                            radius: 110,
                            child: Center(child: Icon(Icons.add, color: Colors.white, size: 95,),),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
                 const Expanded(child: SizedBox()),
                  const Text(
                    "Or",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                   const Text(
                    "Emergency Call",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color:  Color.fromARGB(255, 233, 16, 0),),
                  ),
  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          );
  }
}