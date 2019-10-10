import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Bloc/Pokedex_bloc.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';

class PokedexProvider extends InheritedWidget {
  static PokedexProvider _instance;
  final PokedexBloc bloc = PokedexBloc();
  final GlobalRequest _globalRequest = GlobalRequest();

  factory PokedexProvider({Key key, Widget child}) {
    if (PokedexProvider._instance == null) {
      _instance = PokedexProvider._(
        key: key,
        child: child,
      );
    }
    return _instance;
  }

  PokedexProvider._({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PokedexProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PokedexProvider)
        as PokedexProvider);
  }

  void getPokedexGeneration(int generation) async {
    if (this.bloc.pokedex != null && this.bloc.pokedex.length > 0) return;

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.getPokedexGeneration(generation);

    if (answer.ok) {
      this.bloc.addPokedex(answer.object);
    } else {
      this.bloc.addPokedexError(answer.reasonPhrase);
    }
  }

  void getPokedexByType(String type) async {
    if (this.bloc.pokedex != null && this.bloc.pokedex.length > 0) return;

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.getPokedexByType(type);

    if (answer.ok) {
      this.bloc.addPokedex(answer.object);
    } else {
      this.bloc.addPokedexError(answer.reasonPhrase);
    }
  }

  void searchPokemon(String searched) async {
    this.bloc.addPokedex([]);

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.searchedPokemon(searched);
    if (answer.ok) {
      if (answer.object.length > 0) {
        this.bloc.addPokedex(answer.object);
      } else {
        this.bloc.addPokedexError("No data found");
      }
    } else {
      this.bloc.addPokedexError(answer.reasonPhrase);
    }
  }
}
