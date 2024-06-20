import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/components/loacate.dart';
import 'package:lifeline/rth.dart';
import 'package:lifeline/ui/home.dart';
import 'package:lifeline/ui/onboarding.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final user = FirebaseAuth.instance.currentUser;
  print(user);
    if (user != null) {
      try {
        String locationname = await getLocationName().timeout(Duration(seconds: 50));
        Map userInfo = await getuserdata().timeout(Duration(seconds: 50));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(locationname: locationname, userdata: userInfo),
          ),
        );
      } catch (e) {
        // Handle timeout or other errors
        print("Error: $e");
        // Optionally navigate to an error page or show a dialog
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const onboard()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
}
