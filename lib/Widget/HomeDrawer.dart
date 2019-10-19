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
    ThemeData theme = Theme.of(context);

    return Container(
      width: size.width * 0.8,
      constraints: BoxConstraints(
        maxWidth: 650,
      ),
      color: theme.primaryColorDark,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: SafeArea(
        bottom: false,
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
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      child: Image.network(
                        Pokemon.getURLImage(Random().nextInt(800) + 1, null),
                        color: theme.primaryColor,
                      ),
                    ),
                    Center(
                      widthFactor: 1.2,
                      child: Text(
                        "Pokedex",
                        style: theme.textTheme.display3,
                      ),
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
              this._types(context, size),
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
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        PokedexProvider.of(context)
            .getPokedexGeneration(generation.number, cleanPokedex: true);
        Navigator.pushNamed(context, "pokedex", arguments: generation.title);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        margin: EdgeInsets.symmetric(vertical: 3),
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gen/gen_${generation.number}.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.red,
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          generation.title,
          style: theme.textTheme.title.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _types(BuildContext context, Size size) {
    return Table(
      children: [
        TableRow(children: [
          this._type(context, "Bug"),
          this._type(context, "Dragon"),
          this._type(context, "Fairy"),
          this._type(context, "Poison"),
        ]),
        TableRow(children: [
          this._type(context, "Fire"),
          this._type(context, "Ghost"),
          this._type(context, "Ground"),
          this._type(context, "Rock"),
        ]),
        TableRow(children: [
          this._type(context, "Normal"),
          this._type(context, "Psychic"),
          this._type(context, "Steel"),
          this._type(context, "Water"),
        ]),
        TableRow(children: [
          this._type(context, "Dark"),
          this._type(context, "Electric"),
          this._type(context, "Fighting"),
          this._type(context, "Flying"),
        ]),
        TableRow(children: [
          this._type(context, "Grass"),
          this._type(context, "Ice"),
          Container(),
          Container(),
        ]),
      ],
    );
  }

  Widget _type(BuildContext context, String type) {
    return InkWell(
      onTap: () {
        PokedexProvider.of(context).getPokedexByType(type, cleanPokedex: true);
        Navigator.pushNamed(context, "pokedex", arguments: type);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
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
            SizedBox(height: 10),
            Text(type),
          ],
        ),
      ),
    );
  }
}
