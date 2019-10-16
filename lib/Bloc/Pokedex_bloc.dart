import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';

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
  final _loadingPokemonsController = BehaviorSubject<bool>();

  Stream<List<Pokemon>> get pokedexStream =>
      _pokedexController.stream.transform(
        StreamTransformer<List<Pokemon>, List<Pokemon>>.fromHandlers(
          handleData: (List<Pokemon> pokedex, sink) {
            if (pokedex != null) {
              if (searchedPokemon == null || searchedPokemon.isEmpty) {
                sink.add(pokedex);
              } else {
                var list = pokedex
                    .where(
                      (Pokemon poke) => (poke.name.toLowerCase().contains(
                            searchedPokemon.toLowerCase(),
                          )),
                    )
                    .toList();
                if (list.length > 0) {
                  sink.add(list);
                } else {
                  sink.addError("Pokemon no found");
                  onChangeSearchedPokemonErro("Pokemon no found");
                }
              }
            }
          },
        ),
      );

  Stream<String> get searchedPokemonStream => _searchedPokemonController.stream;
  Stream<bool> get loadingPokemonsStream => _loadingPokemonsController.stream;

  Function(List<Pokemon>) get addPokedex => _pokedexController.sink.add;
  Function(String) get addPokedexError => _pokedexController.sink.addError;

  Function(bool) get isLoading => _loadingPokemonsController.sink.add;

  Function(String) get onChangeSearchedPokemon =>
      _searchedPokemonController.sink.add;
  Function(String) get onChangeSearchedPokemonErro =>
      _searchedPokemonController.sink.addError;

  List<Pokemon> get pokedex => _pokedexController.value;
  String get searchedPokemon => _searchedPokemonController.value;
  bool get loading => _loadingPokemonsController.value;

  void dispose() {
    _pokedexController.close();
    _searchedPokemonController.close();
    _loadingPokemonsController.close();
  }
}
