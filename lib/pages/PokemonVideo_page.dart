import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Widget/PokemonVideo.dart';
import 'package:video_player/video_player.dart';

class PokemonVideoPage extends StatefulWidget {
  @override
  _PokemonVideoPageState createState() => _PokemonVideoPageState();
}

class _PokemonVideoPageState extends State<PokemonVideoPage> {
  VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            vertical: 10,
          ),
          child: PokemonVideo(_controller),
        ),
      ),
    );
  }
}
