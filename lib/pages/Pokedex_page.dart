import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/HttpAnswer.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokedexPage extends StatefulWidget {
  @override
  _PokedexPageState createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final GlobalRequest globalRequest = GlobalRequest();

  final GlobalRequest globalRequest2 = GlobalRequest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<HttpAnswer<List<Pokemon>>>(
          future: globalRequest.getPokedexGeneration(4),
          builder: (BuildContext context,
              AsyncSnapshot<HttpAnswer<List<Pokemon>>> snapshot) {
            Widget builder;
            if (snapshot.hasData) {
              builder = this._pokedex(context, snapshot.data.object);
            } else if (snapshot.hasError) {
              builder = Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(35),
                      decoration: BoxDecoration(
                        color: Theme.of(context).errorColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  )
                ],
              );
            } else {
              builder = CustomLoader();
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
        SliverAppBar(
          floating: true,
          pinned: false,
          title: Text(
            "Pokedex",
            style: Theme.of(context).textTheme.display4,
          ),
        ),
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
                  color: Theme.of(context).accentColor,
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
