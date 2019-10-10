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
        PokedexProvider.of(context).bloc.addPokedex([]);
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
            itemCount: snapshot.data.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Pokemon pokemon = snapshot.data[index];
              if (index == 0) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 45, bottom: 5),
                      child: Text("Result: ${snapshot.data.length} pokemons"),
                    ),
                    pokemonCard(theme, pokemon),
                  ],
                );
              }
              return pokemonCard(theme, pokemon);
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

  Widget pokemonCard(ThemeData theme, Pokemon pokemon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          child: Material(
            color: theme.accentColor,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: PokemonImage(
                        Pokemon.getURLImage(pokemon.id, pokemon.form),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          pokemon.name,
                          style: theme.textTheme.title,
                        ),
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Image.asset(
                                    "assets/badges_type/${pokemon.type1}.png"),
                              ),
                              radius: 12,
                            ),
                            SizedBox(width: 10),
                            Text(pokemon.type1),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
