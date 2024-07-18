import 'package:carousel_slider/carousel_slider.dart';
import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/views/screens/event_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsWithinNextWeekWidget extends StatefulWidget {
  const EventsWithinNextWeekWidget({super.key});

  @override
  State<EventsWithinNextWeekWidget> createState() => _EventsWithinNextWeekWidgetState();
}

class _EventsWithinNextWeekWidgetState extends State<EventsWithinNextWeekWidget> {
  @override
  Widget build(BuildContext context) {
    final eventController = context.read<EventController>();
    final userController = context.read<UserController>();
    return StreamBuilder(
      stream: eventController.getEventsWithinNextWeek(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("MAlumot olishda hato bor"),
          );
        }
        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("Malumot mavjud emas"),
          );
        }

        final events = snapshot.data!.docs;

        return CarouselSlider.builder(
          itemCount: events.length,
          itemBuilder: (context, index, realIndex) {
            final event = Event.fromMap(events[index]);

            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventPage(event: event),
                      ),
                    );
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(10),
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(event.image),
                      placeholder: const AssetImage('assets/images/event.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      // Handle like event
                      // .( event.id);
                    },
                    icon: Icon(
                      userController.user!.likedEvents.contains(event.id) ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    height: 55,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 46, 45, 45),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          event.date.day.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          DateFormat('MMMM').format(event.date),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            animateToClosest: true,
            autoPlay: true,
          ),
        );
      },
    );
  }
}
