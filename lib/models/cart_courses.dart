// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/instructor.dart';

class CartCourses {
  String? id;
  String? title;
  String? image;
  Instructor? instructor;
  double? price;
  double? rating;
  String? user_id;

  CartCourses({
    required this.id,
    required this.title,
    required this.image,
    required this.instructor,
    required this.price,
    required this.rating,
    required this.user_id,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['instructor'] = instructor?.toJson();
    data['price'] = price;
    data['rating'] = rating;
    data['user_id'] = user_id;
    return data;
  }

  factory CartCourses.fromDocument(DocumentSnapshot doc) {
    String id = doc.get('id');
    String title = doc.get('title');
    String image = doc.get('image');
    Instructor instructor = Instructor.fromDocument(doc.get('instructor'));
    double price = doc.get('price');
    double rating = doc.get('rating');
    String user_id = doc.get('user_id');
    return CartCourses(
      id: id,
      title: title,
      image: image,
      instructor: instructor,
      price: price,
      rating: rating,
      user_id: user_id,
    );
  }

  CartCourses.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    image = data['image'];
    instructor = data['instructor'] != null
        ? Instructor.fromJson(data['instructor'])
        : null;
    price = data['price'];
    rating = data['rating'];
    user_id = data['user_id'];
  }
}
