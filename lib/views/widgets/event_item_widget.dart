import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/views/screens/add_new_event_page.dart';
import 'package:events_app/views/screens/event_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/services/location_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventItemWidget extends StatefulWidget {
  final bool isAdmin;
  final Event event;
  const EventItemWidget({super.key, required this.event, this.isAdmin = false});

  @override
  State<EventItemWidget> createState() => _EventItemWidgetState();
}

class _EventItemWidgetState extends State<EventItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(event: widget.event),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: colorScheme.onSurface.withOpacity(0.12),
                width: 5,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    height: 100,
                    width: 100,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/images/event.png'),
                    image: NetworkImage(widget.event.image),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('MMM d, h:mm a').format(widget.event.date),
                        style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                      const SizedBox(height: 5),
                      FutureBuilder<String>(
                        future: LocationService.getLocationInformation(
                          widget.event.location.latitude,
                          widget.event.location.longitude,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading address...");
                          }
                          if (snapshot.hasError) {
                            return const Text("Could not fetch location information");
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text("No location information available");
                          } else {
                            return Text(
                              snapshot.data!,
                              style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.7)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.isAdmin)
            Positioned(
                top: 5,
                right: 10,
                child: PopupMenuButton(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewEventPage(
                            event: widget.event,
                          ),
                        ),
                      );
                    }
                    if (value == 'delete') {
                      bool canDelete = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("Are you sure you want to delete this event?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (canDelete) {
                        context.read<EventController>().delete(widget.event.id);
                      }
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text("Edit"),
                      ),
                    ];
                  },
                ))
        ],
      ),
    );
  }
}
