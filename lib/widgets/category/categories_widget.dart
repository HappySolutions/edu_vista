import 'package:async_builder/async_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category_data.dart';
import 'package:edu_vista/pages/categories/category_courses_page.dart';
import 'package:flutter/material.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  var futureCall = FirebaseFirestore.instance
      .collection('categories')
      .orderBy('name', descending: true)
      .get();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: AsyncBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: futureCall,
        waiting: (context) => const Center(child: CircularProgressIndicator()),
        error: (context, error, stackTrace) => Text('Error! $error'),
        builder: (ctx, value) {
          if ((value?.docs.isEmpty ?? false)) {
            return const Center(
              child: Text('No categories found'),
            );
          }
          List<CategoryData> categories = List<CategoryData>.from(value?.docs
                  .map((e) => CategoryData.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);
          var limitedCategories = categories.take(3).toList();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: limitedCategories.length,
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.pushNamed(context, CategoryCoursesPage.id,
                  arguments: categories[index]),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(categories[index].name ?? 'No Name'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
