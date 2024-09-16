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
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
