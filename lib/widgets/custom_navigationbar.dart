import 'package:flutter/material.dart';

class BottomNavBarItem {
  final IconData icon;
  BottomNavBarItem({
    required this.icon,
  });
}

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  final List<BottomNavBarItem> children;
  int curentIndex;
  final Color? backgroundColor;
  Function(int)? onTap;
  BottomNavBar(
      {super.key,
      required this.children,
      required this.curentIndex,
      this.backgroundColor,
      required this.onTap});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        border: Border.all(
          width: 0.1,
          // assign the color to the border color
          color: Colors.grey,
        ),
      ),
      width: double.infinity,
      height: 56,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.children.length,
          (index) => NavBarItem(
            index: index,
            item: widget.children[index],
            selected: widget.curentIndex == index,
            onTap: () {
              setState(() {
                widget.curentIndex = index;
                widget.onTap!(widget.curentIndex);
              });
            },
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class NavBarItem extends StatefulWidget {
  final BottomNavBarItem item;
  final int index;
  bool selected;
  final Function onTap;
  final Color? backgroundColor;
  NavBarItem({
    super.key,
    required this.item,
    this.selected = false,
    required this.onTap,
    this.backgroundColor,
    required this.index,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(minWidth: widget.selected ? 100 : 56),
        height: 56,
        decoration: BoxDecoration(
          color: widget.selected
              ? widget.backgroundColor ?? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.item.icon,
              color: widget.selected ? Colors.black : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
