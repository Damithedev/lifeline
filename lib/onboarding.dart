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
      appBar: AppBar(
        title: Center(
            child: Text(
          "LifeLine",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, index) => Onboardcontent(
                image: 'images/onb2.png',
                description:
                    'Send out a distress signal with just a tap, and get matched with nearby, qualified volunteers who can offer assistance until professional help arrives. Every second counts in an emergency.',
                title: 'Help Arrives Faster',
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Add your button action here
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: Color.fromARGB(255, 221, 12, 12),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color.fromARGB(255, 221, 12, 12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Add your button action here
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          )
        ],
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            image,
            fit: BoxFit.fitWidth,
          ),
        ),
        Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
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
