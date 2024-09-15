// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String phone_number;
  String photo_url;
  String created_at;
  final bool isOnline;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      this.isOnline = false,
      required this.phone_number,
      required this.photo_url,
      required this.created_at});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phone_number,
      'photo_url': photo_url,
      'created_at': created_at,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    String id = '';
    String name = '';
    String email = '';
    String password = '';
    String phone_number = '';
    String photo_url = '';
    String created_at = '';
    bool isOnline = false;

    try {
      id = doc.get('id');
    } catch (e) {
      id = '';
    }

    try {
      name = doc.get('name');
    } catch (e) {
      name = '';
    }

    try {
      email = doc.get('email');
    } catch (e) {
      email = '';
    }

    try {
      password = doc.get('password');
    } catch (e) {
      password = '';
    }

    try {
      phone_number = doc.get('phone_number');
    } catch (e) {
      phone_number = '';
    }

    try {
      photo_url = doc.get('photo_url');
    } catch (e) {
      photo_url = '';
    }

    try {
      created_at = doc.get('created_at');
    } catch (e) {
      created_at = '';
    }

    try {
      isOnline = doc.get('isOnline');
    } catch (e) {
      isOnline = false;
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      phone_number: phone_number,
      photo_url: photo_url,
      created_at: created_at,
      isOnline: isOnline,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        phone_number: json['phone_number'],
        photo_url: json['photo_url'],
        created_at: json['created_at'],
        isOnline: json['isOnline'] ?? false,
      );
}
