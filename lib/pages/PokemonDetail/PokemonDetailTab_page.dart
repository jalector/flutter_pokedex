import 'package:Pokedex/Pages/PokemonDetail/PokemonMoveSet_page.dart';
import 'package:Pokedex/Widget/CustomLoader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Model/Pokemon_model.dart';
import '../../Provider/PokedexProvider.dart';
import 'PokemonCounter_page.dart';
import 'PokemonDetail_page.dart';

class PokemonDetailTabPage extends StatefulWidget {
  const PokemonDetailTabPage({Key key}) : super(key: key);

  @override
  _PokemonDetailTabPageState createState() => _PokemonDetailTabPageState();
}

class _PokemonDetailTabPageState extends State<PokemonDetailTabPage> {
  @override
  Widget build(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);

    return WillPopScope(
      onWillPop: () async {
        provider.bloc.clearPokemonDetail();
        provider.movesBloc.movesClearList();
        return true;
      },
      child: StreamBuilder(
        stream: provider.bloc.pokemonDetailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _tabPage(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Container(
                  child: Text(snapshot.error.toString()),
                ),
              ),
            );
          }
          return Scaffold(
            body: CustomLoader(),
          );
        },
      ),
    );
  }

  Widget _tabPage(BuildContext context, Pokemon pokemon) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "${pokemon.name}",
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              Text("#${pokemon.id}",
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
          centerTitle: false,
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(icon: Icon(FontAwesomeIcons.shieldAlt)),
              Tab(icon: Icon(FontAwesomeIcons.userAlt)),
              Tab(icon: Icon(FontAwesomeIcons.exclamationTriangle)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PokemonCounterPage(pokemon),
            PokemonDetailPage(pokemon),
            PokemonMoveSet(pokemon),
          ],
        ),
      ),
    );
  }
}
