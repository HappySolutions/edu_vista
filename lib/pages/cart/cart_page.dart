import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:edu_vista/widgets/cart/cart_courses_tile.dart';
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
    context.read<CartBloc>().add(CartEventInitial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Center(child: Text('Cart'),),),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _buildCartPage(),
      ),
    );
  }
}

Widget _buildCartPage() {
  return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
    if (state is CartLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CartEmpty) {
      return Center(
        child: Text(state.message),
      );
    } else if (state is CartLoaded) {
      return ListView.builder(
          itemCount: state.cartCourses.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final course = state.cartCourses[index];
            return CartCoursesTile(cartCourse: course);
          });
    }

    return const Center(
      child: Text('Courses Loading'),
    );
  });
}
