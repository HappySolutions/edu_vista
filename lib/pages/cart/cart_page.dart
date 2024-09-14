import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:edu_vista/widgets/cart/cart_courses_tile.dart';
import 'package:edu_vista/widgets/general/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  static const String id = 'cart';

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    context.read<CartBloc>().add(GetCartCoursesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Cart')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartEmpty) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is CartLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: state.cartCourses.isEmpty && state.totalPrice > 0
                        ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Cart is Loaded...',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        'Please Proceed to Check Out',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.cartCourses.length,
                            itemBuilder: (context, index) {
                              final course = state.cartCourses[index];
                              return CartCoursesTile(cartCourse: course);
                            },
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Price: '),
                      Text('\$${state.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        'checkout',
                        arguments: state.totalPrice,
                      );
                    },
                    width: double.infinity,
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            } else if (state is CartError) {
              return Center(
                child: Text(state.message),
              );
            }

            return const Center(
              child: Text('Courses Loading'),
            );
          },
        ),
      ),
    );
  }
}
