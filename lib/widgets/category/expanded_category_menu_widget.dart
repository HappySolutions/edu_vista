import 'package:async_builder/async_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category_data.dart';
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

          var categories = List<CategoryData>.from(value?.docs
                  .map((e) => CategoryData.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ExpansionTile(
                title: Text(
                  categories[index].name ?? 'No Name',
                  style: const TextStyle(
                    color: ColorUtility.mediumlBlack,
                  ),
                ),
                trailing: const Icon(
                  Icons.double_arrow,
                ),
                iconColor: ColorUtility.deepYellow,
                maintainState: true,
                collapsedBackgroundColor: ColorUtility.grayExtraLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: ColorUtility.grayExtraLight,
                collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                children: [
                  CoursesByCategoryWidget(
                    categoryData: categories[index],
                  )
                ],
              ),
              // TextButton(
              //   style: TextButton.styleFrom(
              //     foregroundColor: ColorUtility.deepYellow,
              //     padding: const EdgeInsets.all(20),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(6)),
              //     backgroundColor: ColorUtility.grayExtraLight,
              //   ),
              //   onPressed: widget.press,
              //   child:
              //        Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           categories[index].name ?? 'No Name',
              //           style: const TextStyle(
              //             color: ColorUtility.mediumlBlack,
              //           ),
              //         ),
              //       ),
              //       const Icon(
              //         Icons.double_arrow,
              //         color: ColorUtility.mediumlBlack,
              //       ),
              //     ],
              //   ),
              // ),
            ),
          );
        });
  }
}
