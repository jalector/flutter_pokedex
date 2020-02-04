import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Model/Pokemon_model.dart';
import '../../Provider/PokedexProvider.dart';
import 'PokemonDetail_page.dart';

class PokemonDetailTabPage extends StatefulWidget {
  const PokemonDetailTabPage({Key key}) : super(key: key);

  @override
  _PokemonDetailTabPageState createState() => _PokemonDetailTabPageState();
}

class _PokemonDetailTabPageState extends State<PokemonDetailTabPage> {
  @override
  Widget build(BuildContext context) {
    Pokemon pokemon = ModalRoute.of(context).settings.arguments;
    PokedexProvider provider = PokedexProvider.of(context);
    return WillPopScope(
      onWillPop: () async {
        provider.bloc.clearPokemonDetail();
        return true;
      },
      child: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${pokemon.name}",
                  style: Theme.of(context).textTheme.title,
                ),
                Spacer(),
                Text("#${pokemon.id}",
                    style: Theme.of(context).textTheme.title),
              ],
            ),
            centerTitle: false,
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
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
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
