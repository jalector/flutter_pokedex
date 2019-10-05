import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PokemonVideo extends StatefulWidget {
  final VideoPlayerController controller;
  const PokemonVideo(this.controller);

  @override
  _PokemonVideoState createState() => _PokemonVideoState();
}

class _PokemonVideoState extends State<PokemonVideo> {
  bool _isPlay = true;

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
              Positioned(bottom: 5, right: 5, child: _playButton(context))
            ],
          ),
        ),
      ),
    );
  }

  _playButton(BuildContext context) {
    IconData icon = _isPlay ? Icons.pause : Icons.play_arrow;

    return GestureDetector(
      onTap: () {
        if (_isPlay) {
          widget.controller.pause();
        } else {
          widget.controller.seekTo(Duration(seconds: 0));
          widget.controller.play();
        }
        setState(() => _isPlay = !_isPlay);
        print(_isPlay);
      },
      child: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
        child: Icon(icon),
      ),
    );
  }
}
