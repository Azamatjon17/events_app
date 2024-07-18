import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  String id;
  String title;
  String organiser;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String description;
  String image;
  LatLng location;
  bool isLike = false;
  List<dynamic> members;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.organiser,
    required this.endTime,
    required this.description,
    required this.image,
    required this.location,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
      'startTime': "${startTime.hour}:${startTime.minute}",
      'endTime': "${endTime.hour}:${endTime.minute}",
      'organiser': organiser,
      'description': description,
      'image': image,
      'location_lat': location.latitude,
      'location_long': location.longitude,
      'members': members,
    };
  }

  factory Event.fromMap(QueryDocumentSnapshot qury) {
    return Event(
      id: qury.id,
      title: qury['title'],
      date: (qury['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      startTime: TimeOfDay(
        hour: int.parse(qury['startTime'].toString().split(':').first),
        minute: int.parse(qury['startTime'].toString().split(':')[1]),
      ),
      organiser: qury['organiser'],
      endTime: TimeOfDay(
        hour: int.parse(qury['endTime'].toString().split(':').first),
        minute: int.parse(qury['endTime'].toString().split(':')[1]),
      ),
      description: qury['description'],
      image: qury['image'],
      location: LatLng(
        double.parse(qury['location_lat'].toString()),
        double.parse(qury['location_long'].toString()),
      ),
      members: qury['members'],
    );
  }
}
