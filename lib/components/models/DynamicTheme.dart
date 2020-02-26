import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DynamicTheme with ChangeNotifier {
  ThemeMode isDarkMode;

  Icon icon = Icon(Icons.brightness_7);

  getDarkMode() => this.isDarkMode;

  void changeDarkMode(isDarkMode) {
    if (isDarkMode == ThemeMode.dark) {
      this.isDarkMode = ThemeMode.light;
      icon = Icon(Icons.brightness_3);
    } else {
      this.isDarkMode = ThemeMode.dark;
      icon = Icon(Icons.brightness_7);
    }
    notifyListeners();
    print("DynamicTheme: 'Current theme: ${isDarkMode.toString()}.'");
  }
}
