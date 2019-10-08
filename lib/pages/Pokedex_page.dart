import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Generation_model.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokedexPage extends StatefulWidget {
  @override
  _PokedexPageState createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final GlobalRequest globalRequest = GlobalRequest();

  @override
  Widget build(BuildContext context) {
    Generation generation = ModalRoute.of(context).settings.arguments;
    PokedexProvider provider = PokedexProvider.of(context);

    provider.getPokedexGeneration(generation.number);

    return WillPopScope(
      onWillPop: () async {
        provider.bloc.onChangeSearchedPokemon(null);
        provider.bloc.addPokedex(null);

        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder<List<Pokemon>>(
            stream: provider.bloc.pokedexStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
              Widget builder;
              if (snapshot.hasData) {
                builder = this._pokedex(context, provider, snapshot.data);
              } else if (snapshot.hasError) {
                builder = Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(35),
                        decoration: BoxDecoration(
                          color: Theme.of(context).errorColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    )
                  ],
                );
              } else {
                builder = CustomLoader();
              }

              return builder;
            },
          ),
        ),
      ),
    );
  }

  Widget _pokedex(
      BuildContext context, PokedexProvider provider, List<Pokemon> pokedex) {
    Generation generation = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    double cardWidth;

    if (size.width > 1200) {
      cardWidth = size.width * 0.15;
    } else if (size.width >= 750) {
      cardWidth = size.width * 0.175;
    } else {
      cardWidth = size.width * 0.35;
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            title: this.searchField(provider),
            flexibleSpace: Text(
              "${generation.title}",
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.display4,
            ),
          ),
          SliverGrid.extent(
            maxCrossAxisExtent: cardWidth,
            children: List.generate(pokedex.length, (int index) {
              Pokemon pokemon = pokedex[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "pokemonDetail",
                      arguments: pokemon);
                },
                splashColor: Colors.blueAccent,
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("#${pokemon.id}"),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: Opacity(
                          opacity: 0.1,
                          child: Text(
                            pokemon.name,
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                      ),
                      PokemonImage(
                          Pokemon.getURLImage(pokemon.id, pokemon.form)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget searchField(PokedexProvider provider) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Search your pokemon",
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      onChanged: provider.bloc.onChangeSearchedPokemon,
      
    );
  }
}
