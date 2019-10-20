import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Provider/ThemeChanger.dart';
import 'package:flutter_pokedex/pages/Pokedex_page.dart';
import 'package:flutter_pokedex/pages/PokemonDetail_page.dart';
import 'package:flutter_pokedex/pages/PokemonImage_page.dart';
import 'package:flutter_pokedex/pages/PokemonVideo_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/Home_page.dart';
import 'Provider/PokedexProvider.dart';

void main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  runApp(MyApp(preferences.getInt(ThemeChanger.darkModeKey) ?? 0));
}

class MyApp extends StatefulWidget {
  final int themeNumber;
  MyApp(this.themeNumber);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return PokedexProvider(
      child: ChangeNotifierProvider(
        builder: (BuildContext context) => ThemeChanger(widget.themeNumber),
        child: Pokedex(),
      ),
    );
  }
}

class Pokedex extends StatelessWidget {
  const Pokedex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
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
      theme: theme.getTheme(),
    );
  }
}
