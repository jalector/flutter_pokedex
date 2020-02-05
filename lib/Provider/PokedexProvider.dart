import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:Pokedex/Model/MoveSet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Bloc/Pokedex_bloc.dart';
import '../Model/New_model.dart';
import '../Model/Sprite_model.dart';
import '../Provider/GlobalRequest.dart';
import '../Model/Pokemon_model.dart';
export '../Model/Pokemon_model.dart';

class PokedexProvider extends InheritedWidget {
  final PokedexBloc bloc = PokedexBloc();

  final GlobalRequest _globalRequest = GlobalRequest();

  PokedexProvider({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PokedexProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PokedexProvider>();
  }

  ///Stream operations

  void getPokedexGeneration(int generation, {bool cleanPokedex = false}) async {
    if (cleanPokedex) bloc.clearPokedex();
    if (bloc.pokedex != null && bloc.pokedex.length > 0) return;

    HttpAnswer<List<Pokemon>> answer = await this
        ._globalRequest
        .get<List<Pokemon>>(GlobalRequest.pokemonHub,
            "/api/pokemon/with-generation/$generation");

    if (answer.ok) {
      List<dynamic> content = json.decode(answer.answer.body);
      answer.object = await compute(Pokemon.fromJsonCollection, content);
      bloc.pokedexAddList(answer.object);
    } else {
      bloc.pokedexAddError(answer.reasonPhrase);
    }
  }

  void getPokedexByType(String type, {bool cleanPokedex = false}) async {
    if (cleanPokedex) bloc.clearPokedex();
    if (bloc.pokedex != null && bloc.pokedex.length > 0) return;

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.get<List<Pokemon>>(
              GlobalRequest.pokemonHub,
              "/api/pokemon/with-type/${type.toLowerCase()}",
            );

    if (answer.ok) {
      List<dynamic> content = json.decode(answer.answer.body);
      answer.object = await compute(Pokemon.fromJsonCollection, content);
      bloc.pokedexAddList(answer.object);
    } else {
      bloc.pokedexAddError(answer.reasonPhrase);
    }
  }

  void searchPokemon(String searched) async {
    bloc.clearPokedex();

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.get<List<Pokemon>>(
              GlobalRequest.pokemonHub,
              "api/search/$searched",
            );
    if (answer.ok) {
      answer.object = json
          .decode(answer.answer.body)
          .where((element) => element["entity"] == "Pokemon")
          .map<Pokemon>(((poke) => Pokemon.fromJson(poke)))
          .toList();

      if (answer.object.length > 0) {
        bloc.pokedexAddList(answer.object);
      } else {
        bloc.pokedexAddError("No pokemon found T-T");
      }
    } else {
      bloc.pokedexAddError(answer.reasonPhrase);
    }
  }

  static Future<List<Pokemon>> searchPokemonParser(String rawJson) {
    return json
        .decode(rawJson)
        .where((element) => element["entity"] == "Pokemon")
        .map<Pokemon>(((poke) => Pokemon.fromJson(poke)))
        .toList();
  }

  void loadRandomPokemons(int amount, {bool cleanPokedex = false}) async {
    Random random = Random();

    if (cleanPokedex) bloc.clearPokedex();

    bloc.isLoading(true);

    if (bloc.pokedex == null) {
      bloc.pokedexAddList([]);
    }

    for (var i = 0; i < amount; i++) {
      HttpAnswer<Pokemon> answer =
          await this.getPokemonMinimalInfo(random.nextInt(400) + 1);

      if (answer.ok) {
        bloc.addPokemon(answer.object);
      }
    }
    bloc.isLoading(false);
  }

  /// Pokemon Height Controller Operations
  void addPokemonHeight(Pokemon pokemon, int index) async {
    Future<HttpAnswer<Pokemon>> fullPokemon = getPokemon(pokemon);

    var list = bloc.pokemonHeigh;
    list.add(pokemon..completePokemon(fullPokemon));
    bloc.addPokemonListHeight(list);
  }

  /// Filter mode controller
  Future<HttpAnswer<Pokemon>> getPokemon(Pokemon pokemon) async {
    var response = await this._globalRequest.get<Pokemon>(
        GlobalRequest.pokemonHub, "api/pokemon/${pokemon.id}",
        params: {"form": "${pokemon.form}"});

    if (response.ok) {
      response.object = Pokemon.fromJsonDetail(
        json.decode(response.answer.body),
      );
    } else {
      throw response.reasonPhrase;
    }

    return response;
  }

  Future<HttpAnswer<List<PokemonSprite>>> fetchPokemonSprite(
      int pokemonId) async {
    var response = await this._globalRequest.get<List<PokemonSprite>>(
          GlobalRequest.pokemonHub,
          "api/pokemon/$pokemonId/sprites",
        );

    if (response.ok) {
      response.object = PokemonSprite.fromJsonCollection(response.answer.body);
    } else {
      throw response.reasonPhrase;
    }

    return response;
  }

  Future<HttpAnswer<Pokemon>> getPokemonMinimalInfo(int number) async {
    var response = await this._globalRequest.get<Pokemon>(
        GlobalRequest.pokemonHub, "api/pokemon/minimal-identifiers/$number");

    if (response.ok) {
      response.object = Pokemon.fromJson(
        json.decode(response.answer.body),
      );
    } else {
      throw response.reasonPhrase;
    }

    return response;
  }

  Future<HttpAnswer<Pokemon>> getPokemonByNumber(int number) async {
    var response = await this
        ._globalRequest
        .get<Pokemon>(GlobalRequest.pokemonHub, "api/pokemon/$number");

    if (response.ok) {
      response.object = Pokemon.fromJsonDetail(
        json.decode(response.answer.body),
      );
    } else {
      throw response.reasonPhrase;
    }

    return response;
  }

  Future<HttpAnswer<List<New>>> getPokemonNews() async {
    var response = await this._globalRequest.get<List<New>>(
      "www.pokemon.com",
      "es/api/news",
      params: {"index": "0", "count": "4"},
    );

    if (response.ok) {
      response.object =
          New.fronJsonCollection(json.decode(response.answer.body));
    } else {
      throw response.reasonPhrase;
    }

    return response;
  }

  Future<HttpAnswer<List<Pokemon>>> getPokemonCounters(int id) async {
    var request = await this._globalRequest.get<List<Pokemon>>(
        GlobalRequest.pokemonHub, "api/pokemon/counters/$id");

    if (request.ok) {
      var data = json.decode(request.answer.body);

      print(data.runtimeType);
      request.object = Pokemon.fromJsonCounterCollection(data);
    } else {
      throw request.reasonPhrase;
    }

    return request;
  }

  Future<HttpAnswer<List<MoveSet>>> fetchPokemonMoveSet(int id) async {
    var request = await _globalRequest.get<List<MoveSet>>(
        GlobalRequest.pokemonHub, "api/movesets/with-pokemon/$id");

    if (request.ok) {
      var data = json.decode(request.answer.body);
      request.object = List<MoveSet>.from(data.map((x) => MoveSet.fromMap(x)));
    } else {
      throw request.reasonPhrase;
    }
    return request;
  }

  void loadPokemon(Pokemon poke) async {
    HttpAnswer<Pokemon> response = await getPokemon(poke);

    if (response.ok) {
      bloc.addPokemonDetail(response.object);
      loadPokemonBlocSprites();
      loadPokemonMoveSet();
    } else {
      bloc.addPokemonDetailError(response.reasonPhrase);
    }
  }

  void loadPokemonBlocSprites() async {
    Pokemon pokemon = bloc.pokemonDetail;
    fetchPokemonSprite(pokemon.id).then((HttpAnswer response) {
      if (response.ok) {
        pokemon.sprites = response.object;
        bloc.addPokemonDetail(pokemon);
      } else {
        bloc.addPokemonDetailError(response.reasonPhrase);
      }
    });
  }

  void loadPokemonMoveSet() async {
    Pokemon pokemon = bloc.pokemonDetail;
    fetchPokemonMoveSet(pokemon.id).then((HttpAnswer response) {
      if (response.ok) {
        pokemon.moveSet = response.object;
        bloc.addPokemonDetail(pokemon);
      }
    });
  }
}
