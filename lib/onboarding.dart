import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lifeline/auth.dart';
import 'package:page_transition/page_transition.dart';

class onboard extends StatefulWidget {
  const onboard({super.key});

  @override
  State<onboard> createState() => _onboardState();
}

class _onboardState extends State<onboard> {
  late PageController _pageController;
  int _pageindex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(239, 243, 246, 249),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
              child: Text(
            "LifeLine",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _pageindex = index;
                });
              },
              itemCount: data.length,
              itemBuilder: (context, index) => Onboardcontent(
                image: data[index].image,
                description: data[index].description,
                title: data[index].title,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    data.length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Dotindicator(
                            isActive: index == _pageindex,
                          ),
                        )),
              ],
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
                      color: Colors.transparent,
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
                        print(_pageController.page);
                        // Add your button action here
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                        if (_pageindex == data.length - 1) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: Signup()));
                        }
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

class Dotindicator extends StatelessWidget {
  const Dotindicator({super.key, this.isActive = false});
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive ? 7 : 6,
      width: 6,
      decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.red.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}

class Onboardtab {
  final String image, title, description;
  Onboardtab(
      {required this.title, required this.image, required this.description});
}

final List<Onboardtab> data = [
  Onboardtab(
    image: 'images/onb2.png',
    description:
        'Send out a distress signal with just a tap, and get matched with nearby, qualified volunteers who can offer assistance until professional help arrives. Every second counts in an emergency.',
    title: 'Help Arrives Faster',
  ),
  Onboardtab(
    image: 'images/onb1.png',
    description:
        'Download the app and connect with trained volunteers ready to help in emergencies. Together, we make our community stronger.',
    title: 'Ready to be a hero?',
  ),
  Onboardtab(
    image: 'images/onb3.png',
    description:
        'Connect with neighbors, learn from experts, and build a network of support for those in need.',
    title: 'More than just an app, a community',
  )
];

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            description,
            textAlign: TextAlign.center,
          ),
        ),
        Spacer()
      ],
    );
  }
}
