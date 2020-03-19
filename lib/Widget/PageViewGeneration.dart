import 'package:flutter/material.dart';
import '../Model/Generation_model.dart';
import '../Provider/PokedexProvider.dart';

class PageViewGeneration extends StatefulWidget {
  PageViewGeneration({Key key}) : super(key: key);

  _PageViewGenerationState createState() => _PageViewGenerationState();
}

class _PageViewGenerationState extends State<PageViewGeneration>
    with SingleTickerProviderStateMixin {
  AnimationController _animCtrl;
  Animation _countGeneration;
  PageController _pageCtrl;

  int selectedIndex = 0;
  List<Generation> regions = [
    Generation(1, "Kanto"),
    Generation(2, "Johto"),
    Generation(3, "Hoenn"),
    Generation(4, "Sinnoh"),
    Generation(5, "Unova"),
    Generation(6, "Kalos"),
    Generation(7, "Alola"),
  ];

  @override
  void initState() {
    this._animCtrl = new AnimationController(
      vsync: this,
      duration: Duration(seconds: regions.length * 10),
    );

    this._pageCtrl = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );

    this._countGeneration = StepTween(
      begin: 0,
      end: this.regions.length - 1,
    ).animate(this._animCtrl);

    this._animCtrl.addListener(() {
      int page = (this._countGeneration.value as int);

      if (this.selectedIndex != page) {
        this.selectedIndex = page;

        this._pageCtrl.animateToPage(
              page,
              duration: Duration(
                milliseconds: (page == this.regions.length - 1) ? 300 : 500,
              ),
              curve: Curves.easeInOut,
            );
        setState(() {});
      }
    });
    this._animCtrl.forward();
    this._animCtrl.repeat();
    super.initState();
  }

  @override
  void dispose() {
    this._animCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: PageView.builder(
        controller: this._pageCtrl,
        itemCount: this.regions.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => this._generation(
          context,
          regions[index % regions.length],
          index == this.selectedIndex,
        ),
      ),
    );
  }

  Widget _generation(
    BuildContext context,
    Generation generation,
    bool selected,
  ) {
    Duration animationDuration = Duration(milliseconds: 600);
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          PokedexProvider.of(context)
              .getPokedexGeneration(generation.number, cleanPokedex: true);
          Navigator.pushNamed(context, "pokedex", arguments: generation.title);
        },
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/gen/gen_${generation.number}.jpg",
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      generation.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: animationDuration,
                  color: (selected) ? Colors.transparent : Colors.black12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
