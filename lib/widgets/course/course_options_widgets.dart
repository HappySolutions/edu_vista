// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/lecture.dart';
import 'package:edu_vista/utils/app_enums.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/general/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseOptionsWidgets extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;
  final void Function(Lecture) onLectureChosen;
  const CourseOptionsWidgets({
    required this.courseOption,
    required this.course,
    required this.onLectureChosen,
    super.key,
  });

  @override
  State<CourseOptionsWidgets> createState() => _CourseOptionsWidgetsState();
}

class _CourseOptionsWidgetsState extends State<CourseOptionsWidgets> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;
  Map<String, bool> _expandedSections = {};
  List<Lecture>? lectures;
  bool isLoading = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200), () async {});
    if (!mounted) return;
    lectures = await context.read<CourseBloc>().getLectures();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Lecture? selectedLecture;

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        return _buildLectureSection('Lecture');

      case CourseOptions.Download:
        return _buildLectureSection('Download');

      case CourseOptions.Certificate:
        return _buildCertificateSection();

      case CourseOptions.More:
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildMoreSection('About Instructor'),
              _buildMoreSection('Course Resources'),
              _buildMoreSection('Share this Course'),
            ],
          ),
        );

      default:
        return Text('Invalid option ${widget.courseOption.name}');
    }
  }

  Widget _buildLectureSection(String title) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (lectures == null || (lectures!.isEmpty)) {
      return const Center(
        child: Text('No lectures found'),
      );
    }

    return GridView.count(
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.90,
      children: List.generate(lectures!.length, (index) {
        return _buildLectureTile(index, title);
      }),
    );
  }

  Widget _buildLectureTile(int index, String title) {
    final lecture = lectures![index];
    final isSelected = selectedLecture?.id == lecture.id;

    return InkWell(
      onTap: () async {
        if (title == 'Lecture') {
          widget.onLectureChosen(lecture);
          selectedLecture = lecture;
          setState(() {});
        } else {
          selectedLecture = lecture;
          setState(() {});
          final Uri url = Uri.parse('https://google.com');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            print('Could not launch $url');
          }
        }

        selectedLecture = lecture;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? ColorUtility.deepYellow : const Color(0xffE0E0E0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLectureHeader(index, isSelected, title),
            const SizedBox(height: 8),
            _buildLectureDetails(lecture, isSelected),
            const Spacer(),
            _buildLectureFooter(lecture, isSelected, title),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureHeader(int index, bool isSelected, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lecture ${index + 1}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Icon(
          title == 'Lecture'
              ? Icons.download_rounded
              : Icons.keyboard_double_arrow_right,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ],
    );
  }

  Widget _buildLectureDetails(Lecture lecture, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lecture.title ?? 'No Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          lecture.description ?? 'No description available',
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white70 : Colors.black54,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLectureFooter(Lecture lecture, bool isSelected, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Duration: ${lecture.duration ?? 'N/A'}',
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        CircleAvatar(
          radius: 15,
          backgroundColor: isSelected ? Colors.white : Colors.black,
          child: Icon(
            title == 'Lecture'
                ? Icons.play_arrow_rounded
                : Icons.play_circle_outlined,
            color: isSelected ? ColorUtility.deepYellow : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Course Completion Certificate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Certificate'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Congratulations on completing the course!'),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          child: Image.network(
                            'https://example.com/certificate_image.png', // Dummy certificate image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('View Certificate'),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreSection(String title) {
    bool isExpanded = _expandedSections[title] ?? false;

    String sectionContent;
    switch (title) {
      case 'About Instructor':
        sectionContent =
            'Instructor: ${widget.course.instructor?.name ?? 'Unknown'}\n'
            'Garadution Info: ${widget.course.instructor?.graduation_from ?? 'No Garadution Info available.'}';
        break;
      case 'Course Resources':
        sectionContent = 'Course Title: ${widget.course.title}\n'
            'Price: ${widget.course.price?.toStringAsFixed(2) ?? 'Free'}';
        break;
      case 'Share this Course':
        sectionContent = 'Share this course with your friends and colleagues.';
        break;
      default:
        sectionContent = 'No content available';
    }

    return ExpansionTile(
      showTrailingIcon: false,
      title: Container(
        decoration: BoxDecoration(
          border: isExpanded
              ? Border.all(
                  color: ColorUtility.deepYellow,
                  width: 2.0,
                )
              : null,
          borderRadius: BorderRadius.circular(6),
          color: isExpanded ? Colors.transparent : ColorUtility.grayExtraLight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isExpanded
                    ? ColorUtility.deepYellow
                    : ColorUtility.mediumlBlack,
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_down : Icons.double_arrow,
              color: isExpanded
                  ? ColorUtility.deepYellow
                  : ColorUtility.mediumlBlack,
            ),
          ],
        ),
      ),
      iconColor: ColorUtility.deepYellow,
      maintainState: true,
      collapsedBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide.none,
      ),
      onExpansionChanged: (expanded) {
        setState(() {
          _expandedSections[title] = expanded;
        });
      },
      children: [
        SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sectionContent,
                  style: const TextStyle(fontSize: 16),
                ),
                if (title == 'Share this Course')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: CustomElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri.parse('https://google.com');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print('Could not launch $url');
                        }
                      },
                      child: const Text('Share'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
