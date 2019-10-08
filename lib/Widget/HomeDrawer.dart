import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Generation_model.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData style = Theme.of(context);

    return Container(
      width: size.width * 0.8,
      color: style.accentColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Text(
              "Pokedex",
              style: style.textTheme.title,
            ),
            _generation(context, Generation(1, "Kanto")),
            _generation(context, Generation(2, "Johto")),
            _generation(context, Generation(3, "Hoenn")),
            _generation(context, Generation(4, "Sinnoh")),
            _generation(context, Generation(5, "Unova")),
            _generation(context, Generation(6, "Kalos")),
            _generation(context, Generation(7, "Alola")),
          ],
        ),
      ),
    );
  }

  Widget _generation(BuildContext context, Generation generation) {
    return Container(
      child: Text(generation.title),
    );
  }
}
