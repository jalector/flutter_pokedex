import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Generation_model.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData style = Theme.of(context);

    return Container(
      width: size.width * 0.8,
      color: style.accentColor,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: size.width,
                height: size.height * 0.25,
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      child: Image.network(
                        Pokemon.getURLImage(Random().nextInt(800) + 1, null),
                        color: style.primaryColor,
                      ),
                    ),
                    Center(
                      widthFactor: 1.2,
                      child: Text("Pokedex", style: style.textTheme.display4),
                    ),
                  ],
                ),
              ),
              this._bannerDivider(context, "Generations"),
              this._generation(context, Generation(1, "Kanto")),
              this._generation(context, Generation(2, "Johto")),
              this._generation(context, Generation(3, "Hoenn")),
              this._generation(context, Generation(4, "Sinnoh")),
              this._generation(context, Generation(5, "Unova")),
              this._generation(context, Generation(6, "Kalos")),
              this._generation(context, Generation(7, "Alola")),
              this._bannerDivider(context, "Types"),
              Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  children: <Widget>[
                    this._type(context, "Bug"),
                    this._type(context, "Dragon"),
                    this._type(context, "Fairy"),
                    this._type(context, "Fire"),
                    this._type(context, "Ghost"),
                    this._type(context, "Ground"),
                    this._type(context, "Normal"),
                    this._type(context, "Psychic"),
                    this._type(context, "Steel"),
                    this._type(context, "Dark"),
                    this._type(context, "Electric"),
                    this._type(context, "Fighting"),
                    this._type(context, "Flying"),
                    this._type(context, "Grass"),
                    this._type(context, "Ice"),
                    this._type(context, "Poison"),
                    this._type(context, "Rock"),
                    this._type(context, "Water"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerDivider(BuildContext context, String title) {
    Size size = MediaQuery.of(context).size;
    ThemeData style = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.black45,
      ),
      child: Text(
        title,
        style: style.textTheme.title,
      ),
    );
  }

  Widget _generation(BuildContext context, Generation generation) {
    Size size = MediaQuery.of(context).size;
    ThemeData style = Theme.of(context);

    return InkWell(
      onTap: () {
        PokedexProvider.of(context).getPokedexGeneration(generation.number);
        Navigator.pushNamed(context, "pokedex", arguments: generation.title);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        margin: EdgeInsets.symmetric(vertical: 3),
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gen/gen_${generation.number}.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.red, BlendMode.darken),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          generation.title,
          style: style.textTheme.title,
        ),
      ),
    );
  }

  Widget _type(BuildContext context, String type) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        PokedexProvider.of(context).getPokedexByType(type);
        Navigator.pushNamed(context, "pokedex", arguments: type);
      },
      child: Container(
        width: size.width * 0.35,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Padding(
                padding: EdgeInsets.all(3),
                child:
                    Image.asset("assets/badges_type/${type.toLowerCase()}.png"),
              ),
              radius: 18,
            ),
            SizedBox(width: 10),
            Text(type),
          ],
        ),
      ),
    );
  }
}
