class Sprite {
  String form;
  List<SpriteElement> sprites;

  Sprite({
    this.form,
    this.sprites,
  });

  factory Sprite.fromJson(Map<String, dynamic> json) => Sprite(
        form: json["form"],
        sprites: List<SpriteElement>.from(
            json["sprites"].map((x) => SpriteElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "form": form,
        "sprites": List<dynamic>.from(sprites.map((x) => x.toJson())),
      };
}

class SpriteElement {
  String sprite;
  String gender;
  String form;
  bool shiny;

  SpriteElement({
    this.sprite,
    this.gender,
    this.form,
    this.shiny,
  });

  factory SpriteElement.fromJson(Map<String, dynamic> json) => SpriteElement(
        sprite: json["sprite"],
        gender: json["gender"],
        form: json["form"],
        shiny: json["shiny"],
      );

  Map<String, dynamic> toJson() => {
        "sprite": sprite,
        "gender": gender,
        "form": form,
        "shiny": shiny,
      };
}
