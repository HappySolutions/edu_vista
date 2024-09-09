import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/cart_courses.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider {
  List<CartCourses> _cartCourses = [];

  Future<List<CartCourses>> getCartCourses() async {
    try {
      late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

      futureCall = FirebaseFirestore.instance
          .collection('cart')
          .where('cartid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('created_date', descending: true)
          .get();
      var value = await futureCall;

      if (value.docs.isNotEmpty) {
        print('No Courses Found');
      }

      _cartCourses = List<CartCourses>.from(value.docs
          .map((e) => CartCourses.fromJson({'id': e.id, ...e.data()}))
          .toList());

      return _cartCourses;
    } catch (e) {
      print('No Courses Found something went wrong $e');
      return [];
    }
  }
}
