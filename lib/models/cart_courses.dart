import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category_data.dart';
import 'package:edu_vista/models/instructor.dart';

class CartCourses {
  String id;
  String title;
  String image;
  CategoryData category;
  String currency;
  String rank;
  bool has_certificate;
  Instructor instructor;
  double price;
  double rating;
  int total_hours;
  DateTime created_date;
  String userId;

  CartCourses({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.currency,
    required this.rank,
    required this.has_certificate,
    required this.instructor,
    required this.price,
    required this.rating,
    required this.total_hours,
    required this.created_date,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['category'] = category.toJson();
    data['currency'] = currency;
    data['rank'] = rank;
    data['has_certificate'] = has_certificate;
    data['instructor'] = instructor.toJson();
    data['price'] = price;
    data['rating'] = rating;
    data['total_hours'] = total_hours;
    data['created_date'] = created_date;
    data['userId'] = userId;
    return data;
  }

  factory CartCourses.fromDocument(DocumentSnapshot doc) {
    String id = doc.get('id');
    String title = doc.get('title');
    String image = doc.get('image');
    CategoryData category = CategoryData.fromJson(doc.get('category'));
    String currency = doc.get('currency');
    String rank = doc.get('rank');
    bool has_certificate = doc.get('has_certificate');
    Instructor instructor = Instructor.fromJson(doc.get('instructor'));
    double price = doc.get('price');
    double rating = doc.get('rating');
    int total_hours = doc.get('total_hours');
    DateTime created_date = doc.get('created_date');
    String userId = doc.get('userId');
    return CartCourses(
      id: id,
      title: title,
      image: image,
      category: category,
      currency: currency,
      rank: rank,
      has_certificate: has_certificate,
      instructor: instructor,
      price: price,
      rating: rating,
      total_hours: total_hours,
      created_date: created_date,
      userId: userId,
    );
  }
}
