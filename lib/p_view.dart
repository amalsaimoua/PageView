// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:pageview/main.dart';

class Data {
  final String title;
  final String description;
  final String imageUrl;
  final IconData iconData;

  Data({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.iconData,
  });
}

class pView extends StatefulWidget {
  @override
  State<pView> createState() => _pViewState();
}

class _pViewState extends State<pView> {
  final PageController controller = PageController(
    initialPage: 0,
  );
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 6), (timer) {
      if (index < 3) index++;
      controller.animateToPage(
        index,
        duration: const Duration(seconds: 2),
        curve: Curves.easeIn,
      );
    });
  }
final pageIndexNotifier =ValueNotifier<int>(0);
  int index = 0;
  List<Data> myData = [
    Data(
      title: 'title 1',
      description: 'description 1',
      imageUrl: 'images/q1.jpg',
      iconData: Icons.add_box,
    ),
    Data(
      title: 'title 2',
      description: 'description 2',
      imageUrl: 'images/q2.jpg',
      iconData: Icons.add_circle,
    ),
    Data(
      title: 'title 3',
      description: 'description 3',
      imageUrl: 'images/q3.jpg',
      iconData: Icons.add_chart_outlined,
    ),
    Data(
      title: 'title 4',
      description: 'description 4',
      imageUrl: 'images/q4.jpg',
      iconData: Icons.add_road,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/a': (ctx) => const MyHomePage(title: 'hi')},
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          alignment: Alignment(0,0.7),
          children: [
          Builder(
            builder: (ctx) => PageView(
              controller: controller,
              onPageChanged: (val) {
                pageIndexNotifier.value = val;
                setState(() {
                  index = val;
                  // if (index == 3) {
                  //   Future.delayed(const Duration(seconds: 2),
                  //       () => Navigator.of(ctx).pushReplacementNamed('/a'));
                  // }
                });
              },
              children: myData
                  .map((item) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      image: ExactAssetImage(item.imageUrl),
                    )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.iconData,
                          size: 120,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                  .toList(),
            ),
          ),
          PageViewIndicator(
            pageIndexNotifier: pageIndexNotifier,
            length: myData.length,
            normalBuilder: (animationController, index) => Circle(
              size: 8.0,
              color: Colors.white,
            ),
            highlightedBuilder: (animationController, index) => ScaleTransition(
              scale: CurvedAnimation(
                parent: animationController,
                curve: Curves.ease,
              ),
              child:const Icon(
                Icons.star,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          // indicator(index),
          Builder(
            builder: (ctx) => Align(
              alignment: const Alignment(0, 0.93),
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: ()async {
                      Navigator.of(ctx).pushReplacementNamed('/a');
                     SharedPreferences prefs =await SharedPreferences.getInstance();
                     prefs.setBool('x', true);
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    )),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class indicator extends StatelessWidget {
  final int index;
  indicator(this.index);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0.7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildContainer(0),
          buildContainer(1),
          buildContainer(2),
          buildContainer(3),
        ],
      ),
    );
  }

  Widget buildContainer(int i) {
    return index == i
        ? const Icon(Icons.star)
        : Container(
            margin: const EdgeInsets.all(4),
            height: 15,
            width: 15,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          );
  }
}
