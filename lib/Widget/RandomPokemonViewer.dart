import 'package:flutter/material.dart';

import '../Model/Pokemon_model.dart';
import '../Provider/PokedexProvider.dart';
import '../Widget/CustomLoader.dart';
import '../Widget/PokemonImage.dart';

class RandomPokemonViewer extends StatefulWidget {
  final PokedexProvider provider;
  RandomPokemonViewer(this.provider);

  @override
  _RandomPokemonViewerState createState() => _RandomPokemonViewerState();
}

class _RandomPokemonViewerState extends State<RandomPokemonViewer> {
  int selected = 0;
  PageController pageCtrl = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.5,
  );

  @override
  void initState() {
    this.widget.provider.loadRandomPokemons(10);

    pageCtrl.addListener(() {
      double maxPosition = pageCtrl.position.maxScrollExtent - 100;
      double position = pageCtrl.position.pixels;

      if (position > maxPosition && !this.widget.provider.bloc.loading) {
        this.widget.provider.loadRandomPokemons(10);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);
    return StreamBuilder<List<Pokemon>>(
      stream: provider.bloc.pokedexStream,
      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          List<Pokemon> pokemons = snapshot.data;

          return SizedBox(
            height: 220,
            child: Container(
              child: RotatedBox(
                quarterTurns: 1,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 200,
                  diameterRatio: 1.6,
                  magnification: 1.1,
                  offAxisFraction: 1.1,
                  perspective: 0.001,
                  squeeze: 1.09,
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: pokemons
                        .map(
                          (poke) => RotatedBox(
                            quarterTurns: -1,
                            child: SizedBox(
                              width: 250,
                              height: 250,
                              child: _pokemonCard(context, poke),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              child: Text(
                snapshot.error.toString(),
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red),
              ),
            ),
          );
        } else {
          return CustomLoader();
        }
      },
    );
  }

  Widget _pokemonCard(BuildContext context, Pokemon pokemon, {int index}) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage("assets/effect.gif"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: PokemonImage(pokemon.image),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              "${pokemon.name}",
              textAlign: TextAlign.center,
              style: theme.textTheme.title.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
