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
            return Container(
              color: Colors.green,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        courses[index].image ?? 'No Name',
                        height: 100, // Adjust height to fit within grid item
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          courses[index].rating.toString(),
                          style: const TextStyle(fontSize: 8.0),
                        ),
                        const SizedBox(width: 4.0),
                        const Icon(Icons.star, size: 10.0),
                      ],
                    ),
                    Text(
                      courses[index].title ?? 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person_2_outlined, size: 10.0),
                        const SizedBox(width: 4.0),
                        Text(
                          courses[index].instructor?.name ?? 'No Name',
                          style: const TextStyle(fontSize: 8.0),
                        ),
                      ],
                    ),
                    Text(
                      courses[index].price.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                  ]),
            );
          }),
        );
      },
    );
    //     });
  }
}
