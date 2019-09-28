import 'package:flutter/material.dart';
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
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: Hero(
              tag: "video",
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    color: Colors.white,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
