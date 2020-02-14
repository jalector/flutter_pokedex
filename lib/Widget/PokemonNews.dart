import 'dart:math';

import 'package:flutter/material.dart';
import '../Model/New_model.dart';

class PokemonNews extends StatefulWidget {
  final List<New> items;
  const PokemonNews(this.items);

  @override
  _PokemonNewsState createState() => _PokemonNewsState();
}

class _PokemonNewsState extends State<PokemonNews> {
  double currentCard = 0;
  PageController pageCtrl;

  @override
  void initState() {
    pageCtrl = PageController(
      initialPage: widget.items.length - 1,
    );

    currentCard = (widget.items.length - 1).toDouble();

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
            itemCount: widget.items.length,
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
          var style = Theme.of(context);
          var width = contraints.maxWidth;
          var height = contraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 4;

          for (var i = 0, e = widget.items.length; i < e; i++) {
            New noticia = widget.items[i];
            var delta = i - currentCard;
            bool isOnRight = delta > 0;

            var start = padding +
                max(
                    primaryCardLeft -
                        horizontalInset * -delta * (isOnRight ? 25 : 1),
                    0.0);

            children.add(Positioned.directional(
              top: padding + 20 * max(-delta, 0.0),
              bottom: padding + 20 * max(-delta, 0.0),
              start: start - 30,
              textDirection: TextDirection.rtl,
              child: AspectRatio(
                aspectRatio: 0.60,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(noticia.image),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6),
                          BlendMode.darken,
                        ),
                      )),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FlatButton(
                          onPressed: () async {},
                          child: Text("Go to new"),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 20,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          noticia.title,
                          softWrap: true,
                          style: style.textTheme.headline4,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 20,
                        child: Text(
                          noticia.tags,
                          style: style.textTheme.bodyText2,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 20,
                        child: Text(
                          noticia.date,
                          style: style.textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
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
