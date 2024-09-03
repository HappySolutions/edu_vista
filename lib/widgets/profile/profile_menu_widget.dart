import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    this.press,
  });

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: ColorUtility.deepYellow,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: ColorUtility.grayExtraLight,
        ),
        onPressed: press,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: ColorUtility.mediumlBlack,
                ),
              ),
            ),
            const Icon(
              Icons.double_arrow,
              color: ColorUtility.mediumlBlack,
            ),
          ],
        ),
      ),
    );
  }
}
