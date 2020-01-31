import 'package:flutter/material.dart';

import 'PokemonImage.dart';
import '../Model/Pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  /// Info
  final bool showBigNumber;
  final bool showBigName;
  final bool showTypes;

  /// Badges types
  final bool showBadgeNumber;
  final bool showBadgeName;
  final bool showBadgeType;

  //final bool useTypeColors;
  final bool tapToShowDetail;
  final bool useFullImage;

  const PokemonCard(
    this.pokemon, {
    this.showBigNumber = false,
    this.showBigName = true,
    this.showTypes = false,
    this.showBadgeNumber = false,
    this.showBadgeName = false,
    this.showBadgeType = false,
    //this.useTypeColors = false,
    this.tapToShowDetail = true,
    this.useFullImage = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    print("${pokemon.name}: ${pokemon.type1} ${pokemon?.type2 ?? "TRONÉ"}");
    Widget widget = Container(
      margin: EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          badgets(context),
          name(context),
          number(context),
          PokemonImage(
            Pokemon.getURLImage(
              pokemon.id,
              pokemon.form,
              full: useFullImage,
            ),
          ),
          Positioned(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(
                  Pokemon.getUrlBadgetype(pokemon.type1),
                  width: 15,
                ),
                SizedBox(height: 5),
                (pokemon.type2 != null)
                    ? Image.network(
                        Pokemon.getUrlBadgetype(pokemon.type2),
                        width: 15,
                      )
                    : Container(width: 10),
              ],
            ),
          ),
        ],
      ),
    );

    if (tapToShowDetail) {
      widget = Material(
        color: theme.primaryColor,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, "pokemonDetail", arguments: pokemon),
          child: widget,
        ),
      );
    }
    return ClipRRect(borderRadius: BorderRadius.circular(5), child: widget);
  }

  Widget name(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return (showBigName)
        ? Positioned(
            bottom: 0,
            left: 20,
            child: Opacity(
              opacity: 0.2,
              child: Text(
                pokemon.name,
                style: theme.textTheme.title,
              ),
            ),
          )
        : Container();
  }

  Widget badgets(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Widget> badgets = [];

    if (showBadgeNumber) {
      badgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          margin: EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            color: theme.primaryColorDark,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text("#${pokemon.id}", style: theme.textTheme.caption),
        ),
      );
    }

    if (showBadgeName) {
      badgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: theme.primaryColorDark,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text("#${pokemon.name}", style: theme.textTheme.caption),
        ),
      );
    }
    return (showBadgeName || showBadgeNumber)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 3),
            ],
          )
        : Container();
  }

  number(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return (showBigNumber)
        ? Opacity(
            opacity: 0.3,
            child: Text(
              "${pokemon.id}",
              style: theme.textTheme.caption.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
          )
        : Container();
  }
}
