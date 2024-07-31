import 'package:edu_vista/utils/image.utility.dart';
import 'package:edu_vista/widgets/onBoarding/on_boarding_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: OnBoardingItemWidget(
            image: ImageUtility.badges,
            title: 'Certification and Badges',
            subTitle: 'Earn a certificate after completion of every course'),
      ),
    );
  }
}
