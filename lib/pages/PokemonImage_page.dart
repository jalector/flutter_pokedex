import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokemonImagePage extends StatelessWidget {
  const PokemonImagePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String image = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Hero(
            tag: "image",
            child: PokemonImage(image),
          ),
        ),
      ),
    );
  }
}
