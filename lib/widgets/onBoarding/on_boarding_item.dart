import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class OnBoardingItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  const OnBoardingItemWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: Image.asset(image),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: ColorUtility.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
