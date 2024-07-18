import 'package:easy_localization/easy_localization.dart';
import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/views/widgets/drawer_widget.dart';
import 'package:events_app/views/widgets/event_item_widget.dart';
import 'package:events_app/views/widgets/events_within_next_week_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool notification = true;

  Future<void> getUser() async {
    final userController = context.read<UserController>();
    if (userController.user == null) {
      await userController.getUser(FirebaseAuth.instance.currentUser!.uid);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final eventController = context.read<EventController>();
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text("bosh_sahifa".tr()),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {},
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications,
                  size: 30,
                ),
                if (notification)
                  const Positioned(
                    right: 5,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.red,
                    ),
                  )
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange.shade500,
                    width: 3,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange.shade500,
                    width: 3.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange.shade500,
                    width: 3.0,
                  ),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                ),
                hintText: "Tadbirlarni izlash..",
              ),
            ),
            const Gap(10),
            const Text(
              "Yaqin 7 kun ichida",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const EventsWithinNextWeekWidget(),
            const Gap(10),
            const Text(
              "Barcha Tadbirlar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: eventController.getAllEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Malumotlar mavjud emas",
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Malumot olishda hato'),
                    );
                  }
                  final events = snapshot.data!.docs;

                  return ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: events.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      final event = Event.fromMap(events[index]);
                      return EventItemWidget(event: event);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
