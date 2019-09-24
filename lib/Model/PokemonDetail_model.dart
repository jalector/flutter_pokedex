class PokemonDetail {
  int id;
  String name;
  dynamic form;
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
  List<Family> family;
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
  Map<String, int> cPs;
  int maxcp;

  PokemonDetail({
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

  factory PokemonDetail.fromJson(Map<String, dynamic> json) => PokemonDetail(
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
        description: json["description"],
        weight: json["weight"].toDouble(),
        height: json["height"].toDouble(),
        buddySize: json["buddySize"],
        baseFleeRate: json["baseFleeRate"].toDouble(),
        kmDistanceToHatch: json["kmDistanceToHatch"],
        thirdMoveStardust: json["thirdMoveStardust"],
        thirdMoveCandy: json["thirdMoveCandy"],
        family:
            List<Family>.from(json["family"].map((x) => Family.fromJson(x))),
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "form": form,
        "type1": type1,
        "type2": type2,
        "atk": atk,
        "sta": sta,
        "def": def,
        "isMythical": isMythical,
        "isLegendary": isLegendary,
        "generation": generation,
        "candyToEvolve": candyToEvolve,
        "kmBuddyDistance": kmBuddyDistance,
        "baseCaptureRate": baseCaptureRate,
        "description": description,
        "weight": weight,
        "height": height,
        "buddySize": buddySize,
        "baseFleeRate": baseFleeRate,
        "kmDistanceToHatch": kmDistanceToHatch,
        "thirdMoveStardust": thirdMoveStardust,
        "thirdMoveCandy": thirdMoveCandy,
        "family": List<dynamic>.from(family.map((x) => x.toJson())),
        "is_deployable": isDeployable,
        "is_transferable": isTransferable,
        "bonus_stardust_capture_reward": bonusStardustCaptureReward,
        "bonus_candy_capture_reward": bonusCandyCaptureReward,
        "template_id": templateId,
        "evolutionItemRequirement": evolutionItemRequirement,
        "male": male,
        "female": female,
        "genderless": genderless,
        "forms": List<dynamic>.from(forms.map((x) => x.toJson())),
        "descriptions": List<dynamic>.from(descriptions.map((x) => x.toJson())),
        "typeChart": List<dynamic>.from(typeChart.map((x) => x.toJson())),
        "weatherInfluences":
            List<dynamic>.from(weatherInfluences.map((x) => x)),
        "CPs": Map.from(cPs).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "maxcp": maxcp,
      };
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

class Family {
  int id;
  String name;
  String form;
  String type1;
  String type2;
  int generation;
  int atk;
  int sta;
  int def;
  int maxcp;

  Family({
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

  factory Family.fromJson(Map<String, dynamic> json) => Family(
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
