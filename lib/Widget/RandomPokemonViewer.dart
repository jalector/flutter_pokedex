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
    viewportFraction: 0.5,
  );

  @override
  void initState() {
    this.widget.provider.loadRandomPokemons(3);

    pageCtrl.addListener(() {
      double maxPosition = pageCtrl.position.maxScrollExtent - 100;
      double position = pageCtrl.position.pixels;

      if (position > maxPosition && !this.widget.provider.bloc.loading) {
        this.widget.provider.loadRandomPokemons(10);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PokedexProvider provider = PokedexProvider.of(context);
    return StreamBuilder<List<Pokemon>>(
      stream: provider.bloc.pokedexStream,
      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
        if (snapshot.hasData) {
          List<Pokemon> pokemons = snapshot.data;

          return AspectRatio(
            aspectRatio: 2.3,
            child: Container(
              child: PageView.builder(
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
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              child: Text(
                snapshot.error.toString(),
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red),
              ),
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
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          elevation: 3.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: ((selected == index) ? 1 : 0.3),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image(
                      image: AssetImage("assets/effect.gif"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 10,
                    child: Text(
                      "${pokemon.name}",
                      style: theme.textTheme.title.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: PokemonImage(
                      Pokemon.getURLImage(pokemon.id, null),
                    ),
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
          ),
        ),
      ),
    );
  }
}
