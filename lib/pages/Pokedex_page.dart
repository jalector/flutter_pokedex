import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class PokedexPage extends StatefulWidget {
  @override
  _PokedexPageState createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final GlobalRequest globalRequest = GlobalRequest();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool agua = true;

  @override
  Widget build(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);
    ThemeData theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        provider.bloc.onChangeSearchedPokemon("");
        provider.loadRandomPokemons(3, cleanPokedex: true);
        return true;
      },
      child: Scaffold(
        key: this.scaffoldKey,
        backgroundColor: theme.primaryColorDark,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: this._bottomSheetBuilder,
              backgroundColor: Colors.transparent,
            );
          },
        ),
        body: this._pokedex(context, provider),
      ),
    );
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.green,
      ),
      padding: EdgeInsets.all(30),
      child: Wrap(
        children: <Widget>[
          FilterChip(
            label: Text("Water"),
            selected: agua,
            avatar: CircleAvatar(
              child: Container(
                color: Colors.red,
              ),
            ),
            onSelected: (value) {
              setState(() {
                agua = !agua;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _pokedex(BuildContext context, PokedexProvider provider) {
    String title = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    double cardWidth;

    if (size.width > 1200) {
      cardWidth = size.width * 0.15;
    } else if (size.width >= 750) {
      cardWidth = size.width * 0.175;
    } else {
      cardWidth = size.width * 0.35;
    }

    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          pinned: false,
          title: this.searchField(provider),
          elevation: 15,
          flexibleSpace: SafeArea(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.display2,
            ),
          ),
        ),
        StreamBuilder<List<Pokemon>>(
          stream: provider.bloc.pokedexStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
            Widget builder;
            List<Pokemon> pokedex = snapshot.data;
            if (snapshot.hasData) {
              builder = SliverGrid.extent(
                maxCrossAxisExtent: cardWidth,
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
                delegate: SliverChildListDelegate([CustomLoader()]),
              );
            }

            return builder;
          },
        ),
      ],
    );
  }

  Widget _pokemonCard(BuildContext context, Pokemon pokemon) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "pokemonDetail", arguments: pokemon);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text("#${pokemon.id}"),
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
            PokemonImage(Pokemon.getURLImage(pokemon.id, pokemon.form)),
          ],
        ),
      ),
    );
  }

  Widget searchField(PokedexProvider provider) {
    return StreamBuilder<String>(
      stream: provider.bloc.searchedPokemonStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            hintText: "Search your pokemon",
            errorText: snapshot.error,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          initialValue: provider.bloc.searchedPokemon,
          onChanged: provider.bloc.onChangeSearchedPokemon,
        );
      },
    );
  }
}
