import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class ExpandedCategoryMenuItem extends StatefulWidget {
  const ExpandedCategoryMenuItem({
    super.key,
    required this.text,
    this.press,
  });

  final String text;
  final VoidCallback? press;

  @override
  State<ExpandedCategoryMenuItem> createState() =>
      _ExpandedCategoryMenuItemState();
}

class _ExpandedCategoryMenuItemState extends State<ExpandedCategoryMenuItem> {
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
        onPressed: widget.press,
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.text,
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
