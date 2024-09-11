part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class CartEventInitial extends CartEvent {}

class GetCartCoursesEvent extends CartEvent {}

class DeleteCartCourseEvent extends CartEvent {
  final CartCourses cartCourse;
  DeleteCartCourseEvent(this.cartCourse);
}
