import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  static String darkModeKey = "DarkMode";
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeChanger(this._isDarkMode) {
    if (this._isDarkMode) {
      this._themeData = ThemeData.dark();
    } else {
      this._themeData = ThemeData.light();
    }
  }

  ThemeData getTheme() => this._themeData;
  bool getActiveMode() => this._isDarkMode;

  void setTheme(ThemeData themeData) {
    this._themeData = themeData;
    notifyListeners();
  }

  void setDarkMode(bool activeDarkMode) {
    this._isDarkMode = activeDarkMode;
    if (this._isDarkMode) {
      this._themeData = ThemeData.dark();
    } else {
      this._themeData = ThemeData.light();
    }
    notifyListeners();
  }
}
