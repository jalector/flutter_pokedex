import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokemonFusion extends StatefulWidget {
  const PokemonFusion({Key key}) : super(key: key);

  @override
  _PokemonFusionState createState() => _PokemonFusionState();
}

class _PokemonFusionState extends State<PokemonFusion> {
  int _pokemonOne = 1;
  int _pokemonTwo = 1;

  @override
  void initState() {
    super.initState();
    this._pokemonOne = this._randomPokemon();
    this._pokemonTwo = this._randomPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          this._randomPokemonImage(context, this._pokemonOne, (int index) {
            setState(() => this._pokemonOne = index + 1);
          }),
          this._pokemonChild(context),
          this._randomPokemonImage(context, this._pokemonTwo, (int index) {
            setState(() => this._pokemonTwo = index + 1);
          }),
        ],
      ),
    );
  }

  int _randomPokemon() {
    return math.Random().nextInt(150) + 1;
  }

  Widget _randomPokemonImage(
      BuildContext context, int initialPage, Function pageChanged) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.4,
          maxHeight: size.width * 0.4,
        ),
        child: PageView.builder(
          itemCount: 151,
          controller: PageController(
            viewportFraction: 0.7,
            initialPage: initialPage - 1,
          ),
          pageSnapping: true,
          onPageChanged: pageChanged,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: PokemonImage(
                    "https://images.alexonsager.net/pokemon/${index + 1}.png",
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text("#${index + 1}"),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _pokemonChild(BuildContext context) {
    String image =
        "https://images.alexonsager.net/pokemon/fused/${this._pokemonOne}/${this._pokemonOne}.${this._pokemonTwo}.png";

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed("pokemonImage", arguments: image);
        },
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Hero(
            tag: "image",
            child: PokemonImage(image),
          ),
        ),
      ),
    );
  }
}
