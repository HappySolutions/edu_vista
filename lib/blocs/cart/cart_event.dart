part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class CartEventInitial extends CartEvent {}

class GetCartCoursesEvent extends CartEvent {}

class DeleteCartCourseEvent extends CartEvent {
  final CartCourses cartCourse;
  DeleteCartCourseEvent(this.cartCourse);
}

class BuyCourseEvent extends CartEvent {
  final CartCourses cartCourse;
  BuyCourseEvent(this.cartCourse);
}

class CancelCourseEvent extends CartEvent {
  final CartCourses cartCourse;
  CancelCourseEvent(this.cartCourse);
}
