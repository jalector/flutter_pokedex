import 'package:flutter/material.dart';

import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:flutter_pokedex/Widget/BottomSheetFilter.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokedexPage extends StatefulWidget {
  @override
  _PokedexPageState createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final GlobalRequest globalRequest = GlobalRequest();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);

    return WillPopScope(
      onWillPop: () async {
        provider.bloc.onChangeSearchedPokemon("");
        provider.bloc.cleanFilter();
        provider.loadRandomPokemons(3, cleanPokedex: true);
        return true;
      },
      child: Scaffold(
        key: this.scaffoldKey,
        floatingActionButton: _floatinFilterButtons(context),
        body: this._pokedex(context, provider),
      ),
    );
  }

  Widget _floatinFilterButtons(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);
    return StreamBuilder(
      stream: provider.bloc.filterTypes,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget widget = CircularProgressIndicator();

        if (snapshot.hasData && this._filterIsActive(snapshot.data)) {
          widget = _getFloatincButtons(context, snapshot.data);
        } else {
          widget = this._filterButton(context);
        }
        return widget;
      },
    );
  }

  bool _filterIsActive(Map<String, bool> types) {
    return types.values.where((bool available) => available).isNotEmpty;
  }

  Widget _getFloatincButtons(BuildContext context, Map<String, bool> types) {
    List<Widget> buttonTypes = [];
    ThemeData theme = Theme.of(context);
    PokedexProvider provider = PokedexProvider.of(context);
    types.forEach((String type, bool available) {
      if (available) {
        buttonTypes.add(FloatingActionButton(
          tooltip: "$type filter",
          heroTag: type,
          mini: true,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              "assets/badges_type/${type.toLowerCase()}.png",
              fit: BoxFit.contain,
            ),
          ),
          onPressed: () {
            types[type] = !types[type];
            provider.bloc.addFilter(types);
            setState(() {});
          },
        ));
      }
    });

    buttonTypes.add(this._filterButton(context));
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: theme.accentColor.withOpacity(0.7),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: buttonTypes,
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.search),
      mini: true,
      heroTag: "searchButton",
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isDismissible: true,
          builder: (context) => BottomSheetFilter(update: setState),
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  double _calculateCardWidth(Size size) {
    double cardWidth;

    if (size.width > 1500) {
      cardWidth = size.width * 0.1;
    } else if (size.width > 1200) {
      cardWidth = size.width * 0.15;
    } else if (size.width >= 750) {
      cardWidth = size.width * 0.175;
    } else {
      cardWidth = size.width * 0.35;
    }
    return cardWidth;
  }

  Widget _pokedex(BuildContext context, PokedexProvider provider) {
    String title = ModalRoute.of(context).settings.arguments;

    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          pinned: false,
          elevation: 5,
          centerTitle: false,
          title: Text(title, style: Theme.of(context).textTheme.display1),
        ),
        StreamBuilder<List<Pokemon>>(
          stream: provider.bloc.pokedexStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
            Widget builder;
            List<Pokemon> pokedex = snapshot.data;
            if (snapshot.hasData) {
              builder = SliverGrid.extent(
                maxCrossAxisExtent:
                    this._calculateCardWidth(MediaQuery.of(context).size),
                children: pokedex
                    .map<Widget>((Pokemon pokemon) =>
                        this._pokemonCard(context, pokemon))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              builder = SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            color: Theme.of(context).errorColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              );
            } else {
              builder = SliverList(
                delegate: SliverChildListDelegate(
                    [Center(heightFactor: 2, child: CustomLoader())]),
              );
            }

            return builder;
          },
        ),
      ],
    );
  }

  Widget _pokemonCard(BuildContext context, Pokemon pokemon) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          color: Theme.of(context).primaryColor,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, "pokemonDetail",
                arguments: pokemon),
            child: Container(
              margin: EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:
                        Text("#${pokemon.id}", style: theme.textTheme.caption),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Opacity(
                      opacity: 0.2,
                      child: Text(
                        pokemon.name,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                  PokemonImage(
                    Pokemon.getURLImage(
                      pokemon.id,
                      pokemon.form,
                      full: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
