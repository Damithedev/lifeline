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
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const onboard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x001a1a1a),
      body: Column(
        children: [
          const Expanded(
              child:
                  Center(child: Image(image: AssetImage("images/logo.png")))),
          Lottie.asset('images/loadanimation.json', width: 100),
        ],
      ),
    );
  }
}
