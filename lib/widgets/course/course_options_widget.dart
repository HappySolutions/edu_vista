import 'package:async_builder/async_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/lecture.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista/utils/app_enums.dart';

class CourseOptionsWidget extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;
  const CourseOptionsWidget(
      {required this.courseOption, required this.course, super.key});

  @override
  State<CourseOptionsWidget> createState() => _CourseOptionsWidgetState();
}

class _CourseOptionsWidgetState extends State<CourseOptionsWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.course.id)
        .collection('lectures')
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        return AsyncBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: futureCall,
          waiting: (context) =>
              const Center(child: CircularProgressIndicator()),
          error: (context, error, stackTrace) => Text('Error! $error'),
          builder: (context, value) {
            if ((value?.docs.isEmpty ?? false)) {
              return const Center(
                child: Text('No Lectures found'),
              );
            }

            var lectures = List<Lecture>.from(value?.docs
                    .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
                    .toList() ??
                []);

            return GridView.count(
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              children: List.generate(lectures.length, (index) {
                return InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lectures[index].title ?? 'No Name',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          lectures[index].description ?? 'No Name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0), // Space between elements
                        Text(
                          '${lectures[index].duration.toString()} Seconds',
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        );
      case CourseOptions.Download:
        return const SizedBox.shrink();

      case CourseOptions.Certificate:
        return const SizedBox.shrink();

      case CourseOptions.More:
        return const SizedBox.shrink();
      default:
        return Text('Invalide Option ${widget.courseOption.name}');
    }
  }
}
