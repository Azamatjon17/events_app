import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/views/screens/add_new_event_page.dart';
import 'package:events_app/views/widgets/event_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganithedEventPage extends StatefulWidget {
  const OrganithedEventPage({super.key});

  @override
  State<OrganithedEventPage> createState() => _OrganithedEventPageState();
}

class _OrganithedEventPageState extends State<OrganithedEventPage> {
  @override
  Widget build(BuildContext context) {
    final eventController = context.read<EventController>();
    return Scaffold(
      body: StreamBuilder(
        stream: eventController.getEventByUserId(FirebaseAuth.instance.currentUser!.uid),
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
              child: Text("Malumotlarni yo'q"),
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
                isAdmin: true,
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewEventPage(),
            ),
          );
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Colors.orange.shade900,
            ),
          ),
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.orange.shade900,
          ),
        ),
      ),
    );
  }
}
