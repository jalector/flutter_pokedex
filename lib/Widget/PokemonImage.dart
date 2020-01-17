import 'package:flutter/material.dart';

class PokemonImage extends StatelessWidget {
  final String image;
  final Color obscureColor;
  final bool showProgress;
  final double width;
  final bool fullWidth;
  final BoxFit fit;

  PokemonImage(
    this.image, {
    this.obscureColor,
    this.showProgress = false,
    this.fullWidth = true,
    this.fit = BoxFit.contain,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Image.network(
      image,
      fit: fit,
      width: (fullWidth) ? size.width : width,
      color: obscureColor,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent progress) {
        if (progress == null) {
          return child;
        } else {
          var progressValue =
              progress.cumulativeBytesLoaded / progress.expectedTotalBytes;
          return Stack(
            children: <Widget>[
              (showProgress)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: LinearProgressIndicator(value: progressValue),
                      ),
                    )
                  : Container(),
              Center(child: Image.asset("assets/load_pokeball.gif")),
            ],
          );
        }
      },
    );
  }
}
