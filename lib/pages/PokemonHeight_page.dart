import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Provider/PokedexProvider.dart';
import '../Widget/CustomLoader.dart';

class PokemonHeightPage extends StatefulWidget {
  const PokemonHeightPage({Key key}) : super(key: key);
  @override
  _PokemonHeightPageState createState() => _PokemonHeightPageState();
}

class _PokemonHeightPageState extends State<PokemonHeightPage> {
  PageController pageController;

  @override
  void initState() {
    pageController = PageController();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = PokedexProvider.of(context);
    return ChangeNotifierProvider<PageControllerNotifier>(
      create: (_) => PageControllerNotifier(pageController),
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: provider.bloc.pokedexStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
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
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

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
            children: List<Widget>.generate(pokemon.length, (int intem) {
              return Container();
            }),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.accentColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: theme.primaryColorDark,
                ),
              ),
            ),
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
        double relation = (size.height * 0.8) / maxHeight;
        double scrollMove = -notifier.page * pokemon.length * 45;
        double pokemonWidth = 0;
        for (int i = pokemon.length - 1; i >= 0; i--) {
          var poke = pokemon[i];
          pokemonWidth += poke.height * 65 * (maxHeight + 1);

          images.add(
            Positioned(
              bottom: size.height * 0.095,
              height: relation * poke.height,
              left: pokemonWidth + scrollMove,
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
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Positioned.fill(
      child: CustomPaint(
        painter: TablePainter(theme: theme, maxHeight: maxHeight, size: size),
        child: Container(),
      ),
    );
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

class TablePainter extends CustomPainter {
  final ThemeData theme;
  Size size;

  /// Cada unidad es un metro
  int maxHeight = 3;

  TablePainter({@required this.theme, this.size, this.maxHeight});

  @override
  void paint(Canvas canvas, _) {
    var paint = Paint()..color = theme.scaffoldBackgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    printLines(theme, size, canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void printLines(ThemeData theme, Size size, Canvas canvas) {
    var paint = Paint()
      ..color = theme.colorScheme.secondaryVariant
      ..strokeWidth = 2;

    double padding = size.height * 0.05;
    double spaceBetweenLines = (size.height * 0.8) / maxHeight;

    for (int i = maxHeight; i >= 0; i--) {
      var position = i * spaceBetweenLines + padding;
      var point1 = Offset(padding, position);
      var point2 = Offset(size.width - padding, position);

      if (i != maxHeight) {
        drawMiniLines(
            theme, size, canvas, spaceBetweenLines, point1.dy, padding);
      }

      canvas.drawLine(point1, point2, paint);

      drawText(theme, size, canvas, Offset(point1.dx, point1.dy - 15),
          maxHeight - i); // Left Text
      drawText(theme, size, canvas, Offset(point2.dx - 15, point2.dy - 15),
          maxHeight - i); // Right Text

    }
  }

  void drawText(
      ThemeData theme, Size size, Canvas canvas, Offset offset, int height) {
    var paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle())
      ..pushStyle(ui.TextStyle(
        color: theme.textTheme.caption.color,
        fontSize: theme.textTheme.caption.fontSize,
      ))
      ..addText("${height}m");

    var paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 300));

    canvas.drawParagraph(paragraph, offset);
  }

  void drawMiniLines(ThemeData theme, Size size, Canvas canvas,
      double spaceBetweenLines, double yPosition, double padding) {
    var paintMini = Paint()
      ..color = theme.colorScheme.secondaryVariant
      ..strokeWidth = 0.6;

    double spaceBetweenLinesmini = spaceBetweenLines / 5;

    for (var j = 4; j >= 0; j--) {
      var miniPosition = j * spaceBetweenLinesmini;

      var p1 = Offset(padding, yPosition + miniPosition);
      var p2 = Offset(size.width - padding, yPosition + miniPosition);

      canvas.drawLine(p1, p2, paintMini);
    }
  }
}
