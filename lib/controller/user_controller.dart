import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/models/user.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  User? user;
  final userFairbase = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) async {
    await userFairbase.doc(user.id).set(user.toMap());
    this.user = user;
  }

  Future<void> getUser(String uId) async {
    final userDate = await userFairbase.doc(uId).get();

    user = User.fromQuery(userDate);
  }

  Future<void> toggleLikeEvent(String eventId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.id);

    try {
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> likedEvents = data['likedEvents'] ?? [];

        if (likedEvents.contains(eventId)) {
          // Remove event ID from likedEvents
          likedEvents.remove(eventId);
        } else {
          // Add event ID to likedEvents
          likedEvents.add(eventId);
        }

        // Update the document with the modified likedEvents list
        await userDoc.update({'likedEvents': likedEvents});
      }
    } catch (e) {
      print('Error toggling like event: $e');
    }
  }

  static Future<List<dynamic>> getLikedEvents(String uId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uId);

    try {
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Ensure 'likedEvents' exists and is a List
        var data = docSnapshot.data() as Map<String, dynamic>;
        return data['likedEvents'] is List ? data['likedEvents'] as List<dynamic> : [];
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting liked events: $e');
      return [];
    }
  }
}
