import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Widget/PageViewGeneration.dart';
import 'package:flutter_pokedex/Widget/PokemonFusion.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Pokedex",
                style: Theme.of(context).textTheme.display3,
              ),
              SizedBox(height: 20),
              Text(
                "Generations",
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.left,
              ),
              PageViewGeneration(),
              SizedBox(height: 20),
              Text(
                "Fusions",
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PokemonFusion(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
