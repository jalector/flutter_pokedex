import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
                "Pokedex",
                style: Theme.of(context).textTheme.display3,
              ),
              this._generationPokemon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generationPokemon() {
    return Column(
      children: [
        this._generation(1),
        this._generation(2),
        this._generation(3),
        this._generation(4),
      ],
    );
  }

  Widget _generation(int number) {
    return Container(
      child: Text("Generaion #$number"),
    );
  }
}
