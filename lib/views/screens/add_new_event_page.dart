import 'dart:io';
import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/models/user.dart';
import 'package:events_app/services/firebase_firestorage_service.dart';
import 'package:events_app/services/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class AddNewEventPage extends StatefulWidget {
  final Event? event;
  const AddNewEventPage({Key? key, this.event}) : super(key: key);

  @override
  State<AddNewEventPage> createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  late GoogleMapController mapController;
  final _formKey = GlobalKey<FormState>();
  String? imageUrl;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _dateController;
  LatLng _eventLocation = const LatLng(0.0, 0.0);
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _startTimeController = TextEditingController(text: widget.event != null ? widget.event!.startTime.format(context) : '');
    _endTimeController = TextEditingController(text: widget.event != null ? widget.event!.endTime.format(context) : '');
    _dateController = TextEditingController(text: widget.event != null ? DateFormat('yyyy-MM-dd').format(widget.event!.date) : '');

    if (widget.event?.location != null && widget.event != null) {
      _eventLocation = widget.event!.location;
    } else {
      LocationService.getCurrentLocation().then((valeu) {
        _eventLocation = LatLng(valeu!.latitude!, valeu.longitude!);

        setState(() {
          mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _eventLocation, zoom: 15),
            ),
          );
        });
      });
    }

    imageUrl = widget.event?.image;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 700)),
      initialDate: widget.event?.date ?? DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  _pickTime(TextEditingController controller) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: controller.text.isEmpty
          ? TimeOfDay.now()
          : TimeOfDay(
              hour: int.parse(
                controller.text.split(':').toList().first,
              ),
              minute: int.parse(
                controller.text.split(':').toList()[1].split(' ').first,
              ),
            ),
    );
    if (time != null) {
      setState(() {
        controller.text = time.format(context);
      });
    }
  }

  void _uploadImage(ImageSource imageSource) async {
    String id = "${context.read<UserController>().user!.id}${DateTime.now().minute}";

    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage != null) {
      String? url = await FirebaseFirestorageService.uploadImage(
        File(pickedImage.path),
        widget.event == null ? "events/$id" : "events/${widget.event!.id}",
      );
      setState(() {
        imageUrl = url;
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Gallery'.tr()),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('Camera'.tr()),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSubmit() async {
    String id = "${context.read<UserController>().user!.id}${DateTime.now().minute}";

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final User user = context.read<UserController>().user!;

      DateTime date = DateFormat('yyyy-MM-dd').parse(_dateController.text);
      List<String> startTimeParts = _startTimeController.text.split(':');
      TimeOfDay startTime = TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1].split(' ').first),
      );

      List<String> endTimeParts = _endTimeController.text.split(':');
      TimeOfDay endTime = TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1].split(' ').first),
      );

      Event newEvent = Event(
        id: widget.event?.id ?? id,
        title: _titleController.text,
        date: date,
        startTime: startTime,
        endTime: endTime,
        description: _descriptionController.text,
        image: imageUrl!,
        location: _eventLocation,
        organiser: user.id,
        members: [],
      );
      final eventController = context.read<EventController>();
      await eventController.setEvent(newEvent);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'tadbir_qoshish'.tr() : 'tadbirni_tahrirlash'.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
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
                  hintText: 'nomi'.tr(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'iltimos_nomini_kiriting'.tr();
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                controller: _dateController,
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
                  hintText: 'kuni'.tr(),
                  suffixIcon: IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.date_range_outlined),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'iltimos_sanani_kiriting'.tr();
                  }
                  return null;
                },
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
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
                        hintText: 'boshlanish_vaqti'.tr(),
                        suffixIcon: IconButton(
                          onPressed: () => _pickTime(_startTimeController),
                          icon: const Icon(Icons.access_time_outlined),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'iltimos_boshlanish_vaqtini_kiriting'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
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
                        hintText: 'tugash_vaqti'.tr(),
                        suffixIcon: IconButton(
                          onPressed: () => _pickTime(_endTimeController),
                          icon: const Icon(Icons.access_time_outlined),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'iltimos_tugash_vaqtini_kiriting'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Gap(10),
              TextFormField(
                controller: _descriptionController,
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
                  hintText: 'qisqacha_tavsif'.tr(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'iltimos_tavsif_kiriting'.tr();
                  }
                  return null;
                },
              ),
              const Gap(10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showPicker(context);
                    },
                    child: Text(
                      'rasm_tanlash'.tr(),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _eventLocation,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(markerId: MarkerId('event'), position: _eventLocation)
                      },
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      gestureRecognizers: Set()
                        ..add(Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())),
                      onTap: (LatLng position) {
                        setState(() {
                          _eventLocation = position;
                          mapController.moveCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: position, zoom: 15),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Gap(10),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text(
                  widget.event == null ? 'qoshish'.tr() : 'saqlash'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
