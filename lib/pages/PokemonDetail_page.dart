import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/PokemonDetail_model.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';
import 'package:video_player/video_player.dart';

class PokemonDetailPage extends StatefulWidget {
  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  VideoPlayerController _videoCtrl;

  @override
  Widget build(BuildContext context) {
    Pokemon pokemon = ModalRoute.of(context).settings.arguments;
    GlobalRequest globalRequest = GlobalRequest();
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${pokemon.name}",
                      style: Theme.of(context).textTheme.display3,
                    ),
                    Spacer(),
                    Text("#${pokemon.id}",
                        style: Theme.of(context).textTheme.display3),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 40,
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: globalRequest.getPokemonDetail(pokemon.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<PokemonDetail> snapshot) {
                      if (snapshot.hasData) {
                        return _pokemonDetail(context, snapshot.data);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _pokemonDetail(BuildContext context, PokemonDetail pokemon) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _video(pokemon),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pokemon.description,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 15),
                    this.pokemonType(pokemon.type1),
                    (pokemon.type2 != null)
                        ? this.pokemonType(pokemon.type2)
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
        this._family(context, pokemon),
      ],
    );
  }

  Widget pokemonType(String type) {
    return Container(
      child: Text(type),
    );
  }

  Widget _family(BuildContext context, PokemonDetail pokemon) {
    if (pokemon.family.length == 0) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Text(
            "Familia",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.black26),
          child: Row(
            children: List.generate(
              pokemon.family.length,
              (int i) => this._pokemonEvolution(pokemon.family[i]),
            ),
          ),
        )
      ],
    );
  }

  Widget _pokemonEvolution(Family pokemon) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: PokemonImage(Pokemon.getURLImage(pokemon.id)),
          ),
        ],
      ),
    );
  }

  Widget _video(PokemonDetail pokemon) {
    _videoCtrl =
        VideoPlayerController.network(Pokemon.getURLVideo(pokemon.name));

    return FutureBuilder(
        future: _videoCtrl.initialize(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget video;
          if (snapshot.connectionState == ConnectionState.done) {
            this._videoCtrl.play();
            this._videoCtrl.setLooping(true);
            video = Flexible(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.white,
                      child: AspectRatio(
                        aspectRatio: 1,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_videoCtrl),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            video = Flexible(
                child: Center(
                    child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: CircularProgressIndicator(),
            )));
          }

          return video;
        });
  }
}
