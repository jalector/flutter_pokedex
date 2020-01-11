import 'package:flutter/material.dart';

class PokemonImage extends StatelessWidget {
  final String image;
  PokemonImage(this.image);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      image: NetworkImage(image),
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      placeholder: AssetImage("assets/load_pokeball.gif"),
    );
  }
}
