import 'dart:math';

import 'package:flutter/material.dart';

class PokemonNews extends StatefulWidget {
  const PokemonNews({Key key}) : super(key: key);

  @override
  _PokemonNewsState createState() => _PokemonNewsState();
}

class _PokemonNewsState extends State<PokemonNews> {
  List<int> items = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  double currentCard = 0;
  PageController pageCtrl;

  @override
  void initState() {
    pageCtrl = PageController(
      initialPage: 1,
    );

    pageCtrl.addListener(() {
      setState(() {
        currentCard = pageCtrl.page;
        print(currentCard);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _cardStack(context),
        Positioned.fill(
          child: PageView.builder(
            controller: pageCtrl,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _cardStack(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints contraints) {
          var padding = 20;

          var width = contraints.maxWidth;
          var height = contraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * 0.75;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;

          return Stack(
            children: items.map<Widget>((int index) {
              var delta = index - currentCard;
              bool isOnRight = delta > 0;

              var start = padding +
                  max(
                    primaryCardLeft -
                        horizontalInset * -delta * (isOnRight ? 15 : 1),
                    0.0,
                  );

              return Positioned.directional(
                top: padding + 20 * max(-delta, 0.0),
                bottom: padding + 20 * max(-delta, 0.0),
                start: start,
                textDirection: TextDirection.rtl,
                child: AspectRatio(
                  aspectRatio: 0.75 * 1.2,
                  child: Container(
                    color: Colors.red,
                    child: Center(child: Text("$index")),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
