import 'package:Pokedex/Model/Move.dart';
import 'package:flutter/material.dart';

import '../../Provider/PokedexProvider.dart';

import '../../Util.dart';

class PokemonCounterPage extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCounterPage(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        _counterGrid(context, pokemon.counters),
      ],
    );
  }

  Widget _counterGrid(BuildContext context, List<Pokemon> pokemon) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    var count = 1;
    if (pokemon != null && pokemon.length > 0) {
      return SliverPadding(
        padding: EdgeInsets.all(8),
        sliver: SliverGrid.extent(
          maxCrossAxisExtent: Util.calculateCardWidth(size),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: pokemon
              .map<Widget>(
                (Pokemon pokemon) => _counter(context, pokemon, count++),
              )
              .toList(),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      color: theme.errorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "No pokemon counter available",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline6,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _counter(BuildContext context, Pokemon pokemon, int count) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColorDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: <Widget>[
          Text(
            "$count",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 60,
              fontWeight: FontWeight.w900,
            ),
          ),
          Positioned.fill(
            child: FadeInImage(
              image: NetworkImage(pokemon.image),
              placeholder: AssetImage("assets/load_pokeball.gif"),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            left: 5,
            child: Row(
              children: <Widget>[
                _counterMove(context, pokemon.chargedCounterMove, true),
                _counterMove(context, pokemon.fastCounterMove, false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _counterMove(BuildContext context, Move move, bool isOnLeftSide) {
    var theme = Theme.of(context);
    var colorEmphasis = Pokemon.chooseByPokemonType(move.type);

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: isOnLeftSide ? 0 : 5,
          right: isOnLeftSide ? 5 : 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(isOnLeftSide ? 0 : 10),
            left: Radius.circular(isOnLeftSide ? 10 : 0),
          ),
          border: Border.all(color: colorEmphasis),
          color: colorEmphasis.withOpacity(0.5),
        ),
        child: Text(
          move.name,
          overflow: TextOverflow.ellipsis,
          textAlign: (isOnLeftSide) ? TextAlign.end : TextAlign.start,
          style: theme.textTheme.caption.copyWith(fontSize: 12),
        ),
      ),
    );
  }
}
