class MoveSet {
  Move quickMove;
  Move chargeMove;
  bool isQuickMoveBoostedByWeather;
  bool isChargeMoveBoostedByWeather;
  double weaveDps;
  double tdo;
  int timeToFirstActivation;

  MoveSet({
    this.quickMove,
    this.chargeMove,
    this.isQuickMoveBoostedByWeather,
    this.isChargeMoveBoostedByWeather,
    this.weaveDps,
    this.tdo,
    this.timeToFirstActivation,
  });

  factory MoveSet.fromMap(Map<String, dynamic> json) => MoveSet(
        quickMove: Move.fromMap(json["quickMove"], "Quick move"),
        chargeMove: Move.fromMap(json["chargeMove"], "Charge move"),
        isQuickMoveBoostedByWeather: json["isQuickMoveBoostedByWeather"],
        isChargeMoveBoostedByWeather: json["isChargeMoveBoostedByWeather"],
        weaveDps: json["weaveDPS"].toDouble(),
        tdo: json["tdo"].toDouble(),
        timeToFirstActivation: json["timeToFirstActivation"],
      );
}

class Move {
  int id;
  String name;
  String type;
  String typeMove;
  bool isLegacy;
  bool isExclusive;

  Move({
    this.id,
    this.name,
    this.type,
    this.isLegacy,
    this.isExclusive,
    this.typeMove,
  });

  factory Move.fromMap(Map<String, dynamic> json, String typeMove) => Move(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        isLegacy: json["isLegacy"] == 1,
        isExclusive: json["isExclusive"] == 1,
        typeMove: typeMove,
      );

  @override
  String toString() => "#$id $name";

  @override
  bool operator ==(move) {
    var equal = false;

    if ("Move" == move.runtimeType.toString()) {
      equal = move.name == this.name;
    } else {
      equal = identical(this, move);
    }
    return equal;
  }

  @override
  int get hashCode => id.hashCode;
}
