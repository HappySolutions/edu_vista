// ignore_for_file: avoid_print

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/cart_courses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartEventInitial>((event, emit) {
      emit(CartInitial());
    });

    on<GetCartCoursesEvent>(_onGetCartCourses);
    on<DeleteCartCourseEvent>(_onDeleteCartCourse);
  }
  CartCourses? cartCourse;
  FutureOr<void> _onDeleteCartCourse(
      DeleteCartCourseEvent event, Emitter<CartState> emit) async {
    cartCourse = event.cartCourse;
    await deleteCartCourse(cartCourse!);
  }

  FutureOr<void> _onGetCartCourses(
      GetCartCoursesEvent event, Emitter<CartState> emit) async {
    List<CartCourses> cartCourses = [];
    emit(CartLoading());
    cartCourses = await getCartCourses(cartCourses);
    if (cartCourses.isEmpty) {
      emit(CartEmpty(message: 'Please Add Courses To the cart'));
    } else {
      emit(CartLoaded(cartCourses: cartCourses));
    }
  }

  Future<List<CartCourses>> getCartCourses(
      List<CartCourses> cartCourses) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<DocumentSnapshot> result = [];
      QuerySnapshot? responce;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      responce = await firestore
          .collection('cart')
          .orderBy('user_id', descending: true)
          .where('user_id', isGreaterThanOrEqualTo: uid)
          .get();
      result = responce.docs;
      cartCourses = List<CartCourses>.from(
        result.map(
          (item) => CartCourses.fromJson(item.data() as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      print('>>>>>>>>Error $e');
    }
    return cartCourses;
  }
}

Future<void> deleteCartCourse(CartCourses cartCourse) async {
  await FirebaseFirestore.instance
      .collection('cart')
      .doc(cartCourse.id)
      .delete();
}
