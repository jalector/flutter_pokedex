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
        appBar: AppBar(),
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
    var maxHeight = getMaxHeight(pokemon);
    return Stack(
      children: <Widget>[
        pokemonLines(context, maxHeight),
        pokemonImages(context, maxHeight, pokemon),
        Positioned.fill(
          child: PageView(
            controller: pageController,
            pageSnapping: false,
            scrollDirection: Axis.horizontal,
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
        double relation = (size.height * 0.75) / maxHeight;
        double scrollMove = -notifier.page * pokemon.length * 10;
        for (int i = pokemon.length - 1; i >= 0; i--) {
          var poke = pokemon[i];
          images.add(
            Positioned(
              bottom: size.height * 0.07,
              top: relation / poke.height * 0.4,
              left: (size.width * 0.3) + (150 * i) + scrollMove,
              child: Container(
                color: Colors.white10,
                child: Image.network(
                  Pokemon.getURLImage(poke.id, poke.form),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        return Stack(children: images);
      },
    );
  }

  Widget pokemonLines(BuildContext context, int maxHeight) {
    ThemeData theme = Theme.of(context);
    return Positioned.fill(
      child: CustomPaint(
        painter: TablePainter(theme: theme, maxHeight: maxHeight),
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

  /// Cada unidad es un metro
  int maxHeight = 3;

  TablePainter({@required this.theme, this.maxHeight});

  @override
  void paint(Canvas canvas, Size size) {
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

    double spaceBetweenLines = (size.height * 0.85) / maxHeight;

    var padding = size.height * 0.05;

    for (int i = maxHeight - 1; i >= 0; i--) {
      var position = i * spaceBetweenLines + padding * 1.5;
      var point1 = Offset(padding, position);
      var point2 = Offset(size.width - padding, position);

      drawText(theme, size, canvas, point1, maxHeight - i);
      drawMiniLines(theme, size, canvas, spaceBetweenLines, point1.dy, padding);
      canvas.drawLine(point1, point2, paint);
    }

    var lastPosition = maxHeight * spaceBetweenLines + padding * 1.5;
    canvas.drawLine(
      Offset(padding, lastPosition),
      Offset(size.width - padding, lastPosition),
      paint,
    );
    drawText(theme, size, canvas, Offset(padding, lastPosition), 0);
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

    canvas.drawParagraph(paragraph, Offset(offset.dx, offset.dy - 15));
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
