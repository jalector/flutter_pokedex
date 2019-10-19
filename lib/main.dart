import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/Pokedex_page.dart';
import 'package:flutter_pokedex/pages/PokemonDetail_page.dart';
import 'package:flutter_pokedex/pages/PokemonImage_page.dart';
import 'package:flutter_pokedex/pages/PokemonVideo_page.dart';

import 'Pages/Home_page.dart';
import 'Provider/PokedexProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PokedexProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokedex',
        initialRoute: "/",
        routes: <String, WidgetBuilder>{
          "/": (BuildContext context) => HomePage(),
          "pokedex": (BuildContext context) => PokedexPage(),
          "pokemonDetail": (BuildContext context) => PokemonDetailPage(),
          "pokemonVideo": (BuildContext context) => PokemonVideoPage(),
          "pokemonImage": (BuildContext context) => PokemonImagePage(),
        },
        theme: ThemeData.dark(),
      ),
    );
  }

  ThemeData _theme() {
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
            color: Colors.black,
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
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        display2: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        display3: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        display4: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        title: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        caption: TextStyle(
          fontSize: 15,
        ),
        overline: TextStyle(
          fontSize: 15,
        ),
        body1: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}
