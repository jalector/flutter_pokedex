import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PokemonVideo extends StatefulWidget {
  final VideoPlayerController controller;
  const PokemonVideo(this.controller);

  @override
  _PokemonVideoState createState() => _PokemonVideoState();
}

class _PokemonVideoState extends State<PokemonVideo> {

  @override
  void initState() {
    widget.controller.play();
    widget.controller.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "video",
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(25),
                color: Colors.white,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: VideoPlayer(widget.controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
