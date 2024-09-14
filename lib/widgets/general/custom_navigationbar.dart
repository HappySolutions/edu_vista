import 'package:flutter/material.dart';
import 'package:edu_vista/utils/color.utility.dart';

class BottomNavBarItem {
  final Widget icon;
  BottomNavBarItem({required this.icon});
}

class BottomNavBar extends StatelessWidget {
  final int curentIndex;
  final Function(int) onTap;
  final List<BottomNavBarItem> children;

  const BottomNavBar({
    Key? key,
    required this.curentIndex,
    required this.onTap,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        border: Border.all(
          width: 0.1,
          color: Colors.grey,
        ),
      ),
      width: double.infinity,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          children.length,
          (index) => GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: curentIndex == index
                        ? ColorUtility.deepYellow
                        : Colors.grey, // Change icon color
                    size: 24,
                  ),
                  child: children[index].icon,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 5,
                  width: 30,
                  decoration: BoxDecoration(
                    color: curentIndex == index
                        ? ColorUtility.deepYellow
                        : Colors
                            .transparent, // Yellow rectangle below selected icon
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
