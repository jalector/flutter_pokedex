import 'package:flutter/material.dart';
import 'package:flutter_pokedex/CustomSearchDelegate.dart';
import 'package:flutter_pokedex/Model/New_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/HomeDrawer.dart';
import 'package:flutter_pokedex/Widget/PageViewGeneration.dart';
import 'package:flutter_pokedex/Widget/PokemonFusion.dart';
import 'package:flutter_pokedex/Widget/PokemonNews.dart';
import 'package:flutter_pokedex/Widget/RandomPokemonViewer.dart';

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
          style: style.textTheme.title,
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
                "Region",
                style: style.textTheme.title,
              ),
              PageViewGeneration(),
              SizedBox(height: 20),
              Text(
                "Find new pokemons",
                style: style.textTheme.title,
              ),
              RandomPokemonViewer(provider),
              SizedBox(height: 20),
              Text(
                "Fusions",
                style: style.textTheme.title,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PokemonFusion(),
              ),
              FutureBuilder<HttpAnswer<List<New>>>(
                future: provider.getPokemonNews(),
                builder: (BuildContext context,
                    AsyncSnapshot<HttpAnswer<List<New>>> snapshot) {
                  print(snapshot.error);
                  if (snapshot.hasData) {
                    return PokemonNews(snapshot.data.object);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error);
                  } else {
                    return CustomLoader();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
