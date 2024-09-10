// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Instructor {
  String? id;
  String? name;
  String? graduation_from;
  int? years_of_experience;

  Instructor({
    this.id,
    this.name,
    this.graduation_from,
    this.years_of_experience,
  });

  Instructor.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    graduation_from = data['graduation_from'];
    years_of_experience = data['years_of_experience'];
  }
  factory Instructor.fromDocument(DocumentSnapshot<Object?> doc) {
    String id = doc.get('id');
    String name = doc.get('name');
    String graduation_from = doc.get('graduation_from');
    String years_of_experience = doc.get('years_of_experience');

    return Instructor(
      id: id,
      name: name,
      graduation_from: graduation_from,
      years_of_experience: int.parse(years_of_experience),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['graduation_from'] = graduation_from;
    data['years_of_experience'] = years_of_experience;
    return data;
  }
}
