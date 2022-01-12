import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  var primaryColor = Colors.pink;
  var secondaryColor = Colors.amber;
  var themeMode = ThemeMode.system;
  String themeText = 's';

  void changeThemeMode(var newThemeValue) async {
    themeMode = newThemeValue;
    _getThemeText(themeMode);
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeText', themeText);
  }

  void changeColors(Color newColor, int value) async {
    value == 1
        ? primaryColor = _toMaterialColor(newColor.hashCode)
        : secondaryColor = _toMaterialColor(newColor.hashCode);
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('primaryColor', primaryColor.value);
    prefs.setInt('secondaryColor', secondaryColor.value);
  }

  MaterialColor _toMaterialColor(int colorHashCode) {
    return MaterialColor(
      colorHashCode,
      <int, Color>{
        50: const Color(0xFFFFF8E1),
        100: const Color(0xFFFFECB3),
        200: const Color(0xFFFFE082),
        300: const Color(0xFFFFD54F),
        400: const Color(0xFFFFCA28),
        500: Color(colorHashCode),
        600: const Color(0xFFFFB300),
        700: const Color(0xFFFFA000),
        800: const Color(0xFFFF8F00),
        900: const Color(0xFFFF6F00),
      },
    );
  }

  void _getThemeText(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      themeText = 'd';
    } else if (themeMode == ThemeMode.light) {
      themeText = 'l';
    } else {
      themeText = 's';
    }
  }

  void getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeText = prefs.getString('themeText') ?? 's';
    if (themeText == 'd') {
      themeMode = ThemeMode.dark;
    } else if (themeText == 'l') {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void getThemeColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    primaryColor = _toMaterialColor(prefs.getInt('primaryColor') ?? 0xFFE91E63);
    secondaryColor =
        _toMaterialColor(prefs.getInt('secondaryColor') ?? 0xFFFFC107);
    notifyListeners();
  }

  void restoreSettings() async {
    primaryColor = Colors.pink;
    secondaryColor = Colors.amber;
    themeMode = ThemeMode.system;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('primaryColor');
    prefs.remove('secondaryColor');
    prefs.remove('themeText');
  }
}
