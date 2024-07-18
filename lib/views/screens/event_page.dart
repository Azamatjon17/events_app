import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/services/location_service.dart';
import 'package:events_app/views/widgets/booking_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class EventPage extends StatefulWidget {
  final Event event;

  const EventPage({super.key, required this.event});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.event.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.event.title,
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Number of participants:"),
                  Text(
                    widget.event.members.length.toString(),
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('MMM d, y').format(widget.event.date),
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                  const Spacer(),
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    "${widget.event.startTime.format(context)} - ${widget.event.endTime.format(context)}",
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_pin, size: 16),
                  const SizedBox(width: 5),
                  Expanded(
                    child: FutureBuilder<String>(
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
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.event.description,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                child: GoogleMap(
                  gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                  initialCameraPosition: CameraPosition(
                    target: widget.event.location,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(widget.event.id),
                      position: widget.event.location,
                    ),
                  },
                ),
              ),
              const Gap(15),
              FutureBuilder(
                future: eventController.getUserByUserId(widget.event.organiser),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Error loading organizer information");
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text("No organizer information available");
                  } else {
                    final organiser = snapshot.data!;
                    return ListTile(
                      leading: CircleAvatar(
                        child: organiser.imageUrl == null
                            ? Image.asset('assets/images/profile.png')
                            : FadeInImage(
                                fadeInDuration: const Duration(milliseconds: 200),
                                placeholder: const AssetImage('assets/images/profile.png'),
                                image: NetworkImage(organiser.imageUrl!),
                              ),
                      ),
                      title: Text(
                        "${organiser.name} ${organiser.surName}",
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                      ),
                      subtitle: Text(
                        FirebaseAuth.instance.currentUser!.uid == widget.event.organiser ? "You are the organizer" : "Event Organizer",
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                    );
                  }
                },
              ),
              const Gap(15),
              if (!widget.event.members.contains(FirebaseAuth.instance.currentUser!.uid) && FirebaseAuth.instance.currentUser!.uid != widget.event.organiser && widget.event.date.isAfter(DateTime.now()))
                InkWell(
                  onTap: () async {
                    await eventController.registerMember(widget.event.id, FirebaseAuth.instance.currentUser!.uid);
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(),
                          ));
                      widget.event.members.add(FirebaseAuth.instance.currentUser!.uid);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 5,
                      ),
                    ),
                    child: const Text("Register"),
                  ),
                ),
              if (widget.event.members.contains(FirebaseAuth.instance.currentUser!.uid) && FirebaseAuth.instance.currentUser!.uid != widget.event.organiser && widget.event.date.isAfter(DateTime.now()))
                InkWell(
                  onTap: () async {
                    await eventController.unregisterMember(widget.event.id, FirebaseAuth.instance.currentUser!.uid);
                    setState(() {
                      widget.event.members.remove(FirebaseAuth.instance.currentUser!.uid);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 5,
                      ),
                    ),
                    child: const Text("Cancel Registration"),
                  ),
                ),
              if (widget.event.date.isBefore(DateTime.now()) && FirebaseAuth.instance.currentUser!.uid != widget.event.organiser)
                InkWell(
                  onTap: () async {
                    await eventController.registerMember(widget.event.id, FirebaseAuth.instance.currentUser!.uid);
                    setState(() {
                      widget.event.members.add(FirebaseAuth.instance.currentUser!.uid);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 5,
                      ),
                    ),
                    child: const Text("Event Expired"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
