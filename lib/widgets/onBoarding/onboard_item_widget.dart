import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/cupertino.dart';

class OnBoardItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  const OnBoardItemWidget(
      {required this.title,
      required this.image,
      required this.description,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtility.gbScaffold,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            height: 250,
            image,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: ColorUtility.gray,
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
