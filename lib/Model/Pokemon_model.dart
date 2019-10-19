import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Sprite.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Util.dart';

class Pokemon {
  int id;
  String name;
  String form;
  String type1;
  String type2;
  int atk;
  int sta;
  int def;
  int isMythical;
  int isLegendary;
  int generation;
  int candyToEvolve;
  int kmBuddyDistance;
  double baseCaptureRate;
  String description;
  double weight;
  double height;
  int buddySize;
  double baseFleeRate;
  int kmDistanceToHatch;
  int thirdMoveStardust;
  int thirdMoveCandy;
  List<Pokemon> family;
  int isDeployable;
  int isTransferable;
  int bonusStardustCaptureReward;
  int bonusCandyCaptureReward;
  String templateId;
  dynamic evolutionItemRequirement;
  double male;
  double female;
  int genderless;
  List<Form> forms;
  List<Description> descriptions;
  List<TypeChart> typeChart;
  List<String> weatherInfluences;
  List<PokemonSprite> sprites;
  Map<String, int> cPs;
  int maxcp;

  static List<String> types = [
    "Bug",
    "Dragon",
    "Fairy",
    "Fire",
    "Ghost",
    "Ground",
    "Normal",
    "Psychic",
    "Steel",
    "Dark",
    "Electric",
    "Fighting",
    "Flying",
    "Grass",
    "Ice",
    "Poison",
    "Rock",
    "Water",
  ];

  Pokemon({
    this.id,
    this.name,
    this.form,
    this.type1,
    this.type2,
    this.atk,
    this.sta,
    this.def,
    this.isMythical,
    this.isLegendary,
    this.generation,
    this.candyToEvolve,
    this.kmBuddyDistance,
    this.baseCaptureRate,
    this.description,
    this.weight,
    this.height,
    this.buddySize,
    this.baseFleeRate,
    this.kmDistanceToHatch,
    this.thirdMoveStardust,
    this.thirdMoveCandy,
    this.family,
    this.isDeployable,
    this.isTransferable,
    this.bonusStardustCaptureReward,
    this.bonusCandyCaptureReward,
    this.templateId,
    this.evolutionItemRequirement,
    this.male,
    this.female,
    this.genderless,
    this.forms,
    this.descriptions,
    this.typeChart,
    this.weatherInfluences,
    this.cPs,
    this.maxcp,
  });

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

  factory Pokemon.fromJsonDetail(Map<String, dynamic> json) {
    List<Pokemon> family = List<Pokemon>();
    if (json["family"] != null) {
      family =
          List<Pokemon>.from(json["family"].map((x) => Pokemon.fromJson(x)));
    }

    return Pokemon(
      id: json["id"],
      name: json["name"],
      form: json["form"],
      type1: json["type1"],
      type2: json["type2"],
      atk: json["atk"],
      sta: json["sta"],
      def: json["def"],
      isMythical: json["isMythical"],
      isLegendary: json["isLegendary"],
      generation: json["generation"],
      candyToEvolve: json["candyToEvolve"],
      kmBuddyDistance: json["kmBuddyDistance"],
      baseCaptureRate: json["baseCaptureRate"].toDouble(),
      description: json["description"] ?? "No description available",
      weight: json["weight"]?.toDouble(),
      height: json["height"]?.toDouble(),
      buddySize: json["buddySize"],
      baseFleeRate: json["baseFleeRate"].toDouble(),
      kmDistanceToHatch: json["kmDistanceToHatch"],
      thirdMoveStardust: json["thirdMoveStardust"],
      thirdMoveCandy: json["thirdMoveCandy"],
      family: family,
      isDeployable: json["is_deployable"],
      isTransferable: json["is_transferable"],
      bonusStardustCaptureReward: json["bonus_stardust_capture_reward"],
      bonusCandyCaptureReward: json["bonus_candy_capture_reward"],
      templateId: json["template_id"],
      evolutionItemRequirement: json["evolutionItemRequirement"],
      male: json["male"].toDouble(),
      female: json["female"].toDouble(),
      genderless: json["genderless"],
      forms: List<Form>.from(json["forms"].map((x) => Form.fromJson(x))),
      descriptions: List<Description>.from(
          json["descriptions"].map((x) => Description.fromJson(x))),
      typeChart: List<TypeChart>.from(
          json["typeChart"].map((x) => TypeChart.fromJson(x))),
      weatherInfluences:
          List<String>.from(json["weatherInfluences"].map((x) => x)),
      cPs: Map.from(json["CPs"]).map((k, v) => MapEntry<String, int>(k, v)),
      maxcp: json["maxcp"],
    );
  }

  static String getURLImage(int number, String form) {
    String n = number.toString();
    if (n.length == 1) {
      n = "00$n";
    } else if (n.length == 2) {
      n = "0$n";
    }
    var a = GlobalRequest.image + n + "${(form != null) ? "_f2" : ""}.png";

    return a;
  }

  static String getURLVideo(String name) {
    return "${GlobalRequest.video}$name-small.mp4";
  }

  static String getUrlBadgetype(String type) {
    return "https://db.pokemongohub.net/images/badges/thumb/Badge_Type_${Util.capitalize(type)}_01.png";
  }

  static List<Pokemon> fromJsonCollection(List json) {
    List<Pokemon> list = [];

    for (var i = 0; i < json.length; i++) {
      var pokemon = Pokemon.fromJson(json[i]);
      list.add(pokemon);
    }
    return list;
  }

  static Color chooseByPokemonType(String type) {
    Color color = Colors.blue;
    switch (type.toLowerCase()) {
      case "grass":
        color = Colors.green;
        break;
      case "bug":
        color = Colors.greenAccent;
        break;
      case "dark":
        color = Colors.black38;
        break;
      case "dragon":
        color = Colors.purple;
        break;
      case "electric":
        color = Colors.yellow;
        break;
      case "fairy":
        color = Colors.pink[200];
        break;
      case "fighting":
        color = Colors.brown[700];
        break;
      case "fire":
        color = Colors.red[600];
        break;
      case "flying":
        color = Colors.blue;
        break;
      case "ghost":
        color = Colors.purple;
        break;
      case "ground":
        color = Colors.brown[200];
        break;
      case "ice":
        color = Colors.cyan[300];
        break;
      case "normal":
        color = Colors.brown[800];
        break;
      case "poison":
        color = Colors.purple;
        break;
      case "psychic":
        color = Colors.pink;
        break;
      case "rock":
        color = Colors.brown[300];
        break;
      case "steel":
        color = Color.fromRGBO(160, 160, 160, 1.0);
        break;
      case "water":
        color = Colors.blue[600];
        break;
    }
    return color;
  }

  @override
  String toString() {
    return "#$id $name";
  }
}

class Description {
  String descMeta;
  String descMoves;
  String descPvp;
  String pveRate;
  String pvpRate;
  String trainer;
  String lvl;

  Description({
    this.descMeta,
    this.descMoves,
    this.descPvp,
    this.pveRate,
    this.pvpRate,
    this.trainer,
    this.lvl,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        descMeta: json["desc_meta"] == null ? null : json["desc_meta"],
        descMoves: json["desc_moves"] == null ? null : json["desc_moves"],
        descPvp: json["desc_pvp"] == null ? null : json["desc_pvp"],
        pveRate: json["pve_rate"] == null ? null : json["pve_rate"],
        pvpRate: json["pvp_rate"],
        trainer: json["trainer"] == null ? null : json["trainer"],
        lvl: json["lvl"] == null ? null : json["lvl"],
      );

  Map<String, dynamic> toJson() => {
        "desc_meta": descMeta == null ? null : descMeta,
        "desc_moves": descMoves == null ? null : descMoves,
        "desc_pvp": descPvp == null ? null : descPvp,
        "pve_rate": pveRate == null ? null : pveRate,
        "pvp_rate": pvpRate,
        "trainer": trainer == null ? null : trainer,
        "lvl": lvl == null ? null : lvl,
      };
}

class Form {
  String name;
  String value;

  Form({
    this.name,
    this.value,
  });

  factory Form.fromJson(Map<String, dynamic> json) => Form(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

class TypeChart {
  String type;
  Status status;
  StatusModifier statusModifier;
  double effectiveness;

  TypeChart({
    this.type,
    this.status,
    this.statusModifier,
    this.effectiveness,
  });

  factory TypeChart.fromJson(Map<String, dynamic> json) => TypeChart(
        type: json["type"],
        status: statusValues.map[json["status"]],
        statusModifier: statusModifierValues.map[json["statusModifier"]],
        effectiveness: json["effectiveness"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": statusValues.reverse[status],
        "statusModifier": statusModifierValues.reverse[statusModifier],
        "effectiveness": effectiveness,
      };
}

enum Status { NORMAL, ADV, DIS }

final statusValues =
    EnumValues({"adv": Status.ADV, "dis": Status.DIS, "normal": Status.NORMAL});

enum StatusModifier { EFF_1_X, EFF_2_X }

final statusModifierValues = EnumValues(
    {"eff-1x": StatusModifier.EFF_1_X, "eff-2x": StatusModifier.EFF_2_X});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
