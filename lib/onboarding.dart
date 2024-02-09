import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class onboard extends StatefulWidget {
  const onboard({super.key});

  @override
  State<onboard> createState() => _onboardState();
}

class _onboardState extends State<onboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Onboardcontent(
          image: 'images/onb1.png',
          description: 'test',
          title: 'looo',
        ),
      ),
    );
  }
}

class Onboardcontent extends StatelessWidget {
  const Onboardcontent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });
  final String image, title, description;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Stack(
          children: [
            SvgPicture.asset(
              "images/onbg.svg",
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              top: 90,
              child: Image.asset(
                image,
                height: 250,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        Spacer()
      ],
    );
  }
}
