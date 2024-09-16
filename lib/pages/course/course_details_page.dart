// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/blocs/lecture/lecture_bloc.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/course/course_details_body_widget.dart';
import 'package:edu_vista/widgets/lecture/video_box.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CourseDetailsPage extends StatefulWidget {
  static const String id = 'course_details';
  final Course course;
  const CourseDetailsPage({required this.course, super.key});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  String? _userId;

  @override
  void initState() {
    context.read<CourseBloc>().add(CourseFetchEvent(widget.course));
    context.read<LectureBloc>().add(LectureEventInitial());
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  bool applyChanges = false;

  void initAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        applyChanges = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    initAnimation();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Image.network(
            widget.course.image ?? 'No Name',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // video bloc
          BlocBuilder<LectureBloc, LectureState>(builder: (ctx, state) {
            var stateEx = state is LectureChosenState ? state : null;

            if (stateEx == null) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              height: 250,
              width: double.infinity,
              child: stateEx.lecture.lecture_url == null ||
                      stateEx.lecture.lecture_url == ''
                  ? const Center(
                      child: Text(
                      'Invalid Url',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))
                  : VideoBoxWidget(
                      url: stateEx.lecture.lecture_url ?? '',
                    ),
            );
          }),

          Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                duration: const Duration(seconds: 3),
                alignment: Alignment.bottomCenter,
                // height: MediaQuery.sizeOf(context).height - 220,
                height: applyChanges
                    ? MediaQuery.sizeOf(context).height - 220
                    : null,
                curve: Curves.easeInOut,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.course.title ?? 'No Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.course.instructor?.name ??
                                  'No Instructor Name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                            TextButton(
                              onPressed: () async {
                                final cartCollection =
                                    _firestore.collection('cart');
                                final cartQuery = await cartCollection
                                    .where('user_id', isEqualTo: _userId)
                                    .where('title',
                                        isEqualTo: widget.course.title)
                                    .get();

                                if (cartQuery.docs.isNotEmpty) {
                                  // Course is already in the cart
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Course already added to cart.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  await _addToCart(cartCollection, context);
                                }
                              },
                              child: const Text('Add To Cart'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CourseDetailsBodyWidget(
                          course: widget.course,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            top: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorUtility.main,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _addToCart(
      CollectionReference<Map<String, dynamic>> cartCollection,
      BuildContext context) async {
    final idCourseToCart = uuid.v4();
    try {
      await cartCollection.doc(idCourseToCart).set({
        'id': idCourseToCart,
        'user_id': _userId,
        'title': widget.course.title,
        'image': widget.course.image,
        'instructor': {
          'name': widget.course.instructor?.name,
          'graduation_from': widget.course.instructor?.graduation_from,
          'years_of_experience': widget.course.instructor?.years_of_experience,
        },
        'price': widget.course.price,
        'rating': widget.course.rating,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course added to cart successfully!'),
          backgroundColor: ColorUtility.deepYellow,
        ),
      );
      Navigator.pushNamed(context, 'cart');
    } on FirebaseException catch (e) {
      print(e.message ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add course to cart.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
