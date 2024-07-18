import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/views/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        try {
          print(FirebaseAuth.instance.currentUser!.uid);
          await context.read<UserController>().getUser(FirebaseAuth.instance.currentUser!.uid);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } catch (e) {
          print('Error: $e');
          // You can show an error message to the user or handle the error as needed
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/onbording.svg',
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
