// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/cart_courses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<GetCartCoursesEvent>((event, emit) async {
      List<CartCourses> cartCourses = [];
      emit(CartLoading());
      cartCourses = await getCartCourses(cartCourses);
      emit(CartLoaded(cartCourses: cartCourses));
    });
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
