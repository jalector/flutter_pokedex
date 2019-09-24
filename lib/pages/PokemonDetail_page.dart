import 'package:flutter/material.dart';
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
  GlobalRequest globalRequest = GlobalRequest();

  @override
  void dispose() {
    this._videoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pokemon pokemon = ModalRoute.of(context).settings.arguments;
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
                    future: globalRequest.getPokemon(pokemon.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<Pokemon> snapshot) {
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

  Widget _pokemonDetail(BuildContext context, Pokemon pokemon) {
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
                    this._pokemonType(pokemon.type1),
                    (pokemon.type2 != null)
                        ? this._pokemonType(pokemon.type2)
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
        this._generationBanner(context, pokemon),
        this._adjacentPokemon(context, pokemon),
        this._family(context, pokemon),
      ],
    );
  }

  Widget _adjacentPokemon(BuildContext context, Pokemon pokemon) {
    return Row(children: <Widget>[
      (pokemon.id > 0)
          ? _adjacent(pokemon.id - 1, true)
          : Expanded(child: Container()),
      (pokemon.id < 809)
          ? _adjacent(pokemon.id + 1, false)
          : Expanded(child: Container()),
    ]);
  }

  Widget _adjacent(int number, bool borderLeft) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          Pokemon poke = await this.globalRequest.getPokemonMinimalInfo(number);
          Navigator.pushReplacementNamed(
            context,
            "pokemonDetail",
            arguments: poke,
          );
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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.lightGreen.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Generation #${pokemon.generation}",
        style: Theme.of(context).textTheme.title,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _pokemonType(String type) {
    return Container(
      child: Text(type),
    );
  }

  Widget _family(BuildContext context, Pokemon pokemon) {
    if (pokemon.family.length == 0) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10),
            ),
          ),
          child: Text(
            "Familia",
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
                  width: MediaQuery.of(context).size.width * 0.25,
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

  Widget _video(Pokemon pokemon) {
    if (this._videoCtrl == null) {
      this._videoCtrl =
          VideoPlayerController.network(Pokemon.getURLVideo(pokemon.name));

      return FutureBuilder(
        future: _videoCtrl.initialize(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            this._videoCtrl.play();
            this._videoCtrl.setLooping(true);
            return this._createVideoUI();
          } else {
            return Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      );
    } else {
      return this._createVideoUI();
    }
  }

  Widget _createVideoUI() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "pokemonVideo", arguments: _videoCtrl);
          },
          child: Hero(
            tag: "video",
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
                    child: VideoPlayer(_videoCtrl),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
