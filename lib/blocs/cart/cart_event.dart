part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class GetCartCoursesEvent extends CartEvent {}
