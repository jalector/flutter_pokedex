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
  final _filterTypeController = BehaviorSubject<List<String>>();

  Stream<List<Pokemon>> get pokedexStream =>
      _pokedexController.stream.transform(
        StreamTransformer<List<Pokemon>, List<Pokemon>>.fromHandlers(
          handleData: handlePokedexFilter,
        ),
      );
  Stream<String> get searchedPokemonStream => _searchedPokemonController.stream;
  Stream<bool> get loadingPokemonsStream => _loadingPokemonsController.stream;
  Stream<List<String>> get filterTypeStream => _filterTypeController.stream;

  Function(List<Pokemon>) get addPokedex => _pokedexController.sink.add;
  Function(String) get addPokedexError => _pokedexController.sink.addError;
  Function(bool) get isLoading => _loadingPokemonsController.sink.add;
  Function(String) get onChangeSearchedPokemon =>
      _searchedPokemonController.sink.add;
  Function(String) get onChangeSearchedPokemonError =>
      _searchedPokemonController.sink.addError;

  List<Pokemon> get pokedex => _pokedexController.value;
  String get searchedPokemon => _searchedPokemonController.value;
  bool get loading => _loadingPokemonsController.value;
  List<String> get filterType => _filterTypeController.value;

  void dispose() {
    _pokedexController.close();
    _searchedPokemonController.close();
    _loadingPokemonsController.close();
    _filterTypeController.close();
  }

  handlePokedexFilter(List<Pokemon> pokemon, EventSink<List<Pokemon>> sink) {
    if (pokedex != null) {
      var list = pokemon;

      if (searchedPokemon != null && searchedPokemon.isNotEmpty) {
        list = list
            .where((Pokemon p) =>
                p.name.toLowerCase().contains(searchedPokemon.toLowerCase()))
            .toList();
      }

      if (list.isEmpty) {
        sink.addError("Pokemon no found");
        onChangeSearchedPokemonError("Pokemon no found");
      } else {
        sink.add(list);
      }
    }
  }
}
