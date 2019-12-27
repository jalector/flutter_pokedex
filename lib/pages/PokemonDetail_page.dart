import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Sprite_model.dart';

import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Util.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';
import 'package:flutter_pokedex/Widget/PokemonVideo.dart';

import "dart:io" show Platform;

class PokemonDetailPage extends StatefulWidget {
  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  VideoPlayerController _videoCtrl;

  @override
  void dispose() {
    this._videoCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pokemon pokemon = ModalRoute.of(context).settings.arguments;
    PokedexProvider provider = PokedexProvider.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${pokemon.name}",
              style: Theme.of(context).textTheme.title,
            ),
            Spacer(),
            Text("#${pokemon.id}", style: Theme.of(context).textTheme.title),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: FutureBuilder<HttpAnswer<Pokemon>>(
            future: provider.getPokemon(pokemon),
            builder: (BuildContext context,
                AsyncSnapshot<HttpAnswer<Pokemon>> snapshot) {
              if (snapshot.hasData) {
                return _pokemonDetail(context, snapshot.data.object);
              } else if (snapshot.hasError) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.error.toString()),
                    )
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomLoader(),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _container({
    BuildContext context,
    List<Widget> children,
    String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: children,
            ),
          ),
        )
      ],
    );
  }

  Widget _pokemonDetail(BuildContext context, Pokemon pokemon) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return this._pokemonDetailLandscape(context, pokemon);
        } else {
          return this._pokemonDetailPortrait(context, pokemon);
        }
      },
    );
  }

  Widget _pokemonDetailPortrait(BuildContext context, Pokemon pokemon) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          this._generationBanner(context, pokemon),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(child: this._pokemonPreview(pokemon)),
              Flexible(child: this._description(pokemon)),
            ],
          ),
          this._pokemonTypeBanners(pokemon),
          this._adjacentPokemon(context, pokemon),
          this._stats(context, pokemon),
          this._statisticsChart(context, pokemon),
          this._family(context, pokemon),
          this._sprites(context, pokemon),
        ],
      ),
    );
  }

  Widget _pokemonDetailLandscape(BuildContext context, Pokemon pokemon) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(child: this._pokemonPreview(pokemon)),
            this._generationBanner(context, pokemon),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  this._pokemonTypeBanners(pokemon),
                  this._description(pokemon),
                  this._adjacentPokemon(context, pokemon),
                  this._stats(context, pokemon),
                  this._statisticsChart(context, pokemon),
                  this._family(context, pokemon),
                  this._sprites(context, pokemon),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _image(Pokemon pokemon) {
    String imageURL = Pokemon.getURLImage(pokemon.id, pokemon.form);

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            "pokemonImage",
            arguments: imageURL,
          );
        },
        child: Hero(
          tag: "image",
          child: PokemonImage(imageURL),
        ),
      ),
    );
  }

  Widget _video(Pokemon pokemon) {
    if (this._videoCtrl == null) {
      this._videoCtrl = VideoPlayerController.network(
        Pokemon.getURLVideo(pokemon.name, pokemon.form),
      );

      return FutureBuilder(
        future: _videoCtrl.initialize(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return this._createVideoUI(context);
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: CustomLoader(),
              ),
            );
          }
        },
      );
    } else {
      return this._createVideoUI(context);
    }
  }

  Widget _createVideoUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "pokemonVideo", arguments: _videoCtrl);
        },
        child: PokemonVideo(this._videoCtrl),
      ),
    );
  }

  Widget _generationBanner(BuildContext context, Pokemon pokemon) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: size.width * 0.05),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Generation #${pokemon.generation}",
        style: Theme.of(context).textTheme.title,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _description(Pokemon pokemon) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            pokemon.description,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _pokemonTypeBanners(Pokemon pokemon) {
    return Row(
      children: <Widget>[
        this._pokemonType(pokemon.type1),
        (pokemon.type2 != null && pokemon.type2.isNotEmpty)
            ? this._pokemonType(pokemon.type2)
            : Container(),
      ],
    );
  }

  Widget _pokemonType(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Pokemon.chooseByPokemonType(type),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(Util.capitalize(type)),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Image.network(Pokemon.getUrlBadgetype(type)),
            ),
            radius: 10,
          ),
        ],
      ),
    );
  }

  Widget _adjacentPokemon(BuildContext context, Pokemon pokemon) {
    PokedexProvider provider = PokedexProvider.of(context);

    return Row(
      children: <Widget>[
        (pokemon.id - 1 > 0)
            ? _adjacent(provider, pokemon.id - 1, true)
            : Expanded(child: Container()),
        (pokemon.id < 808)
            ? _adjacent(provider, pokemon.id + 1, false)
            : Expanded(child: Container()),
      ],
    );
  }

  Widget _adjacent(PokedexProvider provider, int number, bool borderLeft) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          HttpAnswer<Pokemon> poke =
              await provider.getPokemonMinimalInfo(number);
          Navigator.pushReplacementNamed(context, "pokemonDetail",
              arguments: poke.object);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular((borderLeft) ? 15 : 0),
              right: Radius.circular((borderLeft) ? 0 : 15),
            ),
          ),
          child: Text("#$number", textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _statisticsChart(BuildContext context, Pokemon pokemon) {
    return this._container(
      context: context,
      title: "${pokemon.name} in chart",
      children: this._orderPokemonChart(pokemon),
    );
  }

  List<Widget> _orderPokemonChart(Pokemon pokemon) {
    List<Widget> list = <Widget>[];
    List<TypeChart> weaknesses = [];
    List<TypeChart> resistances = [];

    pokemon.typeChart.forEach((TypeChart type) {
      if (type.status == Status.ADV) {
        resistances.add(type);
      } else if (type.status == Status.DIS) {
        weaknesses.add(type);
      }
    });
    list.add(
      RotatedBox(
        quarterTurns: -1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Weakness",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
    list.addAll(weaknesses.map((w) => this._typeInfoChart(w)).toList());
    list.add(
      RotatedBox(
        quarterTurns: -1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Resistances",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
    list.addAll(resistances.map((w) => this._typeInfoChart(w)).toList());

    return list;
  }

  Widget _typeInfoChart(TypeChart type) {
    double effect = type.effectiveness * 100;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Pokemon.chooseByPokemonType(type.type).withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: <Widget>[
          Image(
            image: NetworkImage(
              Pokemon.getUrlBadgetype(type.type),
            ),
            fit: BoxFit.contain,
          ),
          SizedBox(height: 5),
          Text(effect.toStringAsPrecision(4) + "%"),
          Text("damage"),
        ],
      ),
    );
  }

  Widget _pokemonPreview(Pokemon pokemon) {
    return (pokemon.generation >= 5 || pokemon.form == "Alola")
        ? this._image(pokemon)
        : (Platform.isAndroid || Platform.isIOS)
            ? this._video(pokemon)
            : this._image(pokemon);
  }

  Widget _family(BuildContext context, Pokemon pokemon) {
    if (pokemon.family.length == 0) {
      return _noInfoMessage(
        Text("No family tree available"),
      );
    }

    return this._container(
      context: context,
      title: "Family",
      children: List.generate(
        pokemon.family.length,
        (int i) => this._pokemonEvolution(
          context,
          pokemon.family[i],
        ),
      ),
    );
  }

  Widget _pokemonEvolution(BuildContext context, Pokemon pokemon) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              right: 0,
              width: 50,
              child: Opacity(
                opacity: 0.5,
                child: Image.network(
                  Pokemon.getUrlBadgetype(pokemon.type1),
                ),
              ),
            ),
            Text(
              "#${pokemon.id}",
              style: Theme.of(context).textTheme.title,
            ),
            Material(
              color: Colors.white10,
              child: InkWell(
                splashColor: Colors.white12,
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    "pokemonDetail",
                    arguments: pokemon,
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: PokemonImage(
                    Pokemon.getURLImage(pokemon.id, pokemon.form),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats(BuildContext context, Pokemon pokemon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          this._stat("Max CP", pokemon.maxcp.toString()),
          this._stat("Attack", pokemon.atk.toString()),
          this._stat("Defence", pokemon.def.toString()),
          this._stat("Stamina", pokemon.sta.toString()),
        ],
      ),
    );
  }

  Widget _stat(String concept, String info) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: <Widget>[
            Text(
              concept,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 20),
            ),
            Text(info),
          ],
        ),
      ),
    );
  }

  Widget _sprites(BuildContext context, Pokemon pokemon) {
    if (pokemon.sprites.length == 0) {
      return _noInfoMessage(
        Text("No sprites available"),
      );
    }

    List<Widget> imageSprite = [];

    pokemon.sprites.forEach((PokemonSprite pokemonSprite) {
      imageSprite.add(
        RotatedBox(
          quarterTurns: -1,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              pokemonSprite.form,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

      pokemonSprite.sprites.forEach((Sprite sprite) {
        imageSprite.add(this._spriteUI(sprite));
      });
    });

    return this._container(
      context: context,
      title: "Sprites",
      children: imageSprite,
    );
  }

  Widget _spriteUI(Sprite sprite) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white24,
      ),
      width: MediaQuery.of(context).size.width * 0.25,
      child: Stack(
        children: <Widget>[
          (sprite.shiny)
              ? Image.asset(
                  'assets/sparkles.gif',
                  fit: BoxFit.cover,
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
          PokemonImage(
              "${GlobalRequest.sprites}${(sprite.form != "Pixel" ? "normal" : "pixels")}/${sprite.sprite}"),
        ],
      ),
    );
  }

  Widget _noInfoMessage(Text text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: text,
      ),
    );
  }
}
