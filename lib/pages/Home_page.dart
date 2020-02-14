import 'package:flutter/material.dart';
import '../Delegate/PrincipalSearchDelegate.dart';
import '../Provider/PokedexProvider.dart';
import '../Widget/HomeDrawer.dart';
import '../Widget/PageViewGeneration.dart';
import '../Widget/PokemonFusion.dart';
import '../Widget/RandomPokemonViewer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData style = Theme.of(context);
    PokedexProvider provider = PokedexProvider.of(context);

    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: Text(
          "Pokedex",
          style: style.textTheme.headline6,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PrincipalSearchDelegate(),
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
                "Region",
                style: style.textTheme.headline6,
              ),
              PageViewGeneration(),
              SizedBox(height: 20),
              Text(
                "Find new pokemon",
                style: style.textTheme.headline6,
              ),
              RandomPokemonViewer(provider),
              SizedBox(height: 20),
              Text(
                "Fusions",
                style: style.textTheme.headline6,
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
