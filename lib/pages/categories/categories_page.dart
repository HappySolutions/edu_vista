import 'package:edu_vista/widgets/category/expanded_category_menu_widget.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  static const String id = 'categories';

  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ExpandedCategoryMenu(),
    );
  }
}
