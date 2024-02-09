import 'package:flutter/material.dart';
import 'package:lifeline/onboarding.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    // Introducing a 3-second delay before navigating to the main screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => onboard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x1A1A1A),
      body: Column(
        children: [
          Expanded(
              child:
                  Center(child: Image(image: AssetImage("images/logo.png")))),
          Lottie.asset('images/loadanimation.json', width: 100),
        ],
      ),
    );
  }
}
