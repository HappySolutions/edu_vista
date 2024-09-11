// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/blocs/lecture/lecture_bloc.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/widgets/course/course_options_widgets.dart';
import 'package:edu_vista/widgets/lecture/lecture_chips.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailsBodyWidget extends StatefulWidget {
  final Course course;
  const CourseDetailsBodyWidget({required this.course, super.key});

  @override
  State<CourseDetailsBodyWidget> createState() =>
      _CourseDetailsBodyWidgetState();
}

class _CourseDetailsBodyWidgetState extends State<CourseDetailsBodyWidget> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? _courseId;
  String? _userId;
  //TODO progress
  bool _lecturesWatched = false;

  @override
  void initState() {
    context.read<CourseBloc>();
    context.read<LectureBloc>().add(LectureEventInitial());
    super.initState();
    _getCurrentUserAndCourseId();
  }

  Future<void> _getCurrentUserAndCourseId() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _courseId = widget.course.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CourseBloc, CourseState>(builder: (ctx, state) {
        return Column(
          children: [
            LectureChipsWidget(
              selectedOption: (state is CourseOptionStateChanges)
                  ? state.courseOption
                  : null,
              onChanged: (courseOption) {
                context
                    .read<CourseBloc>()
                    .add(CourseOptionChosenEvent(courseOption));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: (state is CourseOptionStateChanges)
                    ? CourseOptionsWidgets(
                        course: context.read<CourseBloc>().course!,
                        courseOption: state.courseOption,
                        onLectureChosen: (lecture) async {
                          String documentId = '${_userId}_$_courseId';
                          try {
                            await _firestore
                                .collection('course_user_progress')
                                .doc(documentId)
                                .update({
                              'lecturesWatched': FieldValue.increment(1),
                            });

                            setState(() {
                              _lecturesWatched = true;
                            });
                          } catch (e) {
                            _firestore
                                .collection('course_user_progress')
                                .doc(documentId)
                                .set({
                              'userId': _userId,
                              'courseId': _courseId,
                              'lecturesWatched': FieldValue.increment(1),
                            }, SetOptions(merge: true));
                          }
                          context
                              .read<LectureBloc>()
                              .add(LectureChosenEvent(lecture));
                        },
                      )
                    : const SizedBox.shrink())
          ],
        );
      }),
    );
  }
}

/*
  Future<void> _getLecturesWatched() async {
    try {
      String documentId = '${_userId}_$_courseId';
      DocumentSnapshot snapshot = await _firestore
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
 */