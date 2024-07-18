import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/models/user.dart';
import 'package:flutter/material.dart';

class EventController extends ChangeNotifier {
  final CollectionReference _firebaseFireStore = FirebaseFirestore.instance.collection('events');

  Future<void> setEvent(Event event) async {
    await _firebaseFireStore.doc(event.id).set(event.toMap());
  }

  Stream<QuerySnapshot<Object?>> getEventsWithinNextWeek() {
    // Get the current date and the date one week from now
    DateTime now = DateTime.now();
    DateTime nextWeek = now.add(const Duration(days: 7));

    // Query Firestore for events within the next week
    return _firebaseFireStore.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now)).where('date', isLessThanOrEqualTo: Timestamp.fromDate(nextWeek)).orderBy('date').snapshots();
  }

  Stream<QuerySnapshot<Object?>> getAllEvents() {
    return _firebaseFireStore.orderBy('date').snapshots();
  }

  Future<void> registerMember(String eventId, String memberId) async {
    try {
      DocumentReference eventRef = _firebaseFireStore.doc(eventId);

      await eventRef.update({
        'members': FieldValue.arrayUnion([memberId])
      });

      print('Member added successfully');
    } catch (e) {
      print('Error adding member: $e');
    }
    notifyListeners();
  }

  Future<void> unregisterMember(String eventId, String memberId) async {
    try {
      DocumentReference eventRef = _firebaseFireStore.doc(eventId);

      await eventRef.update({
        'members': FieldValue.arrayRemove([memberId])
      });

      print('Member removed successfully');
    } catch (e) {
      print('Error removing member: $e');
    }
    notifyListeners();
  }

  Future<User> getUserByUserId(String id) async {
    final userQuery = await FirebaseFirestore.instance.collection('users').doc(id).get();
    return User.fromQuery(userQuery);
  }

  Stream<QuerySnapshot<Object?>> getEventByUserId(String uId) {
    return _firebaseFireStore.where('organiser', isEqualTo: uId).snapshots();
  }

  Future<void> delete(String eventId) async {
    await _firebaseFireStore.doc(eventId).delete();
  }

  Stream<QuerySnapshot<Object?>> getEventByUserMember(String uId) {
    DateTime now = DateTime.now();

    return _firebaseFireStore.where('members', arrayContains: uId).where('date', isGreaterThan: Timestamp.fromDate(now)).orderBy('date').snapshots();
  }

  Stream<QuerySnapshot<Object?>> getEventByUserMemberOld(String uId) {
    DateTime now = DateTime.now();

    return _firebaseFireStore
        .where('members', arrayContains: uId)
        .where('date', isLessThan: Timestamp.fromDate(now))
        .orderBy('date', descending: true) // Order by date in descending order to get the most recent past events first
        .snapshots();
  }
}
