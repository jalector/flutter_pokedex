import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/Pokedex_page.dart';
import 'package:flutter_pokedex/pages/PokemonDetail_page.dart';
import 'package:flutter_pokedex/pages/PokemonVideo_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => PokedexPage(),
        "pokemonDetail": (BuildContext context) => PokemonDetailPage(),
        "pokemonVideo": (BuildContext context) => PokemonVideoPage(),
      },
      theme: ThemeData(
        textTheme: TextTheme(
          display1: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          display2: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
          display3: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
          display4: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
          title: TextStyle(
            fontSize: 30,
          ),
          caption: TextStyle(
            fontSize: 15,
            color: Color.fromRGBO(50, 50, 50, 1),
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
