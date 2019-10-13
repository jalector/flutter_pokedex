import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class RandomPokemonViewer extends StatefulWidget {
  @override
  _RandomPokemonViewerState createState() => _RandomPokemonViewerState();
}

class _RandomPokemonViewerState extends State<RandomPokemonViewer> {
  final List<int> pokemons =
      List.generate(40, (int i) => Random().nextInt(300) + 1);

  final GlobalRequest _globalRequest = GlobalRequest();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      width: size.width,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return this._pokemonCard(context, index);
        },
        itemCount: pokemons.length,
        viewportFraction: 0.5,
        scale: 0.8,
      ),
    );
  }

  Widget _pokemonCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: (this._loading)
          ? null
          : () async {
              _loading = true;

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Obteniendo información"),
                  backgroundColor: Colors.white,
                  duration: Duration(seconds: 1),
                ),
              );
              HttpAnswer<Pokemon> answer = await this
                  ._globalRequest
                  .getPokemonByNumber(this.pokemons[index]);

              if (answer.ok) {
                Navigator.pushNamed(context, "pokemonDetail",
                    arguments: answer.object);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error while try to get pokemon info"),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              _loading = false;
            },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            PokemonImage(
              Pokemon.getURLImage(this.pokemons[index], null),
            ),
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("#${pokemons[index]}"),
            ),
          ],
        ),
      ),
    );
  }
}
