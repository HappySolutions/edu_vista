import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:flutter/material.dart';
import 'package:async_builder/async_builder.dart';

class CoursesWidget extends StatefulWidget {
  final String rankValue;
  const CoursesWidget({required this.rankValue, super.key});

  @override
  State<CoursesWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rankValue)
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

        return GridView.count(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(courses.length, (index) {
            return Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(courses[index].image ?? 'No Name'),
              ),
              Row(children: [
                const Text('******'),
                Text(courses[index].title ?? 'No Name'),
              ]),
              Text(courses[index].title ?? 'No Name'),
              Row(children: [
                const Icon(Icons.percent_outlined),
                Text(courses[index].instructor?.name ?? 'No Name')
              ]),
              Text(
                courses[index].price.toString(),
              ),
            ]);
          }),
        );
      },
    );
    //     });
  }
}
