import 'package:async_builder/async_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/pages/course/course_details_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class CoursesByCategoryWidget extends StatefulWidget {
  final String? categoryDataId;

  const CoursesByCategoryWidget({required this.categoryDataId, super.key});

  @override
  State<CoursesByCategoryWidget> createState() =>
      _CoursesByCategoryWidgetState();
}

class _CoursesByCategoryWidgetState extends State<CoursesByCategoryWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('category.id', isEqualTo: widget.categoryDataId)
        .orderBy('created_date', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

        var courses = List<Course>.from(value?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);
        var limitedCourses = courses.take(2).toList();

        return SizedBox(
          height: 200,
          child: GridView.count(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            children: List.generate(limitedCourses.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CourseDetailsPage.id,
                      arguments: courses[index]);
                },
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          courses[index].image ?? 'No Name',
                          height: 100, // Adjust height to fit within grid item
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5), // Space between elements
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  courses[index].rating.toString(),
                                  style: const TextStyle(
                                      fontSize: 10.0, color: ColorUtility.main),
                                ),
                                const SizedBox(width: 4.0),
                                // Display the stars based on rating
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    double rating =
                                        courses[index].rating ?? 0.0;
                                    if (starIndex < rating.floor()) {
                                      // Full star
                                      return const Icon(Icons.star,
                                          size: 15, color: ColorUtility.main);
                                    } else if (starIndex < rating) {
                                      // Half star
                                      return const Icon(Icons.star_half,
                                          size: 15, color: ColorUtility.main);
                                    } else {
                                      // Empty star
                                      return const Icon(Icons.star_border,
                                          size: 15, color: Colors.grey);
                                    }
                                  }),
                                ),
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
                            const SizedBox(
                                height: 8.0), // Space between elements
                            Text(
                              '\$${courses[index].price.toString()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.0,
                                  color: ColorUtility.main),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
