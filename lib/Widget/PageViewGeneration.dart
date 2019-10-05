import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Generation_model.dart';

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
      duration: Duration(seconds: regions.length * 5),
    );

    this._pageCtrl = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );

    this._countGeneration = Tween<double>(
      begin: 0,
      end: (this.regions.length - 1).toDouble(),
    ).animate(this._animCtrl);

    this._animCtrl.addListener(() {
      int page = (this._countGeneration.value as double).toInt();

      if (this.selectedIndex != page) {
        this.selectedIndex = page;
        this._pageCtrl.animateToPage(
              page,
              duration: Duration(
                milliseconds: (page == this.regions.length - 1) ? 300 : 500,
              ),
              curve: Curves.easeInOut,
            );
      }
    });
    this._animCtrl.forward();
    this._animCtrl.repeat();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        this._pageViewer(size),
        Positioned(
          right: 0,
          child: Column(
            children: <Widget>[
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  this.selectedIndex++;
                  this._pageCtrl.animateToPage(
                        selectedIndex,
                        duration: Duration(
                          milliseconds:
                              (selectedIndex == this.regions.length - 1)
                                  ? 300
                                  : 500,
                        ),
                        curve: Curves.easeInOut,
                      );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _pageViewer(Size size) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.25,
        maxWidth: size.width,
      ),
      child: PageView.builder(
        controller: this._pageCtrl,
        itemCount: this.regions.length,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (int index) {
          setState(() => selectedIndex = index);
        },
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
