import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
import 'package:flutter_pokedex/Provider/PokedexProvider.dart';
import 'package:flutter_pokedex/Widget/CustomLoader.dart';
import 'package:flutter_pokedex/Widget/PokemonImage.dart';

class RandomPokemonViewer extends StatefulWidget {
  final PokedexProvider provider;
  RandomPokemonViewer(this.provider);

  @override
  _RandomPokemonViewerState createState() => _RandomPokemonViewerState();
}

class _RandomPokemonViewerState extends State<RandomPokemonViewer> {
  int selected = 0;
  PageController pageCtrl = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.4,
  );

  @override
  void initState() {
    this.widget.provider.loadRandomPokemons(3);

    pageCtrl.addListener(() {
      double maxPosition = pageCtrl.position.maxScrollExtent - 100;
      double position = pageCtrl.position.pixels;

      if (position > maxPosition && !this.widget.provider.bloc.loading) {
        this.widget.provider.loadRandomPokemons(5);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<List<Pokemon>>(
      stream: provider.bloc.pokedexStream,
      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
        if (snapshot.hasData) {
          List<Pokemon> pokemons = snapshot.data;

          return Container(
            height: size.height * 0.2,
            width: size.width,
            child: PageView.builder(
              pageSnapping: false,
              itemCount: pokemons.length,
              physics: BouncingScrollPhysics(),
              onPageChanged: (int index) {
                setState(() => this.selected = index);
              },
              controller: this.pageCtrl,
              itemBuilder: (BuildContext context, int index) {
                return this._pokemonCard(context, pokemons[index], index);
              },
            ),
          );
        } else {
          return CustomLoader();
        }
      },
    );
  }

  Widget _pokemonCard(BuildContext context, Pokemon pokemon, int index) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("pokemonDetail", arguments: pokemon);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all((selected == index) ? 0 : 20),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 5,
              left: 10,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: ((selected == index) ? 0.7 : 0.1),
                child: Text(
                  "${pokemon.name}",
                  style: theme.textTheme.title,
                ),
              ),
            ),
            PokemonImage(
              Pokemon.getURLImage(pokemon.id, null),
            ),
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("#${pokemon.id}"),
            ),
          ],
        ),
      ),
    );
  }
}
