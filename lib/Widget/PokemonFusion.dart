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
    this._pokemonOne = this._randomPokmeon();
    this._pokemonTwo = this._randomPokmeon();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          this._randomPokemonImage(
            context,
            randomPokemon: this._pokemonOne,
            callback: () {
              this._pokemonOne = this._randomPokmeon();
            },
          ),
          this._pokemonChild(),
          this._randomPokemonImage(
            context,
            randomPokemon: this._pokemonTwo,
            callback: () {
              this._pokemonTwo = this._randomPokmeon();
            },
          ),
        ],
      ),
    );
  }

  int _randomPokmeon() {
    return math.Random().nextInt(150) + 1;
  }

  Widget _randomPokemonImage(
    BuildContext context, {
    int randomPokemon,
    Function callback,
  }) {
    return Flexible(
      child: InkWell(
        onTap: () => setState(() => callback()),
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: <Widget>[
              PokemonImage(
                "https://images.alexonsager.net/pokemon/$randomPokemon.png",
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(randomPokemon.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pokemonChild() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: PokemonImage(
          "https://images.alexonsager.net/pokemon/fused/${this._pokemonOne}/${this._pokemonOne}.${this._pokemonTwo}.png",
        ),
      ),
    );
  }
}
