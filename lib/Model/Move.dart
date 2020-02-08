class Move {
  int id;
  String name;
  String type;
  String category;
  bool isLegacy;
  bool isExclusive;

  int power;
  int duration;
  int energy;
  int damageWindow;
  int energyBars;
  int critPercentage;
  int isQuickMove;
  int damageWindowStart;
  int damageWindowEnd;
  int pvpPower;
  int pvpEnergy;
  int pvpDuration;
  String templateId;
  String movementId;
  double eps;
  double dps;
  double dpePve;
  double dpesPve;
  double ept;
  double dpt;
  double dpePvp;
  double dpetPvp;

  Move({
    this.id,
    this.name,
    this.type,
    this.isLegacy,
    this.isExclusive,
    this.category,
    this.power,
    this.duration,
    this.energy,
    this.damageWindow,
    this.energyBars,
    this.critPercentage,
    this.isQuickMove,
    this.damageWindowStart,
    this.damageWindowEnd,
    this.pvpPower,
    this.pvpEnergy,
    this.pvpDuration,
    this.templateId,
    this.movementId,
    this.eps,
    this.dps,
    this.dpePve,
    this.dpesPve,
    this.ept,
    this.dpt,
    this.dpePvp,
    this.dpetPvp,
  });

  factory Move.fromMap(Map<String, dynamic> json, {String category}) => Move(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        isLegacy: json["isLegacy"] == 1,
        isExclusive: json["isExclusive"] == 1,
        category: category,
        power: json["power"],
        duration: json["duration"],
        energy: json["energy"],
        damageWindow: json["damageWindow"],
        energyBars: json["energyBars"],
        critPercentage: json["critPercentage"],
        isQuickMove: json["isQuickMove"],
        damageWindowStart: json["damageWindowStart"],
        damageWindowEnd: json["damageWindowEnd"],
        pvpPower: json["pvpPower"],
        pvpEnergy: json["pvpEnergy"],
        pvpDuration: json["pvpDuration"],
        templateId: json["template_id"],
        movementId: json["movement_id"],
        eps: (json["eps"] == null) ? null : json["eps"].toDouble(),
        dps: (json["dps"] == null) ? null : json["dps"].toDouble(),
        dpePve: json["dpe_pve"] == null ? null : json["dpe_pve"].toDouble(),
        dpesPve:
            (json["dpes_pve"] == null) ? null : json["dpes_pve"].toDouble(),
        ept: (json["ept"] == null) ? null : json["ept"].toDouble(),
        dpt: (json["dpt"] == null) ? null : json["dpt"].toDouble(),
        dpePvp: json["dpe_pvp"] == null ? null : json["dpe_pvp"].toDouble(),
        dpetPvp:
            (json["dpet_pvp"] == null) ? null : json["dpet_pvp"].toDouble(),
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
