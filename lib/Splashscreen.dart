import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x1A1A1A),
      body: Center(child: Image(image: AssetImage("images/logo.png"))),
    );
  }
}
