import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokedexPage extends StatelessWidget {
  final GlobalRequest globalRequest = GlobalRequest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: globalRequest.getPokedexGeneration(4),
          builder:
              (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
            Widget builder;
            if (snapshot.hasData) {
              builder = this._pokedex(context, snapshot.data);
            } else if (snapshot.hasError) {
              builder = Text("Error conexion");
            } else {
              builder = CircularProgressIndicator();
            }

            return builder;
          },
        ),
      ),
    );
  }

  Widget _pokedex(BuildContext context, List<Pokemon> pokedex) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid.extent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.35,
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
                  color: Colors.blue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: PokemonImage(Pokemon.getURLImage(pokemon.id)),
              ),
            );
          }),
        ),
      ],
    );
  }
}
