import 'package:edu_vista/widgets/category/categories_widget.dart';
import 'package:edu_vista/widgets/course/courses_widget.dart';
import 'package:edu_vista/widgets/general/label_widget.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  static const String id = 'homepage';

  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LabelWidget(
                name: 'Categories',
                onSeeAllClicked: () {},
              ),
              const CategoriesWidget(),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Rated Courses',
                onSeeAllClicked: () {},
              ),
              const CoursesWidget(
                rankValue: 'top rated',
              ),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Seller Courses',
                onSeeAllClicked: () {},
              ),
              const CoursesWidget(
                rankValue: 'top seller',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
