import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:events_app/utils/thema_date.dart';

class ThemeSwitcherScreen extends StatelessWidget {
  const ThemeSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Theme'),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Dark Mode'),
          value: themeProvider.themeData.brightness == Brightness.dark,
          onChanged: (bool value) {
            themeProvider.toggleTheme();
          },
        ),
      ),
    );
  }
}
