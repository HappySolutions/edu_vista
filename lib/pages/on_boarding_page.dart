import 'package:edu_vista/utils/image.utility.dart';
import 'package:edu_vista/widgets/onBoarding/on_boarding_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(
      initialPage: 1,
      viewportFraction: 1,
    );

    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal, // or Axis.vertical
        children: const [
          OnBoardingItemWidget(
              image: ImageUtility.badges,
              title: 'Certification and Badges',
              subTitle: 'Earn a certificate after completion of every course'),
          OnBoardingItemWidget(
              image: ImageUtility.progressTracking,
              title: 'Progress Tracking',
              subTitle: 'Check your Progress of every course'),
          OnBoardingItemWidget(
              image: ImageUtility.offline,
              title: 'Offline Access',
              subTitle: 'Make your course available offline'),
          OnBoardingItemWidget(
              image: ImageUtility.courseCategory,
              title: 'Course Catalog',
              subTitle: 'View in which courses you are enrolled'),
        ],
      ),
    );
  }
}
