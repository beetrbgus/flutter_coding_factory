import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageHomeScreen extends StatefulWidget {
  const ImageHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ImageHomeScreenState();
}

class _ImageHomeScreenState extends State<ImageHomeScreen> {
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        print("돌아간다앙");
        int? nextPage = pageController.page?.toInt();

        if (nextPage == null) return;

        if (nextPage == 4) {
          nextPage = 0;
        } else {
          nextPage++;
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      // body: Container(),
      body: PageView(
        controller: pageController,
        children: [1, 2, 3, 4, 5]
            .map(
              (e) => Image.asset(
                'asset/images/고양이$e.jpg',
                fit: BoxFit.contain,
              ),
            )
            .toList(),
      ),
    );
  }
}
