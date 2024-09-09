import 'package:edu_vista/models/course.dart';

class CartCourses {
  String? cartId;
  int? coursesCount;
  int? coursesId;
  Course? course;

  CartCourses.fromJson(Map<String, dynamic> data) {
    cartId = data['id'];
    coursesCount = data['coursesCount'];
    coursesId = data['coursesId'];
    course = Course.fromJson(data['course']);
  }
}
