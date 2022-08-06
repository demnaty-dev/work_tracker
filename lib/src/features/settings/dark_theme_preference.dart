import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const themeStatus = "THEME_STATUS";

  setDarkTheme(bool value) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return preference.getBool(themeStatus) ?? false;
  }
}
