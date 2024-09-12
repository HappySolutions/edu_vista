import 'package:edu_vista/models/category_data.dart';
import 'package:edu_vista/widgets/course/courses_by_category_widget.dart';
import 'package:flutter/material.dart';

class CategoryCoursesPage extends StatefulWidget {
  static const String id = 'category_courses';
  final CategoryData categoryData;

  const CategoryCoursesPage({required this.categoryData, super.key});

  @override
  State<CategoryCoursesPage> createState() => _CategoryCoursesPageState();
}

class _CategoryCoursesPageState extends State<CategoryCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.categoryData.name ?? 'No Name')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CoursesByCategoryWidget(
            categoryDataId: widget.categoryData.id,
          ),
        ),
      ),
    );
  }
}
