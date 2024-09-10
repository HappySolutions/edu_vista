import 'package:edu_vista/models/cart_courses.dart';
import 'package:edu_vista/pages/course/course_details_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class CartCoursesTile extends StatelessWidget {
  final CartCourses cartCourse;
  const CartCoursesTile({required this.cartCourse, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtility.gray, width: 0.02),
      ),
      height: size.height,
      width: size.width,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, CourseDetailsPage.id,
                  arguments: cartCourse);
            },
            child: SizedBox(
              width: 160,
              height: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      cartCourse.image ?? 'No Name',
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        cartCourse.rating.toString(),
                        style: const TextStyle(
                            fontSize: 10.0, color: ColorUtility.main),
                      ),
                      const SizedBox(width: 4.0),
                      const Icon(Icons.star,
                          size: 15, color: ColorUtility.main),
                    ],
                  ),
                  Text(
                    cartCourse.title ?? 'No Name',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.person_2_outlined),
                      Text(
                        cartCourse.instructor?.name ?? 'No Name',
                        style: const TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Space between elements
                  Text(
                    '\$${cartCourse.price.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.0,
                        color: ColorUtility.main),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
