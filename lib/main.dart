import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/Pokedex_page.dart';
import 'package:flutter_pokedex/pages/PokemonDetail_page.dart';
import 'package:flutter_pokedex/pages/PokemonVideo_page.dart';

import 'Pages/Home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => HomePage(),
        "pokedex": (BuildContext context) => PokedexPage(),
        "pokemonDetail": (BuildContext context) => PokemonDetailPage(),
        "pokemonVideo": (BuildContext context) => PokemonVideoPage(),
      },
      theme: ThemeData(
        primaryColor: Color.fromRGBO(155, 89, 182, 1),
        accentColor: Color.fromRGBO(52, 73, 92, 1),
        backgroundColor: Color.fromRGBO(155, 89, 182, 1),
        scaffoldBackgroundColor: Color.fromRGBO(155, 89, 182, 1),
        primaryColorDark: Color.fromRGBO(26, 188, 156, 1),
        primaryColorLight: Colors.green,
        brightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
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
      ),
    );
  }
}
