import 'package:bloc/bloc.dart';
import 'package:edu_vista/models/cart_courses.dart';
import 'package:edu_vista/repositories/cart_repo.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    final CartRepo cartRepo = CartRepo();

    on<GetCartCourses>((event, emit) async {
      try {
        emit(CartLoading());
        final cartCourses = await cartRepo.getCartCourses();
        emit(CartLoaded(cartCourses: cartCourses));
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });
  }
}
