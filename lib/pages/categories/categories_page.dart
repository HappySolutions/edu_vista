import 'package:edu_vista/widgets/category/expanded_category_menu_widget.dart';
import 'package:edu_vista/widgets/profile/profile_menu_widget.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  static const String id = 'categories';

  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ExpandedCategoryMenuItem(
              text: "Edit",
              press: () => {},
            ),
            ExpandedCategoryMenuItem(
              text: "Settings",
              press: () {},
            ),
            ExpandedCategoryMenuItem(
              text: "Settings",
              press: () {},
            ),
            ExpandedCategoryMenuItem(
              text: "Achivements",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
