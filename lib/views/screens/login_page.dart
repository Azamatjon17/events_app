import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/services/auth_user_fairbases.dart';
import 'package:events_app/views/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  AuthUserFairbases authuserfairbases = AuthUserFairbases();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? email;
  String? password;

  submit() async {
    if (formkey.currentState!.validate()) {
      final userController = context.read<UserController>();
      setState(() {
        isLoading = true;
      });
      formkey.currentState!.save();
      try {
        final user = await authuserfairbases.login(email: email!, password: password!);
        await userController.getUser(user.user!.uid);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text("Xato email kiritild"),
                ));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
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
                                "Login",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegistPage()));
                    },
                    child: const Text(
                      "register page",
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
