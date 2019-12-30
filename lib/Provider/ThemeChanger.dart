import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  static String darkModeKey = "themeNumber";
  static int totalNumberOfThemes = 3;
  ThemeData _themeData;
  int _themeNumber;

  ThemeChanger(this._themeNumber) {
    setTheme(this._themeNumber);
  }

  ThemeData getTheme() => this._themeData;

  int getActiveMode() => this._themeNumber;

  void setTheme(int themeData) {
    print("newThemeData $themeData");
    switch (themeData) {
      case 0:
        this._themeData = ThemeData.dark().copyWith(
          textTheme: TextTheme(
            title: TextStyle(fontFamily: "Roboto"),
          ),
        );
        break;
      case 1:
        this._themeData = ThemeData.light().copyWith(
          textTheme: TextTheme(
            title: TextStyle(fontFamily: "Roboto"),
          ),
        );
        break;
      case 2:
        this._themeData = _personalTheme();
        break;
    }

    notifyListeners();
  }

  ThemeData _personalTheme() {
    Color _primary = Color.fromRGBO(155, 89, 182, 1);
    Color _primaryVariant = Color.fromRGBO(155, 89, 182, 1);
    Color _secondary = Color.fromRGBO(52, 73, 92, 1);
    Color _secondaryVariant = Colors.red;
    return ThemeData(
      primaryColor: Color.fromRGBO(155, 89, 182, 1),
      accentColor: Color.fromRGBO(52, 73, 92, 1),
      backgroundColor: Color.fromRGBO(155, 89, 182, 1),
      scaffoldBackgroundColor: Color.fromRGBO(155, 89, 182, 1),
      primaryColorDark: Color.fromRGBO(26, 188, 156, 1),
      primaryColorLight: Colors.green,
      brightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      buttonColor: _secondaryVariant,
      fontFamily: 'Avocado',
      appBarTheme: AppBarTheme(
        color: _primary,
        textTheme: TextTheme(
          display1: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          display2: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          display3: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          display4: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          title: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      colorScheme: ColorScheme(
        primary: _primary,
        primaryVariant: _primaryVariant,
        secondary: _secondary,
        secondaryVariant: _secondaryVariant,
        surface: Colors.black,
        background: Colors.black,
        error: Colors.red,
        onPrimary: _primary,
        onSecondary: _primaryVariant,
        onSurface: _primary,
        onBackground: Colors.purple,
        onError: Colors.red,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        display1: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        display2: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        display3: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        display4: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        title: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        caption: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 15,
        ),
        overline: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 15,
        ),
        body1: TextStyle(
          fontFamily: 'Avocado',
          fontSize: 15,
        ),
      ),
    );
  }
}
