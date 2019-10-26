import 'dart:math';

import 'package:flutter/material.dart';

class PokemonNews extends StatefulWidget {
  const PokemonNews({Key key}) : super(key: key);

  @override
  _PokemonNewsState createState() => _PokemonNewsState();
}

class _PokemonNewsState extends State<PokemonNews> {
  List<Color> items = [
    Colors.red,
    Colors.purple,
    Colors.redAccent,
    Colors.blue,
    Colors.green,
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.blueGrey,
    Colors.teal,
  ];
  double currentCard = 0;
  PageController pageCtrl;

  @override
  void initState() {
    pageCtrl = PageController(
      initialPage: items.length - 1,
    );

    pageCtrl.addListener(() {
      setState(() {
        this.currentCard = pageCtrl.page;
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
            reverse: true,
            physics: BouncingScrollPhysics(),
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
    var padding = 10.0;

    var cardAspectRatio = 0.6;
    var widgetAspectRatio = cardAspectRatio * 1.2;

    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints contraints) {
          List<Widget> children = [];
          var width = contraints.maxWidth;
          var height = contraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;

          for (var i = 0; i < items.length; i++) {
            var delta = i - currentCard;
            bool isOnRight = delta > 0;

            var start = padding +
                max(
                    primaryCardLeft -
                        horizontalInset * -delta * (isOnRight ? 15 : 1),
                    0.0);

            children.add(Positioned.directional(
              top: padding + max(-delta, 0.0),
              bottom: padding + max(-delta, 0.0),
              start: start - 30,
              textDirection: TextDirection.rtl,
              child: AspectRatio(
                aspectRatio: 0.75 * 1.2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: items[i].withOpacity(0.3),
                  ),
                  child: Center(child: Text("Item")),
                ),
              ),
            ));
          }

          return Stack(
            children: children,
          );
        },
      ),
    );
  }
}
