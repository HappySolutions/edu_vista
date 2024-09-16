import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/pages/course/course_details_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class AllCoursesWidget extends StatefulWidget {
  final String query;
  final String selectedQuery; // Added parameter for filtering by "downloaded"
  const AllCoursesWidget(
      {required this.query, required this.selectedQuery, super.key});

  @override
  State<AllCoursesWidget> createState() => _AllCoursesWidgetState();
}

class _AllCoursesWidgetState extends State<AllCoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  int _lecturesWatched = 0;

  var _userId;

  var _courseId;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  @override
  void didUpdateWidget(covariant AllCoursesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query ||
        widget.selectedQuery != oldWidget.selectedQuery) {
      _fetchCourses();
    }
  }

  void _fetchCourses() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('courses')
        .orderBy('created_date', descending: true);

    if (widget.selectedQuery.isNotEmpty) {
      query =
          query.where('rank', isEqualTo: widget.selectedQuery.toLowerCase());
    }

    // Remove the title filtering from Firestore query and do it locally
    futureCall = query.get();
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

        // Map Firestore data to a list of Course objects
        var courses = List<Course>.from(value?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        // Apply client-side filtering based on the search query
        if (widget.query.isNotEmpty) {
          courses = courses
              .where((course) =>
                  course.title
                      ?.toLowerCase()
                      .contains(widget.query.toLowerCase()) ??
                  false)
              .toList();
        }

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
                            children: [
                              Text(
                                courses[index].rating.toString(),
                                style: const TextStyle(
                                    fontSize: 10.0, color: ColorUtility.main),
                              ),
                              const SizedBox(width: 4.0),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  double rating = courses[index].rating ?? 0.0;
                                  if (starIndex < rating.floor()) {
                                    return const Icon(Icons.star,
                                        size: 15, color: ColorUtility.main);
                                  } else if (starIndex < rating) {
                                    return const Icon(Icons.star_half,
                                        size: 15, color: ColorUtility.main);
                                  } else {
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

  Future<void> _getLecturesWatched() async {
    try {
      String documentId = '${_userId}_$_courseId';
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('userCourses')
          .doc(documentId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _lecturesWatched = snapshot.get('lecturesWatched') as int;
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting lectures watched: $e');
    }
  }
}
