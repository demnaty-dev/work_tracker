import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const themeStatus = "THEME_STATUS";
  static const lightTheme = 0;
  static const darkTheme = 1;
  static const systemTheme = 2;
  int _themeState = 0;

  Future<void> initTheme() async {
    _themeState = await getTheme();
  }

  int get themeState => _themeState;

  set themeState(int value) {
    _themeState = value;
    setTheme(value);
    notifyListeners();
  }

  setTheme(int value) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setInt(themeStatus, value);
  }

  Future<int> getTheme() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return preference.getInt(themeStatus) ?? 0;
  }

  bool isDarkMode(BuildContext context) {
    if (_themeState == 2) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeState == 1;
  }
}
