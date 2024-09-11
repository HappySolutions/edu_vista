part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartCourses> cartCourses;
  CartLoaded({required this.cartCourses});
}

class CartEmpty extends CartState {
  final String message;
  CartEmpty({required this.message});
}

class CartError extends CartState {
  final String message;
  CartError({required this.message});
}

class CartCourseDeleted extends CartState {
  final CartCourses cartCourse;
  CartCourseDeleted(this.cartCourse);
}
