import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  ThemeData getTheme() => this._themeData;

  void setTheme(ThemeData themeData) {
    this._themeData = themeData;

    notifyListeners();
  }
}
