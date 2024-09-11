import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:edu_vista/models/cart_courses.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCoursesTile extends StatelessWidget {
  final CartCourses cartCourse;
  const CartCoursesTile({required this.cartCourse, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorUtility.gray, width: 0.02),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: cartCourse.image ?? '',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        cartCourse.rating.toString(),
                        style: const TextStyle(
                            fontSize: 10.0, color: ColorUtility.main),
                      ),
                      const SizedBox(width: 4.0),
                      const Icon(Icons.star,
                          size: 15, color: ColorUtility.main),
                    ],
                  ),
                  Text(
                    cartCourse.title ?? 'No Name',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.person_2_outlined),
                      Text(
                        cartCourse.instructor?.name ?? 'No Name',
                        style: const TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Space between elements
                  Text(
                    '\$${cartCourse.price.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.0,
                        color: ColorUtility.main),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 75,
                        height: 37,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: ColorUtility.grayLight),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              backgroundColor: ColorUtility.deepYellow,
                              foregroundColor: Colors.white,
                              surfaceTintColor: Colors.white),
                          onPressed: () {
                            context
                                .read<CartBloc>()
                                .add(DeleteCartCourseEvent(cartCourse));
                          },
                          child: const Text(
                            'BuyNow',
                            style: TextStyle(
                              fontSize: 7,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 75,
                        height: 37,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: ColorUtility.grayLight),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              backgroundColor: ColorUtility.gray,
                              foregroundColor: Colors.white,
                              surfaceTintColor: Colors.white),
                          onPressed: () async {
                            bool? confirmed = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Course from Cart'),
                                  content: const Text(
                                      'Are you sure you want to delete this Course?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed == true) {}
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }
}
