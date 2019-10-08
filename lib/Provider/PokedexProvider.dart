import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Bloc/Pokedex_bloc.dart';
import 'package:flutter_pokedex/Provider/GlobalRequest.dart';

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
    this.bloc.addPokedex(null);

    HttpAnswer<List<Pokemon>> answer =
        await this._globalRequest.getPokedexGeneration(generation);

    if (answer.ok) {
      this.bloc.addPokedex(answer.object);
    } else {
      this.bloc.addPokedexError(answer.reasonPhrase);
    }
  }
}
