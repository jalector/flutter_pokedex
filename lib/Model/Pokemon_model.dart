import 'dart:convert';

import 'package:flutter_pokedex/Provider/GlobalRequest.dart';

Pokemon pokemonFromJson(String str) => Pokemon.fromJson(json.decode(str));
String pokemonToJson(Pokemon data) => json.encode(data.toJson());

class Pokemon {
  int id;
  String name;
  dynamic form;
  String type1;
  String type2;
  int generation;
  int atk;
  int sta;
  int def;
  int maxcp;
  Pokemon alolaForm;

  Pokemon({
    this.id,
    this.name,
    this.form,
    this.type1,
    this.type2,
    this.generation,
    this.atk,
    this.sta,
    this.def,
    this.maxcp,
  });

  static String getURLImage(int number) {
    String n = number.toString();
    if (n.length == 1) {
      n = "00$n";
    } else if (n.length == 2) {
      n = "0$n";
    }
    return GlobalRequest.image + n + ".png";
  }

  static String getURLVideo(String name) {
    return "${GlobalRequest.video}$name-small.mp4";
  }

  static List<Pokemon> fromJsonCollection(List json) {
    List<Pokemon> list = [];

    for (var i = 0; i < json.length; i++) {
      var pokemon = Pokemon.fromJson(json[i]);
      if (pokemon.form != null) {
        list.last.alolaForm = pokemon;
      } else {
        list.add(pokemon);
      }
    }
    return list;
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        id: json["id"],
        name: json["name"],
        form: json["form"],
        type1: json["type1"],
        type2: json["type2"],
        generation: json["generation"],
        atk: json["atk"],
        sta: json["sta"],
        def: json["def"],
        maxcp: json["maxcp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "form": form,
        "type1": type1,
        "type2": type2,
        "generation": generation,
        "atk": atk,
        "sta": sta,
        "def": def,
        "maxcp": maxcp,
      };
}
