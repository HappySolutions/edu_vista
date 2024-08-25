import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/lecture_ships_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_box/video_box.dart';

class CourseDetailsPage extends StatefulWidget {
  static const String id = 'course_details';
  final Course course;

  const CourseDetailsPage({required this.course, super.key});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  double? height;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // SizedBox(
          //     height: 250,
          //     child: VideoBox(
          //         controller: VideoController(
          //       source: VideoPlayerController.networkUrl(
          //         Uri.parse(
          //             'https://resource.flexclip.com/templates/video/720p/simple-versatile-furniture-instagram-reel.mp4?v=1.0.5.19.86'),
          //       ),
          //     ),),),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: height != null
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      )
                    : null,
                color: Colors.white,
              ),
              height: height,
              curve: Curves.easeInToLinear,
              duration: const Duration(milliseconds: 350),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        widget.course.title ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.course.instructor?.name ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17),
                      ),
                      const SizedBox(height: 15),
                      LectureChipsWidget(onChanged: (courseOptions) {
                        setState(() {
                          height = MediaQuery.sizeOf(context).height - 220;
                        });
                      })
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
