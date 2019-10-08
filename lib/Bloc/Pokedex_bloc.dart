import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';
export 'package:flutter_pokedex/Model/Pokemon_model.dart';

class PokedexBloc {
  static PokedexBloc _instance;

  factory PokedexBloc() {
    if (PokedexBloc._instance == null) {
      PokedexBloc._instance = PokedexBloc._();
    }
    return PokedexBloc._instance;
  }

  PokedexBloc._();

  final _pokedexController = BehaviorSubject<List<Pokemon>>();
  final _searchedPokemonController = BehaviorSubject<String>();

  Stream<List<Pokemon>> get pokedexStream =>
      _pokedexController.stream.transform(
        StreamTransformer<List<Pokemon>, List<Pokemon>>.fromHandlers(
          handleData: (List<Pokemon> pokedex, sink) {
            if (pokedex != null) {
              if (searchedPokemon == null || searchedPokemon.isEmpty) {
                sink.add(pokedex);
              } else {
                sink.add(pokedex
                    .where(
                      (Pokemon poke) => (poke.name.toLowerCase().contains(
                            searchedPokemon.toLowerCase(),
                          )),
                    )
                    .toList());
              }
            }
          },
        ),
      );

  Stream<String> get searchedPokemonStream => _searchedPokemonController.stream;

  Function(List<Pokemon>) get addPokedex => _pokedexController.sink.add;
  Function(String) get addPokedexError => _pokedexController.sink.addError;

  Function(String) get onChangeSearchedPokemon =>
      _searchedPokemonController.sink.add;

  List<Pokemon> get pokedex => _pokedexController.value;
  String get searchedPokemon => _searchedPokemonController.value;

  void dispose() {
    _pokedexController.close();
    _searchedPokemonController.close();
  }
}
