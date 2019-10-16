import 'dart:convert';

class PokemonSprite {
  String form;
  List<Sprite> sprites;

  PokemonSprite({
    this.form,
    this.sprites,
  });

  static List<PokemonSprite> fromJsonCollection(String str) {
    List<PokemonSprite> list = [];
    List<dynamic> rawJson = json.decode(str);

    rawJson.forEach((x) {
      PokemonSprite sprite = PokemonSprite.fromMap(x);
      list.add(sprite);
    });

    return list;
  }

  factory PokemonSprite.fromJson(String str) =>
      PokemonSprite.fromMap(json.decode(str));

  factory PokemonSprite.fromMap(Map<String, dynamic> json) {
    return PokemonSprite(
      form: json["form"],
      sprites: List<Sprite>.from(json["sprites"].map((x) => Sprite.fromMap(x))),
    );
  }
}

class Sprite {
  String sprite;
  String gender;
  String form;
  bool shiny;

  Sprite({
    this.sprite,
    this.gender,
    this.form,
    this.shiny,
  });

  factory Sprite.fromJson(String str) => Sprite.fromMap(json.decode(str));

  factory Sprite.fromMap(Map<String, dynamic> json) => Sprite(
        sprite: json["sprite"],
        gender: json["gender"],
        form: json["form"],
        shiny: json["shiny"],
      );
}
