import 'package:edu_vista/utils/image_utility.dart';
import 'package:edu_vista/widgets/course/all_courses_widget.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  static const String id = 'courses';

  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool _idDownloaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 60,
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _idDownloaded = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffE0E0E0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: Text('All'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _idDownloaded = !_idDownloaded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xffE0E0E0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: Text('Downloaded'),
                        ),
                      ),
                    ),
                  ])),
            ),
            _idDownloaded
                ? Image.asset(
                    ImageUtility.frame,
                  )
                : const Expanded(
                    child: AllCoursesWidget(),
                  ),
          ],
        ),
      ),
    );
  }
}
