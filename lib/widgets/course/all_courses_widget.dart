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
    print(
        'AllCoursesWidget - query: ${widget.query}, selectedQuery: ${widget.selectedQuery}'); // Debugging line
    if (widget.query.isEmpty) {
      futureCall = FirebaseFirestore.instance
          .collection('courses')
          .orderBy('created_date', descending: true)
          .get();
    } else {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('courses')
          .where('rank', isEqualTo: widget.query.toLowerCase())
          .orderBy('created_date', descending: true);

      if (widget.selectedQuery.isNotEmpty) {
        query = query.where('downloaded',
            isEqualTo: widget.selectedQuery.toLowerCase() == 'downloaded');
      }

      futureCall = query.get();
    }
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
                          child: CachedNetworkImage(
                            imageUrl: courses[index].image ?? '',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
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
                    )),
              ),
            );
          }),
        );
      },
    );
  }
}

// import 'package:async_builder/async_builder.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:edu_vista/models/course.dart';
// import 'package:edu_vista/pages/course/course_details_page.dart';
// import 'package:edu_vista/utils/color.utility.dart';
// import 'package:flutter/material.dart';

// class AllCoursesWidget extends StatefulWidget {
//   final String query;
//   final String selectedQuery;

//   const AllCoursesWidget({
//     required this.query,
//     required this.selectedQuery,
//     super.key,
//   });

//   @override
//   State<AllCoursesWidget> createState() => _AllCoursesWidgetState();
// }

// class _AllCoursesWidgetState extends State<AllCoursesWidget> {
//   late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

//   @override
//   void initState() {
//     _fetchCourses();
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant AllCoursesWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.query != widget.query ||
//         oldWidget.selectedQuery != widget.selectedQuery) {
//       _fetchCourses();
//     }
//   }

//   void _fetchCourses() {
//     if (widget.selectedQuery.isEmpty) {
//       futureCall = FirebaseFirestore.instance
//           .collection('courses')
//           .orderBy('created_date', descending: true)
//           .get();
//     } else {
//       futureCall = FirebaseFirestore.instance
//           .collection('courses')
//           .where('rank', isEqualTo: widget.selectedQuery.toLowerCase())
//           .orderBy('created_date', descending: true)
//           .get();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AsyncBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       future: futureCall,
//       waiting: (context) => const Center(child: CircularProgressIndicator()),
//       error: (context, error, stackTrace) => Text('Error! $error'),
//       builder: (context, value) {
//         if ((value?.docs.isEmpty ?? false)) {
//           return const Center(
//             child: Text('No courses found'),
//           );
//         }

//         var courses = List<Course>.from(value?.docs
//                 .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
//                 .toList() ??
//             []);

//         if (widget.query.isNotEmpty) {
//           courses = courses.where((course) {
//             return course.title?.toLowerCase().contains(widget.query) ?? false;
//           }).toList();
//         }

//         return ListView(
//           children: List.generate(courses.length, (index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pushNamed(context, CourseDetailsPage.id,
//                       arguments: courses[index]);
//                 },
//                 child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: ColorUtility.gray, width: 0.02),
//                     ),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: CachedNetworkImage(
//                             imageUrl: courses[index].image ?? '',
//                             placeholder: (context, url) =>
//                                 const CircularProgressIndicator(),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                             width: 140,
//                             height: 140,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   courses[index].rating.toString(),
//                                   style: const TextStyle(
//                                       fontSize: 10.0, color: ColorUtility.main),
//                                 ),
//                                 const SizedBox(width: 4.0),
//                                 const Icon(Icons.star,
//                                     size: 15, color: ColorUtility.main),
//                               ],
//                             ),
//                             Text(
//                               courses[index].title ?? 'No Name',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 12.0,
//                               ),
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(width: 8.0),
//                             Row(
//                               children: [
//                                 const Icon(Icons.person_2_outlined),
//                                 Text(
//                                   courses[index].instructor?.name ?? 'No Name',
//                                   style: const TextStyle(
//                                       fontSize: 10.0,
//                                       fontWeight: FontWeight.w400),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8.0),
//                             Text(
//                               '\$${courses[index].price.toString()}',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 12.0,
//                                   color: ColorUtility.main),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }
