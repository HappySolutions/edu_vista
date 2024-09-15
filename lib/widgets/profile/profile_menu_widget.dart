import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    this.textColor,
    this.iconColor,
    this.backgroundColor,
    this.press,
  });

  final String text;
  final Color? textColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: (backgroundColor != null)
              ? backgroundColor
              : ColorUtility.grayExtraLight,
        ),
        onPressed: press,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: (textColor != null)
                      ? textColor
                      : ColorUtility.mediumlBlack,
                ),
              ),
            ),
            Icon(
              Icons.double_arrow,
              color:
                  (iconColor != null) ? iconColor : ColorUtility.mediumlBlack,
            ),
          ],
        ),
      ),
    );
  }
}
