import 'package:Pokedex/Pages/Moves_page.dart';
import 'package:flutter/material.dart';

import './Provider/PokedexProvider.dart';
import 'Pages/Home_page.dart';
import 'Pages/Pokedex_page.dart';
import 'Pages/PokemonImage_page.dart';
import 'Pages/PokemonVideo_page.dart';
import 'Pages/PokemonSprite_page.dart';
import 'Pages/PokemonHeight_page.dart';

import 'Pages/PokemonDetail/PokemonDetailTab_page.dart';

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
        settings: settings,
      );
      break;
    case "pokemonImage":
      route = MaterialPageRoute(
        builder: (BuildContext context) => PokemonImagePage(),
        settings: settings,
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
        settings: settings,
      );
      break;
    case "pokemonMoves":
      route = MaterialPageRoute(
        builder: (BuildContext context) {
          PokedexProvider.of(context).fetchAllCategoryMoves("charge");
          return MovesPage();
        },
        settings: settings,
      );
      break;
  }
  return route;
}
