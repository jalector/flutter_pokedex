import 'package:flutter/material.dart';

import '../Provider/PokedexProvider.dart';
import '../Widget/CustomLoader.dart';
import '../Widget/PokemonImage.dart';

class PrincipalSearchDelegate extends SearchDelegate {
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
        PokedexProvider.of(context).bloc.clearPokedex();
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
              "Search term must be longer than three letters.",
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
              Positioned.fill(
                child: Image(
                  image: AssetImage("assets/unown.png"),
                  color: theme.accentColor.withOpacity(0.3),
                  width: size.width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Text(
                  snapshot.error,
                  style: theme.textTheme.title,
                ),
              ),
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

    return StreamBuilder<List<Pokemon>>(
      stream: provider.bloc.pokedexStream,
      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
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
    );
  }

  Widget gridPokemonSeach(BuildContext context, List<Pokemon> data) {
    ThemeData theme = Theme.of(context);
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 100,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Result: ${data.length} pokemon"),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Pokemon pokemon = data[index];
              return pokemonCard(context, theme, pokemon);
            },
            childCount: data.length,
          ),
        ),
      ],
    );
  }

  Widget pokemonCard(BuildContext context, ThemeData theme, Pokemon pokemon) {
    Size size = MediaQuery.of(context).size;
    double cardSize = size.width * 0.3;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed("pokemonDetail", arguments: pokemon),
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
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pokemon.name,
                            style: theme.textTheme.title,
                          ),
                          Row(
                            children: <Widget>[
                              _pokemonType(pokemon.type1),
                              SizedBox(width: 15),
                              _pokemonType(pokemon.type2),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.05,
                right: -5,
                child: Container(
                  width: cardSize,
                  constraints: BoxConstraints(maxWidth: 170),
                  child: PokemonImage(pokemon.image),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pokemonType(String type) {
    if (type == null) return Container();

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white24,
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Image.asset("assets/badges_type/$type.png"),
          ),
          radius: 12,
        ),
        SizedBox(width: 5),
        Text(type),
      ],
    );
  }
}
