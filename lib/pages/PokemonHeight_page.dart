import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Delegate/HeightSeachDelegate.dart';
import '../Provider/PokedexProvider.dart';
import '../Widget/CustomLoader.dart';

class PokemonHeightPage extends StatefulWidget {
  const PokemonHeightPage({Key key}) : super(key: key);
  @override
  _PokemonHeightPageState createState() => _PokemonHeightPageState();
}

class _PokemonHeightPageState extends State<PokemonHeightPage> {
  final double screenHeightUsable = 0.65;
  PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    var provider = PokedexProvider.of(context);

    return WillPopScope(
      onWillPop: () async {
        provider.bloc.clearPokedex();
        return true;
      },
      child: ChangeNotifierProvider<PageControllerNotifier>(
        create: (_) => PageControllerNotifier(pageController),
        child: Scaffold(
          appBar: AppBar(
            title: Text("How tall is your pokemon?"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: HeightSearchDelegate(),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: null,
              )
            ],
          ),
          body: StreamBuilder<List<Pokemon>>(
            stream: provider.bloc.pokemonHeightStream,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return pokemonStack(context, orderBySize(snapshot.data));
                } else {
                  return Center(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Image(
                            image: AssetImage("assets/unown.png"),
                            color: theme.accentColor.withOpacity(0.3),
                            width: size.width * 0.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Center(
                          child: Text(
                            "Add more pokemons",
                            style: theme.textTheme.title,
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
              return Center(
                child: CustomLoader(),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Pokemon> orderBySize(List<Pokemon> list) {
    return list
      ..sort((a, b) => a.height.compareTo(b.height))
      ..reversed.toList();
  }

  int getMaxHeight(List<Pokemon> pokemon) {
    int height = 1;
    pokemon.forEach((Pokemon poke) =>
        height = (poke.height > height) ? poke.height.ceil() : height);

    return height;
  }

  Widget pokemonStack(BuildContext context, List<Pokemon> pokemon) {
    var maxHeight = getMaxHeight(pokemon);

    return Stack(
      children: <Widget>[
        pokemonLines(context, maxHeight),
        pokemonImages(context, maxHeight, pokemon),
        Positioned.fill(
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: pageController,
            scrollDirection: Axis.horizontal,
            pageSnapping: false,
            children: List<Widget>.generate(pokemon.length, (int item) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Text("$item"),
                  )
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget pokemonImages(
      BuildContext context, int maxHeight, List<Pokemon> pokemon) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Consumer<PageControllerNotifier>(
      builder: (context, notifier, child) {
        List<Widget> images = [];
        double relation = (size.height * screenHeightUsable) / maxHeight;
        double scrollMove =
            -notifier.page * pokemon.length * (pokemon.length - maxHeight);
        double pokemonWidth = 0;

        for (int i = 0, e = pokemon.length; i < e; i++) {
          var poke = pokemon[i];
          var height = relation * poke.height;

          images.add(
            Positioned(
              bottom: size.height * 0.08,
              height: height,
              width: height,
              left: (pokemon.length * 10) + scrollMove + pokemonWidth,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26,
                ),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Image.network(
                      poke.fullImage,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: -15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          "${poke.name} ${poke.height}m",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          pokemonWidth += height + 70;
        }

        return Stack(
          fit: StackFit.expand,
          children: images,
        );
      },
    );
  }

  Widget pokemonLines(BuildContext context, int maxHeight) {
    List<Widget> list = [];

    list
      ..addAll(createLines(context, maxHeight))
      ..addAll(createText(context, maxHeight));

    return Positioned.fill(child: Stack(children: list));
  }

  List<Widget> createLines(BuildContext context, int maxHeight) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    int totalLines = (maxHeight * 5);

    double padding = size.height * 0.08;
    double spaceBetweenLines = (size.height * screenHeightUsable) / totalLines;

    return List.generate(totalLines + 1, (int i) {
      var position = i * spaceBetweenLines + (padding);

      return Positioned(
        bottom: position,
        width: size.width * 0.95,
        left: size.width * 0.025,
        height: 1,
        child: Container(
          child: Divider(
            thickness: ((i % 5) == 0) ? 2 : 0.2,
            color: theme.accentColor,
          ),
        ),
      );
    });
  }

  List<Widget> createText(BuildContext context, int maxHeight) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    double padding = size.height * 0.08;
    double spaceBetweenLines = (size.height * screenHeightUsable) / maxHeight;

    return List.generate(maxHeight + 1, (int i) {
      var position = i * spaceBetweenLines + (padding);

      return Positioned(
        bottom: position + 2,
        width: size.width * 0.95,
        left: size.width * 0.025 + 10,
        child: Container(
          child: Text(
            "${i}m",
            style: theme.textTheme.caption.copyWith(
              color: theme.accentColor,
            ),
          ),
        ),
      );
    });
  }
}

class PageControllerNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageControllerNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;

      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
}
