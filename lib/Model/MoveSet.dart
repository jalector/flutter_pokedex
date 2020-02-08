import 'Move.dart';

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
        quickMove: Move.fromMap(json["quickMove"], category: "Fast"),
        chargeMove: Move.fromMap(json["chargeMove"], category: "Charge"),
        isQuickMoveBoostedByWeather: json["isQuickMoveBoostedByWeather"],
        isChargeMoveBoostedByWeather: json["isChargeMoveBoostedByWeather"],
        weaveDps:
            (json["weaveDPS"] == null) ? null : json["weaveDPS"].toDouble(),
        tdo: (json["tdo"] == null) ? null : json["tdo"].toDouble(),
        timeToFirstActivation: json["timeToFirstActivation"],
      );
}
