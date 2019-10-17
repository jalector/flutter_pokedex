import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Bloc/Pokedex_bloc.dart';
import 'package:flutter_pokedex/Model/Sprite.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';

class PokedexProvider extends InheritedWidget {
  static PokedexProvider _instance;
  final PokedexBloc bloc = PokedexBloc();
  final GlobalRequest _globalRequest = GlobalRequest();

  factory PokedexProvider({Key key, Widget child}) {
    if (PokedexProvider._instance == null) {
      _instance = PokedexProvider._(
        key: key,
        child: child,
      );
    }
    return _instance;
  }

  PokedexProvider._({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PokedexProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PokedexProvider)
        as PokedexProvider);
  }

  void getPokedexGeneration(int generation, {bool cleanPokedex = false}) async {
    if (cleanPokedex) this.bloc.addPokedex(null);

    if (this.bloc.pokedex != null && this.bloc.pokedex.length > 0) return;

    HttpAnswer<List<Pokemon>> answer = await this
        ._globalRequest
        .get<List<Pokemon>>(GlobalRequest.pokemonHub,
            "/api/pokemon/with-generation/$generation");

    if (answer.ok) {
      List<dynamic> content = json.decode(answer.answer.body);
      answer.object = Pokemon.fromJsonCollection(content);
      this.bloc.addPokedex(answer.object);
    } else {
      this.bloc.addPokedexError(answer.reasonPhrase);
    }
  }

  void getPokedexByType(String type, {bool cleanPokedex = false}) async {
    if (cleanPokedex) this.bloc.addPokedex(null);

    if (this.bloc.pokedex != null && this.bloc.pokedex.length > 0) return;

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.get<List<Pokemon>>(
              GlobalRequest.pokemonHub,
              "/api/pokemon/with-type/${type.toLowerCase()}",
            );

    if (answer.ok) {
      List<dynamic> content = json.decode(answer.answer.body);
      answer.object = Pokemon.fromJsonCollection(content);
      this.bloc.addPokedex(answer.object);
    } else {
      this.bloc.addPokedexError(answer.reasonPhrase);
    }
  }

  void searchPokemon(String searched) async {
    this.bloc.addPokedex(null);

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.get<List<Pokemon>>(
              GlobalRequest.pokemonHub,
              "api/search/$searched",
            );
    if (answer.ok) {
      List<Pokemon> found = [];

      List items = json.decode(answer.answer.body);

      for (Map rawPoke in items) {
        if (rawPoke["entity"] == "Pokemon") {
          found.add(Pokemon.fromJson(rawPoke));
        }
      }
      answer.object = found;

      if (answer.object.length > 0) {
        this.bloc.addPokedex(answer.object);
      } else {
        this.bloc.addPokedexError("No data found");
      }
    } else {
      this.bloc.addPokedexError(answer.reasonPhrase);
    }
  }

  void loadRandomPokemons(int amount, {bool cleanPokedex = false}) async {
    Random random = Random();

    if (cleanPokedex) this.bloc.addPokedex(null);

    this.bloc.isLoading(true);
    if (this.bloc.pokedex == null) {
      this.bloc.addPokedex([]);
    }

    print("Yuda: Estoy cargando datos: ${this.bloc.pokedex?.length}");

    for (var i = 0; i < amount; i++) {
      HttpAnswer<Pokemon> answer =
          await this.getPokemonMinimalInfo(random.nextInt(400) + 1);

      if (answer.ok) {
        List<Pokemon> list = this.bloc.pokedex ?? <Pokemon>[];
        list.add(answer.object);
        this.bloc.addPokedex(list);
      }
    }
    this.bloc.isLoading(false);
  }

  ///Futures, jus a snapshot for information

  Future<HttpAnswer<Pokemon>> getPokemon(Pokemon pokemon) async {
    print("YUDA:  getPokemon");

    var response = await this._globalRequest.get<Pokemon>(
        GlobalRequest.pokemonHub, "api/pokemon/${pokemon.id}",
        params: {"form": "${pokemon.form}"});

    var spriteResponse = await this._globalRequest.get<List<PokemonSprite>>(
        GlobalRequest.pokemonHub, "api/pokemon/${pokemon.id}/sprites");

    if (response.ok) {
      response.object = Pokemon.fromJsonDetail(
        json.decode(response.answer.body),
      );

      if (spriteResponse.ok) {
        response.object.sprites =
            PokemonSprite.fromJsonCollection(spriteResponse.answer.body);
      }
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
}
