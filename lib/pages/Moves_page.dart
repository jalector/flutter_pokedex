import 'package:Pokedex/Model/Move.dart';
import 'package:Pokedex/Provider/PokedexProvider.dart';
import 'package:Pokedex/Widget/CustomLoader.dart';
import 'package:flutter/material.dart';

class MovesPage extends StatefulWidget {
  @override
  _MovesPageState createState() => _MovesPageState();
}

class _MovesPageState extends State<MovesPage> {
  int columnIndex = 0;
  bool isAscSort = true;
  String categorySelected = "Charge";
  List<String> categorys = ["Charge", "Fast"];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Moves", style: Theme.of(context).textTheme.headline4),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '$categorySelected moves',
                        style: theme.textTheme.headline6,
                      ),
                      _categorySelector(context),
                    ],
                  ),
                ),
                _movesStream(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categorySelector(BuildContext context) {
    var provider = PokedexProvider.of(context);
    return DropdownButton<String>(
      value: categorySelected,
      icon: Icon(Icons.arrow_downward),
      underline: Container(height: 1, color: Colors.white),
      onChanged: (String value) => setState(() {
        categorySelected = value;
        provider.movesBloc.movesClearList();
        provider.fetchAllCategoryMoves(value.toLowerCase());
      }),
      items: categorys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _movesStream(BuildContext context) {
    var provider = PokedexProvider.of(context);

    return StreamBuilder(
      stream: provider.movesBloc.movesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _movesTable(context, snapshot.data);
        }

        return Center(heightFactor: 3, child: CustomLoader());
      },
    );
  }

  Widget _movesTable(BuildContext context, List<Move> moves) {
    return DataTable(
      sortColumnIndex: columnIndex,
      sortAscending: isAscSort,
      columnSpacing: 5,
      dataRowHeight: 30,
      columns: [
        DataColumn(
          label: Text("Move"),
          onSort: _onSortTable,
        ),
        DataColumn(
          label: Text("Type"),
          numeric: true,
          onSort: _onSortTable,
        ),
        DataColumn(
          label: Text("PWR"),
          numeric: true,
          onSort: _onSortTable,
        ),
        DataColumn(
          label: Text("ENG"),
          numeric: true,
          onSort: _onSortTable,
        ),
        DataColumn(
          label: Text("CD"),
          numeric: true,
          onSort: _onSortTable,
        ),
        DataColumn(
          label: Text("DPS"),
          numeric: true,
          onSort: _onSortTable,
        ),
        DataColumn(
          label: Text("EPS"),
          numeric: true,
          onSort: _onSortTable,
        ),
      ],
      rows: _sortedPokemonMoves(moves),
    );
  }

  void _onSortTable(int indexColumn, bool asc) => setState(() {
        columnIndex = indexColumn;
        isAscSort = asc;
      });

  List<DataRow> _sortedPokemonMoves(List<Move> moves) {
    moves.sort((Move a, Move b) {
      Comparable comparable;
      Move x, y;

      if (isAscSort) {
        x = a;
        y = b;
      } else {
        x = b;
        y = a;
      }

      switch (columnIndex) {
        case 0:
          comparable = x.name.compareTo(y.name);
          break;
        case 1:
          comparable = x.type.compareTo(y.type);
          break;
        case 2:
          comparable = x.power.compareTo(y.power);
          break;
        case 3:
          comparable = x.energy.compareTo(y.energy);
          break;
        case 4:
          comparable = x.duration.compareTo(y.duration);
          break;
        case 5:
          comparable = x.dps.compareTo(y.dps);
          break;
        case 6:
          comparable = x.eps.compareTo(y.eps);
          break;
      }

      return comparable;
    });

    return moves.map<DataRow>(_pokemonMoveRow).toList();
  }

  DataRow _pokemonMoveRow(Move move) {
    return DataRow(cells: [
      DataCell(Text(move.name)),
      DataCell(Image.asset(
        Pokemon.badgeType(move.type),
        scale: 1.8,
      )),
      DataCell(Text("${move.power}")),
      DataCell(Text("${move.energy}")),
      DataCell(Text("${move.duration / 1000}")),
      DataCell(Text("${move.dps.toStringAsFixed(2)}")),
      DataCell(Text("${move.eps.toStringAsFixed(2)}")),
    ]);
  }
}
