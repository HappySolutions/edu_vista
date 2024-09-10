import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:edu_vista/models/cart_courses.dart';
import 'package:edu_vista/widgets/cart/cart_courses_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      appBar: AppBar(),
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
