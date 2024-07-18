import 'dart:io';
import 'package:events_app/services/firebase_firestorage_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class GetProfileScreen extends StatefulWidget {
  const GetProfileScreen({super.key});

  @override
  State<GetProfileScreen> createState() => _GetProfileScreenState();
}

class _GetProfileScreenState extends State<GetProfileScreen> {
  File? imageFile;
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  String? nameError;
  String? lastNameError;

  void _uploadImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
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
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  _uploadImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
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

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      if (nameError != null && nameController.text.trim().isNotEmpty) {
        setState(() {
          nameError = null;
        });
      }
    });
    lastNameController.addListener(() {
      if (lastNameError != null && lastNameController.text.trim().isNotEmpty) {
        setState(() {
          lastNameError = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: imageFile == null ? const AssetImage("assets/images/profile.png") : FileImage(imageFile!),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            _showPicker(context);
                          },
                          icon: const Icon(
                            Icons.photo_camera,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(40),
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Name",
                    errorText: nameError,
                  ),
                ),
                const Gap(20),
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: lastNameController,
                  decoration: InputDecoration(
                    errorText: lastNameError,
                    border: const OutlineInputBorder(),
                    labelText: "Last Name",
                  ),
                ),
                const Gap(20),
                FilledButton(
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty && lastNameController.text.trim().isNotEmpty) {
                      if (imageFile == null) {
                        setState(() {
                          nameError = "Please select an image";
                        });
                        return;
                      }

                      String? imageurl = await FirebaseFirestorageService.uploadImage(imageFile!, "users/${nameController.text}");

                      Navigator.pop(
                        context,
                        {
                          'name': nameController.text,
                          'surName': lastNameController.text,
                          'imageUrl': imageurl,
                        },
                      );
                    } else {
                      setState(() {
                        if (nameController.text.trim().isEmpty) {
                          nameError = "Please enter your name";
                        }
                        if (lastNameController.text.trim().isEmpty) {
                          lastNameError = "Please enter your last name";
                        }
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
