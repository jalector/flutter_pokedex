import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../Bloc/Pokedex_bloc.dart';
import '../Provider/PokedexProvider.dart';
import '../Widget/CustomLoader.dart';
import '../Widget/PokemonImage.dart';

class HeightSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          this.query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than one letters.",
            ),
          )
        ],
      );
    }

    PokedexProvider provider = PokedexProvider.of(context);
    provider.searchPokemon(query);

    return StreamBuilder<List<Pokemon>>(
      stream: provider.bloc.pokedexStream,
      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
        ThemeData theme = Theme.of(context);
        Size size = MediaQuery.of(context).size;

        if (snapshot.hasData) {
          return gridPokemonSeach(context, snapshot.data);
        } else if (snapshot.hasError) {
          return Stack(
            children: <Widget>[
              Center(
                child: Image(
                  image: AssetImage("assets/unown.png"),
                  color: theme.accentColor.withOpacity(0.3),
                  width: size.width * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              Center(
                child: Text(
                  snapshot.error.toString(),
                  style: theme.textTheme.title,
                ),
              )
            ],
          );
        } else {
          return CustomLoader();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);

    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          left: 0,
          child: dragTargetPokemon(context),
        ),
        StreamBuilder<List<Pokemon>>(
          stream: provider.bloc.pokedexStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
            ThemeData theme = Theme.of(context);

            if (snapshot.hasData) {
              return gridPokemonSeach(context, snapshot.data);
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      snapshot.error,
                      style: theme.textTheme.title,
                    ),
                  )
                ],
              );
            } else {
              return CustomLoader();
            }
          },
        ),
      ],
    );
  }

  Widget gridPokemonSeach(BuildContext context, List<Pokemon> data) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        dragTargetSliver(context),
        pokemonSliver(context, data),
      ],
    );
  }

  Widget dragTargetSliver(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 100,
        maxHeight: 210,
        child: dragTargetPokemon(context),
      ),
    );
  }

  Widget dragTargetPokemon(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);
    ThemeData theme = Theme.of(context);
    PokedexBloc bloc = provider.bloc;

    return StreamBuilder<List<Pokemon>>(
      stream: bloc.pokemonHeightStream,
      builder: (context, snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          widget = Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: theme.primaryColorDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DragTarget<Pokemon>(
              onWillAccept: (poke) =>
                  bloc.pokemonHeigh.where((p) => p == poke).length == 0,
              onAccept: (Pokemon pokemon) {
                provider.addPokemonHeight(pokemon, bloc.pokemonHeigh.length);
              },
              builder: (BuildContext context, acepted, denied) {
                var elements = <Widget>[];

                elements
                  ..addAll(
                    pokemonDragged(context, acepted, type: DragType.acepted),
                  )
                  ..addAll(
                    pokemonDragged(context, denied, type: DragType.denied),
                  )
                  ..addAll(
                    pokemonDragged(context, bloc.pokemonHeigh, type: null),
                  );

                return Wrap(children: elements);
              },
            ),
          );
        } else if (snapshot.hasError) {
          widget = Center(
            child: Text(snapshot.error),
          );
        } else {
          widget = Center(child: CircularProgressIndicator());
        }

        return widget;
      },
    );
  }

  pokemonDragged(BuildContext context, List<dynamic> pokemon, {DragType type}) {
    PokedexProvider provider = PokedexProvider.of(context);
    PokedexBloc bloc = provider.bloc;
    ThemeData theme = Theme.of(context);

    return pokemon.map<Widget>((dynamic poke) {
      var container = Container(
        width: 70,
        height: 70,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: type == null ? theme.accentColor.withOpacity(0.3) : null,
          border: (type == DragType.denied)
              ? Border.all(
                  color: theme.errorColor,
                )
              : null,
        ),
        child: InkWell(
          onTap: () {
            bloc.removePokemonHeight(poke);
          },
          child: Column(
            children: <Widget>[
              PokemonImage(poke.image),
            ],
          ),
        ),
      );

      return container;
    }).toList();
  }

  Widget pokemonSliver(BuildContext context, List<Pokemon> pokemon) {
    ThemeData theme = Theme.of(context);
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Pokemon poke = pokemon[index];
          return pokemonCard(context, theme, poke);
        },
        childCount: pokemon.length,
      ),
    );
  }

  Widget pokemonCard(BuildContext context, ThemeData theme, Pokemon pokemon) {
    Size size = MediaQuery.of(context).size;
    double cardSize = size.width * 0.3;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        child: InkWell(
          onTap: null,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.primaryColorDark,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Text(
                    pokemon.name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.title,
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.04,
                right: -5,
                child: LongPressDraggable<Pokemon>(
                  data: pokemon,
                  childWhenDragging: Container(
                    width: cardSize,
                    constraints: BoxConstraints(maxWidth: 120),
                    child: PokemonImage(
                      pokemon.image,
                      obscureColor: theme.colorScheme.primaryVariant,
                    ),
                  ),
                  feedback: SizedBox(
                    height: 120,
                    width: 120,
                    child: Opacity(
                      opacity: 0.8,
                      child: PokemonImage(pokemon.image),
                    ),
                  ),
                  child: Container(
                    width: cardSize,
                    constraints: BoxConstraints(maxWidth: 120),
                    child: PokemonImage(pokemon.image),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

  @override
  String toString() => '_SliverAppBarDelegate';
}

enum DragType {
  acepted,
  denied,
}
