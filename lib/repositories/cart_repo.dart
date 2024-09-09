import 'package:edu_vista/models/cart_courses.dart';
import 'package:edu_vista/providers/cart_provider.dart';

class CartRepo {
  final _firebaseProvider = CartProvider();

  Future<List<CartCourses>> getCartCourses() async {
    return _firebaseProvider.getCartCourses();
  }
}
