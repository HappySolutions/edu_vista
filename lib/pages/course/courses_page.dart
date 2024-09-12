import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/utils/image_utility.dart';
import 'package:edu_vista/widgets/course/all_courses_widget.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  final String query;
  final bool showAppbar;
  static const String id = 'courses';

  const CoursesPage({required this.query, super.key, required this.showAppbar});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool _idDownloaded = false;

  @override
  Widget build(BuildContext context) {
    print('CoursesPage - query: ${widget.query}'); // Debugging line
    return Scaffold(
      appBar: widget.showAppbar
          ? AppBar(
              title: Center(
                child: Text(capitalizeEachWord(widget.query)),
              ),
            )
          : const PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox.shrink(),
            ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _idDownloaded = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: !_idDownloaded
                              ? ColorUtility.deepYellow
                              : ColorUtility.grayLight,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            'All',
                            style: TextStyle(
                              color:
                                  !_idDownloaded ? Colors.white : Colors.black,
                            ),
                          ),
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
                          color: _idDownloaded
                              ? Colors.blue
                              : const Color(0xffE0E0E0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            'Downloaded',
                            style: TextStyle(
                              color:
                                  _idDownloaded ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _idDownloaded
                ? Image.asset(
                    ImageUtility.frame,
                  )
                : Expanded(
                    child: AllCoursesWidget(
                      query: widget.query,
                      selectedQuery: _idDownloaded ? 'downloaded' : '',
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String capitalizeEachWord(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

// import 'package:edu_vista/utils/image_utility.dart';
// import 'package:edu_vista/widgets/course/all_courses_widget.dart';
// import 'package:flutter/material.dart';

// class CoursesPage extends StatefulWidget {
//   final String query;
//   final bool showAppbar;
//   static const String id = 'courses';

//   const CoursesPage({required this.query, super.key, required this.showAppbar});

//   @override
//   State<CoursesPage> createState() => _CoursesPageState();
// }

// class _CoursesPageState extends State<CoursesPage> {
//   bool _idDownloaded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: widget.showAppbar
//           ? AppBar(
//               title: Center(
//                 child: Text(capitalizeEachWord(widget.query)),
//               ),
//             )
//           : const PreferredSize(
//               preferredSize: Size.zero,
//               child: SizedBox.shrink(),
//             ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                   height: 60,
//                   child: Row(children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _idDownloaded = false;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: !_idDownloaded
//                               ? Colors.blue
//                               : const Color(0xffE0E0E0),
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'All',
//                             style: TextStyle(
//                               color:
//                                   !_idDownloaded ? Colors.white : Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _idDownloaded = !_idDownloaded;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: _idDownloaded
//                               ? Colors.blue
//                               : const Color(0xffE0E0E0),
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Downloaded',
//                             style: TextStyle(
//                               color:
//                                   _idDownloaded ? Colors.white : Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ])),
//             ),
//             _idDownloaded
//                 ? Image.asset(
//                     ImageUtility.frame,
//                   )
//                 : Expanded(
//                     child: AllCoursesWidget(
//                       query: widget.query,
//                       selectedQuery: '',
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   String capitalizeEachWord(String text) {
//     return text.split(' ').map((word) {
//       if (word.isEmpty) return word;
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).join(' ');
//   }
// }

// // import 'package:edu_vista/utils/image_utility.dart';
// // import 'package:edu_vista/widgets/course/all_courses_widget.dart';
// // import 'package:flutter/material.dart';

// // class CoursesPage extends StatefulWidget {
// //   final String query;
// //   final bool showAppbar;
// //   static const String id = 'courses';

// //   const CoursesPage({required this.query, super.key, required this.showAppbar});

// //   @override
// //   State<CoursesPage> createState() => _CoursesPageState();
// // }

// // class _CoursesPageState extends State<CoursesPage> {
// //   bool _idDownloaded = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: widget.showAppbar
// //           ? AppBar(
// //               title: Center(
// //                 child: Text(capitalizeEachWord(widget.query)),
// //               ),
// //             )
// //           : const PreferredSize(
// //               preferredSize: Size.zero,
// //               child: SizedBox.shrink(),
// //             ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(10.0),
// //         child: Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: SizedBox(
// //                   height: 60,
// //                   child: Row(children: [
// //                     GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           _idDownloaded = false;
// //                         });
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 10),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xffE0E0E0),
// //                           borderRadius: BorderRadius.circular(40),
// //                         ),
// //                         child: const Center(
// //                           child: Text('All'),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 15),
// //                     GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           _idDownloaded = !_idDownloaded;
// //                         });
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.all(10),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xffE0E0E0),
// //                           borderRadius: BorderRadius.circular(40),
// //                         ),
// //                         child: const Center(
// //                           child: Text('Downloaded'),
// //                         ),
// //                       ),
// //                     ),
// //                   ])),
// //             ),
// //             _idDownloaded
// //                 ? Image.asset(
// //                     ImageUtility.frame,
// //                   )
// //                 : Expanded(
// //                     child: AllCoursesWidget(
// //                       query: widget.query,
// //                       selectedQuery: '',
// //                     ),
// //                   ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   String capitalizeEachWord(String text) {
// //     return text.split(' ').map((word) {
// //       if (word.isEmpty) return word;
// //       return word[0].toUpperCase() + word.substring(1).toLowerCase();
// //     }).join(' ');
// //   }
// // }
