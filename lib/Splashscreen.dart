import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lifeline/home.dart';
import 'package:lifeline/onboarding.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    _initializeApp(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Image(image: AssetImage("images/logo.png")),
            ),
          ),
          Lottie.asset('images/loadanimation.json', width: 100),
        ],
      ),
    );
  }

  Future<void> _initializeApp(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
    
      String locationname = await getLocationName();
      Map userInfo = await getuserdata();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(locationname: locationname, userdata: userInfo),
        ),
      );
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const onboard()),
        );
      });
    }
  }

}
