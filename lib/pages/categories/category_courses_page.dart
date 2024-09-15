import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category_data.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/pages/course/course_details_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class CategoryCoursesPage extends StatefulWidget {
  static const String id = 'category_courses';
  final CategoryData categoryData;

  const CategoryCoursesPage({required this.categoryData, super.key});

  @override
  State<CategoryCoursesPage> createState() => _CategoryCoursesPageState();
}

class _CategoryCoursesPageState extends State<CategoryCoursesPage> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  void _fetchCourses() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('courses')
        .orderBy('created_date', descending: true);

    query = query.where('category.id', isEqualTo: widget.categoryData.id);

    futureCall = query.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.categoryData.name ?? 'No Name')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _getCoursesByCategoryWidget(),
        ),
      ),
    );
  }

  Widget _getCoursesByCategoryWidget() {
    return AsyncBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: futureCall,
      waiting: (context) => const Center(child: CircularProgressIndicator()),
      error: (context, error, stackTrace) => Text('Error! $error'),
      builder: (context, value) {
        if ((value?.docs.isEmpty ?? false)) {
          return const Center(
            child: Text('No courses found'),
          );
        }

        // Map Firestore data to a list of Course objects
        var courses = List<Course>.from(value?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        if (courses.isEmpty) {
          return const Center(
            child: Text('No courses found'),
          );
        }

        return ListView(
          children: List.generate(courses.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CourseDetailsPage.id,
                      arguments: courses[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorUtility.gray, width: 0.02),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Uri.parse(courses[index].image ?? '')
                                .hasAbsolutePath
                            ? CachedNetworkImage(
                                imageUrl: courses[index].image ?? '',
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.account_circle,
                                        color: Colors.grey),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              )
                            : const CircularProgressIndicator(),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                courses[index].rating.toString(),
                                style: const TextStyle(
                                    fontSize: 10.0, color: ColorUtility.main),
                              ),
                              const SizedBox(width: 4.0),
                              const Icon(Icons.star,
                                  size: 15, color: ColorUtility.main),
                            ],
                          ),
                          Text(
                            courses[index].title ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8.0),
                          Row(
                            children: [
                              const Icon(Icons.person_2_outlined),
                              Text(
                                courses[index].instructor?.name ?? 'No Name',
                                style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '\$${courses[index].price.toString()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12.0,
                                color: ColorUtility.main),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
