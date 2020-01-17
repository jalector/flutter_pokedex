import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Delegate/HeightSeachDelegate.dart';
import 'package:provider/provider.dart';

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
    var provider = PokedexProvider.of(context);
    return WillPopScope(
      onWillPop: () async {
        provider.bloc.addPokemonListHeight([]);
        return true;
      },
      child: ChangeNotifierProvider<PageControllerNotifier>(
        create: (_) => PageControllerNotifier(pageController),
        child: Scaffold(
          appBar: AppBar(
            title: Text("How tall is your pokemon?"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
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
            builder:
                (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
              if (snapshot.hasData) {
                return pokemonStack(context, orderBySize(snapshot.data));
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
    return list..sort((a, b) => a.height.compareTo(b.height));
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
            reverse: true,
            children: List<Widget>.generate(pokemon.length, (int intem) {
              return Container();
            }),
          ),
        ),
      ],
    );
  }

  Widget pokemonImages(
      BuildContext context, int maxHeight, List<Pokemon> pokemon) {
    Size size = MediaQuery.of(context).size;

    return Consumer<PageControllerNotifier>(
      builder: (context, notifier, child) {
        List<Widget> images = [];
        double relation = (size.height * screenHeightUsable) / maxHeight;
        double scrollMove = -notifier.page * pokemon.length * 45;
        double pokemonWidth = 0;

        for (int i = pokemon.length - 1; i >= 0; i--) {
          var poke = pokemon[i];

          pokemonWidth += (poke.height * 4) * (maxHeight * 8);

          images.add(
            Positioned(
              bottom: size.height * 0.08,
              height: relation * poke.height,
              right: pokemonWidth + scrollMove,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white10,
                ),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Image.network(
                      Pokemon.getURLImage(poke.id, poke.form),
                      fit: BoxFit.cover,
                    ),
                    Positioned(top: -15, child: Text("${poke.height}m")),
                  ],
                ),
              ),
            ),
          );
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
