import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Model/Sprite_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokemonSpritePage extends StatelessWidget {
  const PokemonSpritePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pokemon pokemon = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(),
      body: _sprites(context, pokemon),
    );
  }

  Widget _sprites(BuildContext context, Pokemon pokemon) {
    List<Widget> imageSprite = [];

    pokemon.sprites.forEach((PokemonSprite pokemonSprite) {
      pokemonSprite.sprites.forEach((Sprite sprite) {
        imageSprite.add(this._spriteUI(context, sprite));
      });
    });

    return PageView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: PageController(viewportFraction: 0.7),
      pageSnapping: false,
      children: imageSprite,
    );
  }

  Widget _spriteUI(BuildContext context, Sprite sprite) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.05,
      ),
      height: size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white24,
      ),
      child: Stack(
        children: <Widget>[
          (sprite.shiny)
              ? Center(
                  child: Image.asset(
                    'assets/sparkles.gif',
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              sprite.gender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white38,
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: PokemonImage(
                  "${GlobalRequest.sprites}${(sprite.form != "Pixel" ? "normal" : "pixels")}/${sprite.sprite}"),
            ),
          ),
        ],
      ),
    );
  }
}
