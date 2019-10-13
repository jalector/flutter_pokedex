import 'package:flutter/material.dart';
import 'package:flutter_pokedex/CustomSearchDelegate.dart';
import 'package:flutter_pokedex/Widget/HomeDrawer.dart';
import 'package:flutter_pokedex/Widget/PageViewGeneration.dart';
import 'package:flutter_pokedex/Widget/PokemonFusion.dart';
import 'package:flutter_pokedex/Widget/RandomPokemonViewer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData style = Theme.of(context);

    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Pokedex",
          style: style.textTheme.display3,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                "Generations",
                style: style.textTheme.title,
              ),
              PageViewGeneration(),
              SizedBox(height: 20),
              Text(
                "Find new pokemons",
                style: style.textTheme.title,
              ),
              RandomPokemonViewer(),
              SizedBox(height: 20),
              Text(
                "Fusions",
                style: style.textTheme.title,
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
