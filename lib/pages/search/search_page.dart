import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/course/all_courses_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'search';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  String selectedQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildQueryButton('All Courses', ''),
                    const SizedBox(width: 15),
                    _buildQueryButton('Top Rated', 'Top Rated'),
                    const SizedBox(width: 15),
                    _buildQueryButton('Top Seller', 'Top Seller'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: AllCoursesWidget(
                query: query,
                selectedQuery: selectedQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryButton(String text, String queryValue) {
    bool isSelected = selectedQuery == queryValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedQuery = queryValue;
          query = ''; // Reset search query when selecting a filter
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? ColorUtility.deepYellow : ColorUtility.grayLight,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorUtility.mediumlBlack,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// class SearchPage extends StatefulWidget {
//   static const String id = 'search';

//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   String query = '';
//   String selectedQuery = ''; // Add this variable to track the selected query

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 height: 60,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _buildQueryButton('All Courses', ''),
//                     const SizedBox(width: 15),
//                     _buildQueryButton('Top Rated', 'Top Rated'),
//                     const SizedBox(width: 15),
//                     _buildQueryButton('Top Seller', 'Top Seller'),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: AllCoursesWidget(
//                 query: query,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQueryButton(String text, String queryValue) {
//     bool isSelected =
//         queryValue == selectedQuery; 
        
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           query = queryValue;
//           selectedQuery = queryValue; 
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? ColorUtility.deepYellow : ColorUtility.grayLight,
//           borderRadius: BorderRadius.circular(40),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: isSelected ? Colors.white : ColorUtility.mediumlBlack,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
