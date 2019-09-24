import 'dart:convert';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:http/http.dart' as http;

class GlobalRequest {
  static final GlobalRequest _instance = GlobalRequest._();
  static final String api = "https://db.pokemongohub.net/api/";
  static final String image =
      "https://db.pokemongohub.net/images/official/detail/";
  static final String video = "https://db.pokemongohub.net/videos/";

  factory GlobalRequest() {
    return _instance;
  }

  GlobalRequest._();

  Future<List<Pokemon>> getPokedexGeneration(int generation) async {
    List<Pokemon> answer = [];
    http.Response response =
        await http.get("${api}pokemon/with-generation/$generation");
    if (response.statusCode == 200) {
      List<dynamic> content = json.decode(response.body);
      answer = Pokemon.fromJsonCollection(content);
    }
    return answer;
  }

  Future<Pokemon> getPokemon(int number) async {
    Pokemon answer;
    http.Response response = await http.get("${api}pokemon/$number");

    if (response.statusCode == 200) {
      answer = Pokemon.fromJsonDetail(json.decode(response.body));
    }

    return answer;
  }

  Future<Pokemon> getPokemonMinimalInfo(int number) async {
    Pokemon answer;
    http.Response response =
        await http.get("${api}pokemon/minimal-identifiers/$number");

    if (response.statusCode == 200) {
      answer = Pokemon.fromJson(json.decode(response.body));
    }

    return answer;
  }
}
