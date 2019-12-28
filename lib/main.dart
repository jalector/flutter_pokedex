import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Provider/ThemeChanger.dart';
import 'package:flutter_pokedex/Pages/Home_page.dart';
import 'package:flutter_pokedex/Pages/Pokedex_page.dart';
import 'package:flutter_pokedex/Pages/PokemonDetail_page.dart';
import 'package:flutter_pokedex/Pages/PokemonImage_page.dart';
import 'package:flutter_pokedex/Pages/PokemonVideo_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Provider/PokedexProvider.dart';

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var theme = 0;

  if (Platform.isAndroid || Platform.isIOS) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    theme = preferences.getInt(ThemeChanger.darkModeKey) ?? 0;
  }
  runApp(MyApp(theme));
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
