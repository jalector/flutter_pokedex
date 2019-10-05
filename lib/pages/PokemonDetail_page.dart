import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Util.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';
import 'package:flutter_pokedex/Widget/PokemonVideo.dart';
import 'package:video_player/video_player.dart';

class PokemonDetailPage extends StatefulWidget {
  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  VideoPlayerController _videoCtrl;
  GlobalRequest globalRequest = GlobalRequest();

  @override
  void dispose() {
    this._videoCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pokemon pokemon = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Pokemon.chooseByPokemonType(pokemon.type1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pokemon.chooseByPokemonType(pokemon.type1),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${pokemon.name}",
              style: Theme.of(context).textTheme.display3,
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
            future: globalRequest.getPokemon(pokemon.id),
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
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
          bottom: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
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
            this._roar(context, pokemon),
            this._statistics(context, pokemon),
            this._family(context, pokemon),
          ],
        ),
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
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  this._pokemonTypeBanners(pokemon),
                  this._description(pokemon),
                  this._adjacentPokemon(context, pokemon),
                  this._statistics(context, pokemon),
                  this._family(context, pokemon),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pokemonTypeBanners(Pokemon pokemon) {
    return Row(
      children: <Widget>[
        this._pokemonType(pokemon.type1),
        (pokemon.type2 != null)
            ? this._pokemonType(pokemon.type2)
            : Container(),
      ],
    );
  }

  Widget _statistics(BuildContext context, Pokemon pokemon) {
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
            "${pokemon.name} in chart",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: this._orderPokemonChart(pokemon),
            ),
          ),
        )
      ],
    );
  }

  Widget _typeInfoChart(TypeChart type) {
    double effect = type.effectiveness * 100;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Pokemon.chooseByPokemonType(type.type).withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: <Widget>[
          Image(
            image: NetworkImage(Pokemon.getUrlBadgetype(type.type)),
            fit: BoxFit.contain,
          ),
          SizedBox(height: 5),
          Text(effect.toStringAsPrecision(4) + "%"),
          Text("damage"),
        ],
      ),
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

  Widget _pokemonPreview(Pokemon pokemon) {
    return (pokemon.generation >= 5)
        ? this._image(pokemon)
        : this._video(pokemon);
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
    return Row(
      children: <Widget>[
        (pokemon.id - 1 > 0)
            ? _adjacent(pokemon.id - 1, true)
            : Expanded(child: Container()),
        (pokemon.id < 808)
            ? _adjacent(pokemon.id + 1, false)
            : Expanded(child: Container()),
      ],
    );
  }

  Widget _adjacent(int number, bool borderLeft) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          HttpAnswer<Pokemon> poke =
              await this.globalRequest.getPokemonMinimalInfo(number);
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

  Widget _generationBanner(BuildContext context, Pokemon pokemon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 70),
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

  Widget _family(BuildContext context, Pokemon pokemon) {
    if (pokemon.family.length == 0) return Container();

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
            "Family",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                pokemon.family.length,
                (int i) => this._pokemonEvolution(
                  context,
                  pokemon.family[i],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _pokemonEvolution(BuildContext context, Pokemon pokemon) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.black54,
              child: InkWell(
                splashColor: Colors.white10,
                onTap: () {
                  Navigator.pushReplacementNamed(context, "pokemonDetail",
                      arguments: pokemon);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: PokemonImage(Pokemon.getURLImage(pokemon.id)),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            child: Text(
              "#${pokemon.id} ${pokemon.name}",
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  Widget _image(Pokemon pokemon) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          "pokemonImage",
          arguments: Pokemon.getURLImage(pokemon.id),
        );
      },
      child: Hero(
        tag: "image",
        child: PokemonImage(
          Pokemon.getURLImage(pokemon.id),
        ),
      ),
    );
  }

  Widget _video(Pokemon pokemon) {
    if (this._videoCtrl == null) {
      this._videoCtrl =
          VideoPlayerController.network(Pokemon.getURLVideo(pokemon.name));

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

  Widget _roar(BuildContext context, Pokemon pokemon) {
    return Container();
  }
}
