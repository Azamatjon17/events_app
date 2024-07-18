import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/views/widgets/event_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SoonEventPage extends StatefulWidget {
  const SoonEventPage({super.key});

  @override
  State<SoonEventPage> createState() => _SoonEventPageState();
}

class _SoonEventPageState extends State<SoonEventPage> {
  @override
  Widget build(BuildContext context) {
    final eventController = context.read<EventController>();
    return Scaffold(
      body: StreamBuilder(
        stream: eventController.getEventByUserMember(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Malumotlarni olishda hatolik"),
            );
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Malumotlar yo'q"),
            );
          }

          final events = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 15,
            ),
            itemBuilder: (context, index) {
              final event = Event.fromMap(events[index]);
              return EventItemWidget(
                event: event,
              );
            },
          );
        },
      ),
    );
  }
}
