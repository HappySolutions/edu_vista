part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartCourses> cartCourses;
  final double totalPrice; // Add this property

  CartLoaded({
    required this.cartCourses,
    required this.totalPrice, // Include totalPrice in the constructor
  });
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

class CartTotalUpdated extends CartState {
  final double totalPrice;
  CartTotalUpdated({required this.totalPrice});
}
