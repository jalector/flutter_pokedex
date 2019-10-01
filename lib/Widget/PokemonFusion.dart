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
            addCallback: () {
              this._pokemonOne = (++this._pokemonOne) % 151;
              if (this._pokemonOne == 0) this._pokemonOne++;
            },
            minCallback: () {
              if (this._pokemonOne == 1) {
                this._pokemonOne = 151;
              } else {
                this._pokemonOne--;
              }
            },
          ),
          this._pokemonChild(context),
          this._randomPokemonImage(
            context,
            randomPokemon: this._pokemonTwo,
            callback: () {
              this._pokemonTwo = this._randomPokmeon();
            },
            addCallback: () {
              this._pokemonTwo = (++this._pokemonTwo) % 151;
              if (this._pokemonTwo == 0) this._pokemonTwo++;
            },
            minCallback: () {
              if (this._pokemonTwo == 1) {
                this._pokemonTwo = 151;
              } else {
                this._pokemonTwo--;
              }
            },
          ),
        ],
      ),
    );
  }

  int _randomPokmeon() {
    return math.Random().nextInt(150) + 1;
  }

  Widget _randomPokemonImage(BuildContext context,
      {int randomPokemon,
      Function callback,
      Function addCallback,
      Function minCallback}) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() => callback());
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          if (dragEndDetails.primaryVelocity > 0) {
            setState(() => minCallback());
          } else if (dragEndDetails.primaryVelocity < 0) {
            setState(() => addCallback());
          }
        },
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
