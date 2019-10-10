import 'dart:convert';
import 'package:flutter_pokedex/Model/HttpAnswer.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:http/http.dart' as http;

export 'package:flutter_pokedex/Model/HttpAnswer.dart';

class GlobalRequest {
  static final GlobalRequest _instance = GlobalRequest._();
  static final String api = "db.pokemongohub.net";
  static final String image =
      "https://db.pokemongohub.net/images/official/detail/";
  static final String video = "https://db.pokemongohub.net/videos/";

  Map<String, String> _headers;
  String token;

  factory GlobalRequest() {
    return _instance;
  }

  GlobalRequest._() {
    this._headers = {"Content-Type": "application/json"};
  }

  Future<HttpAnswer<Type>> get<Type>(String path,
      {Map<String, String> params}) async {
    HttpAnswer<Type> response = HttpAnswer<Type>();

    try {
      Uri uri = Uri.http(GlobalRequest.api, path, params);
      response.answer = await http.get(uri, headers: this._headers);
      response.ok = response.answer.statusCode == 200;
    } catch (e) {
      response.reasonPhrase = e?.message;
    }

    return response;
  }

  Future<HttpAnswer<List<Pokemon>>> getPokedexGeneration(int generation) async {
    var response = await this
        .get<List<Pokemon>>("/api/pokemon/with-generation/$generation");

    if (response.ok) {
      List<dynamic> content = json.decode(response.answer.body);
      response.object = Pokemon.fromJsonCollection(content);
    } else {
      throw response.reasonPhrase;
    }
    return response;
  }

  Future<HttpAnswer<List<Pokemon>>> getPokedexByType(String type) async {
    var response = await this
        .get<List<Pokemon>>("/api/pokemon/with-type/${type.toLowerCase()}");

    if (response.ok) {
      List<dynamic> content = json.decode(response.answer.body);
      response.object = Pokemon.fromJsonCollection(content);
    } else {
      throw response.reasonPhrase;
    }
    return response;
  }

  Future<HttpAnswer<Pokemon>> getPokemon(Pokemon pokemon) async {
    var response = await this.get<Pokemon>("api/pokemon/${pokemon.id}",
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

  Future<HttpAnswer<Pokemon>> getPokemonMinimalInfo(int number) async {
    var response = await this.get<Pokemon>("api/pokemon/$number");

    if (response.ok) {
      response.object = Pokemon.fromJson(
        json.decode(response.answer.body),
      );
    } else {
      throw response.reasonPhrase;
    }

    return response;
  }
}
