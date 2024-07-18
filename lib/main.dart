import 'package:easy_localization/easy_localization.dart';
import 'package:events_app/controller/event_controller.dart';
import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/firebase_options.dart';
import 'package:events_app/services/firebase_push_notification_service.dart';
import 'package:events_app/services/location_service.dart';
import 'package:events_app/utils/thema_date.dart';
import 'package:events_app/views/screens/language_change_page.dart';
import 'package:events_app/views/screens/login_page.dart';
import 'package:events_app/views/screens/onbording_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await FirebasePushNotificationService.getPermission();
  await LocationService.init();
  final themeProvider = await ThemeProvider.loadTheme();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: const Locale('uz'),
      startLocale: Locale('uz'),
      child: MainApp(themeProvider: themeProvider),
    ),
  );
}

class MainApp extends StatefulWidget {
  final ThemeProvider themeProvider;

  const MainApp({required this.themeProvider, Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventController(),
        ),
        ChangeNotifierProvider(
          create: (_) => widget.themeProvider,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const AuthWrapper(),
            routes: {
              'language': (context) => LanguageChangePage(() {
                    setState(() {});
                  }),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error state
          return const Center(child: Text('Something went wrong!'));
        } else if (snapshot.hasData) {
          // User is logged in
          return const OnboardingPage();
        } else {
          // User is not logged in
          return const LoginPage();
        }
      },
    );
  }
}
