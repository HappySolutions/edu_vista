import 'package:async_builder/async_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category_data.dart';
import 'package:edu_vista/pages/categories/category_courses_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/course/courses_by_category_widget.dart';
import 'package:flutter/material.dart';

class ExpandedCategoryMenu extends StatefulWidget {
  const ExpandedCategoryMenu({
    super.key,
  });

  @override
  State<ExpandedCategoryMenu> createState() => _ExpandedCategoryMenuState();
}

class _ExpandedCategoryMenuState extends State<ExpandedCategoryMenu> {
  var futureCall = FirebaseFirestore.instance.collection('categories').get();
  List<bool> _isExpandedList = [];
  List<CategoryData> categories = [];
  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: futureCall,
        waiting: (context) => const Center(child: CircularProgressIndicator()),
        error: (context, error, stackTrace) => Text('Error! $error'),
        builder: (ctx, value) {
          if ((value?.docs.isEmpty ?? false)) {
            return const Center(
              child: Text('No categories found'),
            );
          }

          categories = List<CategoryData>.from(value?.docs
                  .map((e) => CategoryData.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          // Initialize the expansion state list
          if (_isExpandedList.length != categories.length) {
            _isExpandedList = List<bool>.filled(categories.length, false);
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                showTrailingIcon: false,
                title: Container(
                  decoration: BoxDecoration(
                    border: _isExpandedList[index]
                        ? Border.all(
                            color: ColorUtility.deepYellow,
                            width: 2.0,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(6),
                    color: _isExpandedList[index]
                        ? Colors.transparent
                        : ColorUtility.grayExtraLight,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categories[index].name ?? 'No Name',
                        style: TextStyle(
                          color: _isExpandedList[index]
                              ? ColorUtility.deepYellow
                              : ColorUtility.mediumlBlack,
                        ),
                      ),
                      Icon(
                        _isExpandedList[index]
                            ? Icons.keyboard_arrow_down
                            : Icons.double_arrow,
                        color: _isExpandedList[index]
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
                onExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpandedList[index] = isExpanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, CategoryCoursesPage.id,
                                arguments: categories[index]);
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        CoursesByCategoryWidget(
                          categoryDataId: categories[index].id,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
