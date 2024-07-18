import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void _setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  Future<void> setLightTheme() async {
    _setTheme(lightTheme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', false);
  }

  Future<void> setDarkTheme() async {
    _setTheme(darkTheme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', true);
  }

  Future<void> toggleTheme() async {
    if (_themeData.brightness == Brightness.light) {
      await setDarkTheme();
    } else {
      await setLightTheme();
    }
  }

  static Future<ThemeProvider> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    return ThemeProvider(isDarkTheme ? darkTheme : lightTheme);
  }
}
