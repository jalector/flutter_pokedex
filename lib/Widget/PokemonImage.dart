import 'package:flutter/material.dart';

class PokemonImage extends StatelessWidget {
  final String image;
  PokemonImage(this.image);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      image: NetworkImage(image),
      placeholder: AssetImage("assets/load_pokeball.gif"),
    );
  }
}
