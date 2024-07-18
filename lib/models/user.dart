import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String surName;
  String? imageUrl;
  String deviceId;
  List<dynamic> likedEvents;

  User({
    required this.deviceId,
    required this.id,
    required this.name,
    required this.surName,
    required this.imageUrl,
    required this.email,
    required this.likedEvents,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'surName': surName,
      'imageUrl': imageUrl,
      'deviceId': deviceId,
      'likedEvents': likedEvents,
    };
  }

  factory User.fromQuery(DocumentSnapshot<Map<String, dynamic>> qurey) {
    return User(
      deviceId: qurey['deviceId'],
      id: qurey.id,
      name: qurey['name'],
      surName: qurey['surName'],
      imageUrl: qurey['imageUrl'],
      email: qurey['email'],
      likedEvents: qurey['likedEvents'],
    );
  }
}
