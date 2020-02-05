import 'package:flutter/material.dart';

import '../../Model/HttpAnswer.dart';
import '../../Widget/CustomLoader.dart';
import '../../Model/Pokemon_model.dart';
import '../../Provider/PokedexProvider.dart';

class PokemonCounterPage extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCounterPage(this.pokemon);

  @override
  Widget build(BuildContext context) {
    var provider = PokedexProvider.of(context);
    return FutureBuilder<HttpAnswer<List<Pokemon>>>(
      future: provider.getPokemonCounters(pokemon.id),
      builder: (BuildContext context,
          AsyncSnapshot<HttpAnswer<List<Pokemon>>> snapshot) {
        Widget widget = CustomLoader();

        if (snapshot.hasData) {
          var pokes = snapshot.data.object;
          widget = ListView.builder(
            itemCount: pokes.length,
            itemBuilder: (BuildContext context, int index) {
              var poke = pokes[index];
              return ListTile(
                leading: Image.network(
                  "https://img.pokemondb.net/sprites/black-white/anim/normal/${poke.name.toLowerCase()}.gif",
                ),
                trailing: Image.network(
                  "https://img.pokemondb.net/sprites/sun-moon/icon/${poke.name.toLowerCase()}.png",
                ),
                title: Text(poke.name),
              );
            },
          );
        } else if (snapshot.hasError) {
          widget = Text(snapshot.error.toString());
        }

        return widget;
      },
    );
  }
}
