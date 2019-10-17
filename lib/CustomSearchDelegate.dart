import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

import 'Model/Pokemon_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return theme.copyWith(
      primaryColor: theme.accentColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.dark,
      primaryTextTheme: ThemeData.light().textTheme,
    );
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
        PokedexProvider.of(context).bloc.addPokedex(null);
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
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
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length + 1,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text("Result: ${snapshot.data.length} pokemons"),
                  ),
                );
              } else {
                Pokemon pokemon = snapshot.data[index - 1];
                return pokemonCard(context, theme, pokemon);
              }
            },
          );
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
    //PokedexProvider.of(context).se
  }

  Widget pokemonCard(BuildContext context, ThemeData theme, Pokemon pokemon) {
    Size size = MediaQuery.of(context).size;
    double cardSize = size.width * 0.4;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          right: 10,
          left: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              child: Material(
                color: theme.accentColor,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed("pokemonDetail", arguments: pokemon);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: cardSize - 30),
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
              ),
            ),
          ),
        ),
        SizedBox(
          width: cardSize,
          child: PokemonImage(
            Pokemon.getURLImage(pokemon.id, pokemon.form),
          ),
        ),
      ],
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
