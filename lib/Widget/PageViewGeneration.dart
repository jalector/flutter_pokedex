import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Generation_model.dart';

class PageViewGeneration extends StatefulWidget {
  PageViewGeneration({Key key}) : super(key: key);

  _PageViewGenerationState createState() => _PageViewGenerationState();
}

class _PageViewGenerationState extends State<PageViewGeneration> {
  int selectedIndex = 0;
  List<Generation> regions = [
    Generation(1, "Kanto"),
    Generation(2, "Johto"),
    Generation(3, "Hoenn"),
    Generation(4, "Sinnoh"),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.25,
        maxWidth: size.width,
      ),
      child: PageView.builder(
          reverse: true,
          itemCount: regions.length,
          controller: PageController(
            initialPage: 0,
            viewportFraction: 0.85,
          ),
          physics: BouncingScrollPhysics(),
          onPageChanged: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return this._generation(
              context,
              regions[index],
              index == this.selectedIndex,
            );
          }),
    );
  }

  Widget _generation(
    BuildContext context,
    Generation generation,
    bool selected,
  ) {
    Duration animationDuration = Duration(milliseconds: 600);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          splashColor: Colors.red,
          onTap: () {
            Navigator.pushNamed(context, "pokedex", arguments: generation);
          },
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        AssetImage("assets/gen/gen_${generation.number}.jpg"),
                  ),
                ),
                duration: Duration(milliseconds: 400),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(10)),
                  ),
                  child: Text(
                    generation.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: animationDuration,
                color: (selected) ? Colors.transparent : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
