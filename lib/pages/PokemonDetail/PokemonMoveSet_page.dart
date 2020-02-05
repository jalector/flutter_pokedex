import 'package:Pokedex/Model/MoveSet.dart';
import 'package:Pokedex/Provider/PokedexProvider.dart';
import 'package:flutter/material.dart';

class PokemonMoveSet extends StatelessWidget {
  final Pokemon pokemon;

  PokemonMoveSet(this.pokemon);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Move set',
                style: theme.textTheme.title,
              ),
            ),
            _moveSetTable(context),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Moves',
                style: theme.textTheme.title,
              ),
            ),
            _movesTable(),
          ],
        ),
      ),
    );
  }

  Widget _moveSetTable(BuildContext context) {
    if (pokemon.moveSet != null) {
      return DataTable(
        columnSpacing: 10,
        horizontalMargin: 10,
        columns: [
          DataColumn(
            label: Text('Quick Move'),
          ),
          DataColumn(
            label: Text('Charged Move'),
          ),
          DataColumn(
            label: Text('DPS'),
            numeric: true,
          ),
          DataColumn(
            label: Text('TDO'),
            numeric: true,
          ),
          DataColumn(
            label: Text('TTFA'),
            numeric: true,
          ),
        ],
        rows: pokemon.moveSet.map<DataRow>(_moveSetRow).toList(),
      );
    } else {
      return Center(
        child: Container(child: Text("No move set available")),
      );
    }
  }

  DataRow _moveSetRow(MoveSet moveSet) {
    return DataRow(cells: [
      DataCell(
        Row(
          children: <Widget>[
            Image.asset(
              "assets/badges_type/${moveSet.quickMove.type}.png",
              scale: 1.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(moveSet.quickMove.name),
            ),
          ],
        ),
      ),
      DataCell(
        Row(
          children: <Widget>[
            Image.asset(
              "assets/badges_type/${moveSet.chargeMove.type}.png",
              scale: 1.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(moveSet.chargeMove.name),
            ),
          ],
        ),
      ),
      DataCell(
        Text(moveSet.weaveDps.toStringAsFixed(2)),
      ),
      DataCell(
        Text(moveSet.tdo.toStringAsFixed(2)),
      ),
      DataCell(
        Text((moveSet.timeToFirstActivation * 0.0001).toStringAsFixed(2)),
      ),
    ]);
  }

  DataRow _moveRow(Move move) {
    return DataRow(cells: [
      DataCell(
        Row(
          children: <Widget>[
            Image.asset(
              "assets/badges_type/${move.type}.png",
              scale: 1.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(move.name),
            ),
          ],
        ),
      ),
      DataCell(
        Text(move.typeMove),
      ),
      DataCell(
        Text(move.isLegacy ? "Yes" : "No"),
      ),
      DataCell(
        Text(move.isExclusive ? "Yes" : "No"),
      ),
    ]);
  }

  List<Move> _getAllMoves() {
    List<Move> moves = [];

    pokemon.moveSet.forEach((MoveSet e) {
      if (moves.indexOf(e.quickMove) == -1) moves.add(e.quickMove);
      if (moves.indexOf(e.chargeMove) == -1) moves.add(e.chargeMove);
    });
    return moves;
  }

  Widget _movesTable() {
    if (pokemon.moveSet != null) {
      return DataTable(
        columnSpacing: 10,
        horizontalMargin: 10,
        columns: [
          DataColumn(label: Text("Move")),
          DataColumn(label: Text("Type")),
          DataColumn(label: Text("Legacy")),
          DataColumn(label: Text("Exclusive")),
        ],
        rows: _getAllMoves().map<DataRow>(_moveRow).toList(),
      );
    } else {
      return Center(
        child: Container(child: Text("No move set available")),
      );
    }
  }
}
