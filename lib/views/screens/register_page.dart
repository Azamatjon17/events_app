import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/models/user.dart';
import 'package:events_app/services/auth_user_fairbases.dart';
import 'package:events_app/services/firebase_push_notification_service.dart';
import 'package:events_app/views/screens/get_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  bool isLoading = false;
  AuthUserFairbases authuserfairbases = AuthUserFairbases();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? password2;
  String? email;
  String? password;

  submit() async {
    if (formkey.currentState!.validate()) {
      if (password == password2) {
        setState(() {
          isLoading = true;
        });
        formkey.currentState!.save();
        try {
          print("object 1 ");
          Map<String, dynamic> userDate = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GetProfileScreen(),
            ),
          );
          print("object 2");

          if (userDate.isNotEmpty) {
            print(userDate);
            final userController = context.read<UserController>();

            String? deviceToken = await FirebasePushNotificationService.getToken();
            print("object");
            final registerUser = await authuserfairbases.register(email: email!, password: password!);
            await userController.addUser(
              User(
                deviceId: deviceToken!,
                id: registerUser.user!.uid,
                name: userDate['name'],
                surName: userDate['surName'],
                imageUrl: userDate['imageUrl'],
                email: registerUser.user!.email!,
                likedEvents: [],
              ),
            );
            Navigator.pop(context);
          }
        } catch (e) {
          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (context) => const AlertDialog(
                    content: Text("Xato email kiritild"),
                  ));
        }
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("passwordlar bir biriga o'xshamyapti qayta kriting"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset('assets/images/onbording.svg'),
                  const Gap(20),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500,
                          width: 3,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500, // Border color when enabled
                          width: 3.0, // Border width when enabled
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500, // Border color when focused
                          width: 3.0, // Border width when focused
                        ),
                      ),
                      hintText: "email",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'email kriting';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      email = newValue;
                    },
                  ),
                  const Gap(20),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500,
                          width: 3,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500, // Border color when enabled
                          width: 3.0, // Border width when enabled
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500, // Border color when focused
                          width: 3.0, // Border width when focused
                        ),
                      ),
                      hintText: "password",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'password kriting';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      password = newValue;
                    },
                  ),
                  const Gap(20),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500,
                          width: 3,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500, // Border color when enabled
                          width: 3.0, // Border width when enabled
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade500, // Border color when focused
                          width: 3.0, // Border width when focused
                        ),
                      ),
                      hintText: "varifaction password",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'password kriting';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      password2 = newValue;
                    },
                  ),
                  const Gap(20),
                  InkWell(
                    onTap: submit,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange.shade500, width: 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Register",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "login page",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
