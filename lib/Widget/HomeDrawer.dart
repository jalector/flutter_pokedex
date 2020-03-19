import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Generation_model.dart';
import '../Model/Pokemon_model.dart';
import '../Provider/PokedexProvider.dart';
import '../Provider/ThemeChanger.dart';
import 'PokemonImage.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Container(
      width: size.width * 0.8,
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      color: theme.primaryColor,
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
                      right: 5,
                      bottom: 5,
                      top: 5,
                      child: PokemonImage(
                        Pokemon.randomPokemonImage(),
                        obscureColor: theme.primaryColor,
                        fullWidth: false,
                      ),
                    ),
                    Center(
                      widthFactor: 1.2,
                      child: Text(
                        "Pokedex",
                        style: theme.textTheme.display2,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Pokémon size",
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("pokemonHeight");
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Pokémon moves",
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("pokemonMoves");
                    },
                  ),
                ],
              ),
              this._bannerDivider(context, "Region"),
              this._generation(context, Generation(1, "Kanto")),
              this._generation(context, Generation(2, "Johto")),
              this._generation(context, Generation(3, "Hoenn")),
              this._generation(context, Generation(4, "Sinnoh")),
              this._generation(context, Generation(5, "Unova")),
              this._generation(context, Generation(6, "Kalos")),
              this._generation(context, Generation(7, "Alola")),
              this._bannerDivider(context, "Types"),
              this._types(context, size),
              this.changeTheme(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget changeTheme(BuildContext context) {
    return (Platform.isAndroid || Platform.isIOS)
        ? this.changeThemePersitence(context)
        : this.changeThemeWithoutPersitence(context);
  }

  Widget changeThemePersitence(BuildContext context) {
    return (Platform.isAndroid || Platform.isIOS)
        ? Column(
            children: <Widget>[
              this._bannerDivider(context, "Theme"),
              FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      SharedPreferences preferences = snapshot.data;
                      var provider = Provider.of<ThemeChanger>(context);
                      var themeNumber =
                          preferences.getInt(ThemeChanger.darkModeKey) ?? 0;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List<Widget>.generate(
                          ThemeChanger.totalNumberOfThemes,
                          (int index) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: RaisedButton(
                                  child: Text("${index + 1}"),
                                  onPressed: (themeNumber == index)
                                      ? null
                                      : () {
                                          provider.setTheme(index);
                                          preferences.setInt(
                                              ThemeChanger.darkModeKey, index);
                                        },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  }),
            ],
          )
        : Container();
  }

  Widget changeThemeWithoutPersitence(BuildContext context) {
    var provider = Provider.of<ThemeChanger>(context);

    return Column(
      children: <Widget>[
        this._bannerDivider(context, "Theme"),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            ThemeChanger.totalNumberOfThemes,
            (int index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: RaisedButton(
                    child: Text("${index + 1}"),
                    onPressed: () {
                      provider.setTheme(index);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
