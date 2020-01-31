import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';

import 'Pages/Home_page.dart';
import 'Pages/Pokedex_page.dart';
import 'Pages/PokemonImage_page.dart';
import 'Pages/PokemonVideo_page.dart';
import 'Pages/PokemonSprite_page.dart';
import 'Pages/PokemonHeight_page.dart';
import 'pages/PokemonDetail_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Route route;

  switch (settings.name) {
    case "/":
      route = MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
      );
      break;
    case "pokedex":
      route = MaterialPageRoute(
        builder: (BuildContext context) => PokedexPage(
          settings.arguments,
        ),
      );
      break;
    case "pokemonDetail":
      route = MaterialPageRoute(
        builder: (BuildContext context) {
          PokedexProvider.of(context).loadPokemon(settings.arguments);
          return PokemonDetailTabPage();
        },
        settings: settings,
      );
      break;
    case "pokemonVideo":
      route = MaterialPageRoute(
        builder: (BuildContext context) => PokemonVideoPage(),
      );
      break;
    case "pokemonImage":
      route = MaterialPageRoute(
        builder: (BuildContext context) => PokemonImagePage(),
      );
      break;
    case "pokemonHeight":
      route = MaterialPageRoute(
        builder: (BuildContext context) => PokemonHeightPage(),
      );
      break;
    case "pokemonSprite":
      route = MaterialPageRoute(
        builder: (BuildContext context) => PokemonSpritePage(),
      );
      break;
  }
  return route;
}
