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
    on<BuyCourseEvent>(_onBuyCourse);
    on<CancelCourseEvent>(_onCancelCourse);
  }

  List<CartCourses> cartCourses = [];
  double totalPrice = 0.0;

  FutureOr<void> _onGetCartCourses(
      GetCartCoursesEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      List<CartCourses> courses = await getCartCourses();
      cartCourses = courses;
      totalPrice =
          cartCourses.fold(0.0, (sum, course) => sum + (course.price ?? 0.0));

      if (cartCourses.isEmpty) {
        emit(CartEmpty(message: 'Please Add Courses To the cart'));
      } else {
        emit(CartLoaded(cartCourses: cartCourses, totalPrice: totalPrice));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  FutureOr<void> _onDeleteCartCourse(
      DeleteCartCourseEvent event, Emitter<CartState> emit) async {
    try {
      await deleteCartCourse(event.cartCourse);
      cartCourses = cartCourses
          .where((course) => course.id != event.cartCourse.id)
          .toList();
      totalPrice =
          cartCourses.fold(0.0, (sum, course) => sum + (course.price ?? 0.0));
      emit(CartLoaded(cartCourses: cartCourses, totalPrice: totalPrice));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  FutureOr<void> _onBuyCourse(
      BuyCourseEvent event, Emitter<CartState> emit) async {
    try {
      totalPrice = event.cartCourse.price ?? 0.0;
      cartCourses = cartCourses
          .where((course) => course.id != event.cartCourse.id)
          .toList();
      emit(CartLoaded(cartCourses: cartCourses, totalPrice: totalPrice));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  FutureOr<void> _onCancelCourse(
      CancelCourseEvent event, Emitter<CartState> emit) async {
    try {
      cartCourses.add(event.cartCourse);
      totalPrice += event.cartCourse.price ?? 0.0;
      emit(CartLoaded(cartCourses: cartCourses, totalPrice: totalPrice));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<List<CartCourses>> getCartCourses() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot response = await firestore
          .collection('cart')
          .where('user_id', isEqualTo: uid)
          .get();
      List<DocumentSnapshot> result = response.docs;
      return List<CartCourses>.from(
        result.map(
          (item) => CartCourses.fromJson(item.data() as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      throw Exception('Error fetching cart courses: $e');
    }
  }

  Future<void> deleteCartCourse(CartCourses cartCourse) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartCourse.id)
          .delete();
    } catch (e) {
      throw Exception('Error deleting cart course: $e');
    }
  }
}

// class CartBloc extends Bloc<CartEvent, CartState> {
//   CartBloc() : super(CartInitial()) {
//     on<CartEventInitial>((event, emit) {
//       emit(CartInitial());
//     });

//     on<GetCartCoursesEvent>(_onGetCartCourses);
//     on<DeleteCartCourseEvent>(_onDeleteCartCourse);
//     on<BuyNowCourseEvent>(_onBuyNowCourse);
//   }
//   CartCourses? cartCourse;
//   double totalPrice = 0; // Track total price

//   FutureOr<void> _onDeleteCartCourse(
//       DeleteCartCourseEvent event, Emitter<CartState> emit) async {
//     cartCourse = event.cartCourse;
//     await deleteCartCourse(cartCourse!);
//     // Update total price when course is deleted
//     totalPrice -= cartCourse!.price ?? 0;
//     emit(CartTotalUpdated(totalPrice: totalPrice));
//   }

//   FutureOr<void> _onGetCartCourses(
//       GetCartCoursesEvent event, Emitter<CartState> emit) async {
//     List<CartCourses> cartCourses = [];
//     emit(CartLoading());
//     cartCourses = await getCartCourses(cartCourses);
//     if (cartCourses.isEmpty) {
//       emit(CartEmpty(message: 'Please Add Courses To the cart'));
//     } else {
//       totalPrice = _calculateTotal(cartCourses);
//       emit(CartLoaded(cartCourses: cartCourses, totalPrice: totalPrice));
//     }
//   }

//   FutureOr<void> _onBuyNowCourse(
//       BuyNowCourseEvent event, Emitter<CartState> emit) async {
//     // Update total price when a course is purchased
//     totalPrice += event.cartCourse.price ?? 0;
//     emit(CartTotalUpdated(totalPrice: totalPrice));
//   }

//   double _calculateTotal(List<CartCourses> cartCourses) {
//     return cartCourses.fold(0.0, (sum, course) => sum + (course.price ?? 0));
//   }

//   Future<List<CartCourses>> getCartCourses(
//       List<CartCourses> cartCourses) async {
//     try {
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       QuerySnapshot responce = await firestore
//           .collection('cart')
//           .where('user_id', isEqualTo: uid)
//           .get();
//       List<DocumentSnapshot> result = responce.docs;
//       cartCourses = List<CartCourses>.from(
//         result.map((item) =>
//             CartCourses.fromJson(item.data() as Map<String, dynamic>)),
//       );
//     } catch (e) {
//       print('Error: $e');
//     }
//     return cartCourses;
//   }
// }

// Future<void> deleteCartCourse(CartCourses cartCourse) async {
//   await FirebaseFirestore.instance
//       .collection('cart')
//       .doc(cartCourse.id)
//       .delete();
// }
