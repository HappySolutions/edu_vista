import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/utils/app_enums.dart';
import 'package:edu_vista/widgets/course/course_options_widget.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/lecture_ships_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  void initState() {
    context.read<CourseBloc>().add(CourseFetchEvent(widget.course));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<CourseBloc, CourseState>(builder: (context, state) {
            if (state is LectureState) return const SizedBox();
            var stateEx = state is LectureChosenState ? state : null;
            return SizedBox(
              height: 250,
              child: VideoBox(
                controller: VideoController(
                  source: VideoPlayerController.networkUrl(
                    Uri.parse(stateEx!.lecture.lecture_url!),
                  ),
                ),
              ),
            );
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<CourseBloc, CourseState>(
                buildWhen: (previous, current) => current is LectureState,
                builder: (context, state) {
                  var applyChanges =
                      (state is LectureChosenState) ? true : false;
                  return AnimatedContainer(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: applyChanges
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            )
                          : null,
                      color: Colors.white,
                    ),
                    height: applyChanges
                        ? MediaQuery.sizeOf(context).height - 220
                        : null,
                    curve: Curves.easeInToLinear,
                    duration: const Duration(milliseconds: 350),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 30),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                widget.course.title ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.course.instructor?.name ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              child: BlocBuilder<CourseBloc, CourseState>(
                                buildWhen: (previous, current) =>
                                    current is! LectureState,
                                builder: (context, state) {
                                  return Column(children: [
                                    LectureChipsWidget(
                                      selectedOption:
                                          (state is CourseOptionStateChanges)
                                              ? state.courseOption
                                              : null,
                                      onChanged: (courseOptions) {
                                        context.read<CourseBloc>().add(
                                            CourseOptionChosenEvent(
                                                courseOptions));
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: (state is CourseOptionStateChanges)
                                          ? CourseOptionsWidget(
                                              courseOption: state.courseOption,
                                              course: context
                                                  .read<CourseBloc>()
                                                  .course!,
                                              onLectureClicked: (lecture) {
                                                context.read<CourseBloc>().add(
                                                    LectureChosenEvent(
                                                        lecture));
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ]);
                                },
                              ),
                            ),
                          ]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
