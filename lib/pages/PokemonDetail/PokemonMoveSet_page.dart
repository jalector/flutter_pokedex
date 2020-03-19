import 'package:Pokedex/Model/Move.dart';
import 'package:flutter/material.dart';

import 'package:Pokedex/Model/MoveSet.dart';
import 'package:Pokedex/Provider/PokedexProvider.dart';
import '../../Util.dart';

class PokemonMoveSet extends StatefulWidget {
  final Pokemon pokemon;

  PokemonMoveSet(this.pokemon);

  @override
  _PokemonMoveSetState createState() => _PokemonMoveSetState();
}

class _PokemonMoveSetState extends State<PokemonMoveSet> {
  int moveSetIndexColumnSorted = 0;
  bool moveSetSortedAscending = true;

  int movesIndexColumnSorted = 0;
  bool movesSelectedAscending = true;

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
    if (widget.pokemon.moveSet != null && widget.pokemon.moveSet.length > 0) {
      return DataTable(
        sortColumnIndex: moveSetIndexColumnSorted,
        sortAscending: moveSetSortedAscending,
        dataRowHeight: 35,
        columnSpacing: 10,
        horizontalMargin: 10,
        columns: [
          DataColumn(
            label: Text(
              'Quick Move',
              overflow: TextOverflow.ellipsis,
            ),
            onSort: _sortMoveSetTable,
          ),
          DataColumn(
            label: Text(
              'Charged Move',
              overflow: TextOverflow.ellipsis,
            ),
            onSort: _sortMoveSetTable,
          ),
          DataColumn(
            label: Text('DPS'),
            onSort: _sortMoveSetTable,
            numeric: true,
          ),
          DataColumn(
            label: Text('TDO'),
            onSort: _sortMoveSetTable,
            numeric: true,
          ),
          DataColumn(
            label: Text('TTFA'),
            onSort: _sortMoveSetTable,
            numeric: true,
          ),
        ],
        rows: _sortMoveSetData,
      );
    } else {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("No move set available"),
        ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  moveSet.quickMove.name,
                ),
              ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  moveSet.chargeMove.name,
                ),
              ),
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

  List<DataRow> get _sortMoveSetData {
    var data = List<MoveSet>.from(widget.pokemon.moveSet);

    data.sort((MoveSet a, MoveSet b) {
      MoveSet x, y;
      Comparable comparable;
      if (moveSetSortedAscending) {
        x = a;
        y = b;
      } else {
        x = b;
        y = a;
      }

      switch (moveSetIndexColumnSorted) {
        case 0:
          comparable = x.quickMove.name.compareTo(y.quickMove.name);
          break;
        case 1:
          comparable = x.chargeMove.name.compareTo(y.chargeMove.name);
          break;
        case 2:
          comparable = x.weaveDps.compareTo(y.weaveDps);
          break;
        case 3:
          comparable = x.tdo.compareTo(y.tdo);
          break;
        case 4:
          comparable =
              x.timeToFirstActivation.compareTo(y.timeToFirstActivation);
          break;
      }
      return comparable;
    });

    return data.map<DataRow>(_moveSetRow).toList();
  }

  void _sortMoveSetTable(int index, bool ascending) {
    setState(() {
      moveSetIndexColumnSorted = index;
      moveSetSortedAscending = ascending;
    });
  }

  Widget _movesTable() {
    if (widget.pokemon.moveSet != null && widget.pokemon.moveSet.length > 0) {
      return DataTable(
        dataRowHeight: 35,
        columnSpacing: 10,
        horizontalMargin: 10,
        sortAscending: movesSelectedAscending,
        sortColumnIndex: movesIndexColumnSorted,
        columns: [
          DataColumn(
            label: Text("Move"),
            onSort: _sortMovesTable,
          ),
          DataColumn(
            label: Text(
              "Type",
              overflow: TextOverflow.ellipsis,
            ),
            onSort: _sortMovesTable,
          ),
          DataColumn(
            label: Text("Kind"),
            onSort: _sortMovesTable,
          ),
          DataColumn(
            label: Text("Legacy"),
            onSort: _sortMovesTable,
          ),
          DataColumn(
            label: Text("Exclusive"),
            onSort: _sortMovesTable,
          ),
        ],
        rows: _sortedMoves,
      );
    } else {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("No move set available"),
        ),
      );
    }
  }

  List<DataRow> get _sortedMoves {
    var data = _getAllMoves();

    data.sort((Move a, Move b) {
      Move x, y;
      Comparable comparable;
      if (movesSelectedAscending) {
        x = b;
        y = a;
      } else {
        x = a;
        y = b;
      }

      switch (movesIndexColumnSorted) {
        case 0:
          comparable = x.name.compareTo(y.name);
          break;
        case 1:
          comparable = x.type.compareTo(y.type);
          break;
        case 2:
          comparable = x.category.compareTo(y.category);
          break;
        case 3:
          comparable = x.isLegacy.toString().compareTo(y.isLegacy.toString());
          break;
        case 4:
          comparable =
              x.isExclusive.toString().compareTo(y.isExclusive.toString());
          break;
      }
      return comparable;
    });

    return data.map<DataRow>(_moveRow).toList();
  }

  DataRow _moveRow(Move move) {
    return DataRow(cells: [
      DataCell(
        Text(move.name),
      ),
      DataCell(
        Row(
          children: <Widget>[
            Flexible(
              child: Image.asset(
                "assets/badges_type/${move.type}.png",
                scale: 1.8,
              ),
            ),
            SizedBox(width: 5),
            Flexible(
              child: Text(Util.capitalize(move.type)),
            )
          ],
        ),
      ),
      DataCell(
        Text(move.category),
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

    widget.pokemon.moveSet.forEach((MoveSet e) {
      if (moves.indexOf(e.quickMove) == -1) moves.add(e.quickMove);
      if (moves.indexOf(e.chargeMove) == -1) moves.add(e.chargeMove);
    });
    return moves;
  }

  void _sortMovesTable(int index, bool ascending) {
    setState(() {
      movesIndexColumnSorted = index;
      movesSelectedAscending = ascending;
    });
  }
}
