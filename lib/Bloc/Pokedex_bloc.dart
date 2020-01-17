import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:flutter_pokedex/Model/Pokemon_model.dart';

class PokedexBloc {
  static PokedexBloc _instance;
  static const int filterModeInclusive = 0;
  static const int filterModeExclusive = 1;

  factory PokedexBloc() {
    if (PokedexBloc._instance == null) {
      PokedexBloc._instance = PokedexBloc._();
    }
    return PokedexBloc._instance;
  }

  PokedexBloc._() {
    this.cleanFilter();
  }

  /// Pokedex Controller
  final _pokedexController = BehaviorSubject<List<Pokemon>>();
  List<Pokemon> get pokedex => _pokedexController.value;

  Stream<List<Pokemon>> get pokedexStream =>
      _pokedexController.stream.transform(
        StreamTransformer<List<Pokemon>, List<Pokemon>>.fromHandlers(
          handleData: _handlePokedexData,
        ),
      );
  Function(List<Pokemon>) get addPokedex => _pokedexController.sink.add;
  Function(String) get addPokedexError => _pokedexController.sink.addError;

  /// Pokemon Height Controller
  final _pokemonHeightController = BehaviorSubject<List<Pokemon>>();
  List<Pokemon> get pokemonHeigh => _pokemonHeightController.value;
  Stream<List<Pokemon>> get pokemonHeightStream =>
      _pokemonHeightController.stream;

  Function(String) get addErrorPokemonHeight =>
      _pokemonHeightController.sink.addError;
  Function(Pokemon) get addPokemonHeight => (Pokemon pokemon) {
        _pokemonHeightController.sink.add(pokemonHeigh..add(pokemon));
      };
  Function(List<Pokemon>) get addPokemonListHeight =>
      _pokemonHeightController.sink.add;

  Function(Pokemon) get removePokemonHeight => (Pokemon pokemon) =>
      _pokemonHeightController.sink.add(pokemonHeigh..remove(pokemon));

  /// Search Pokemon Controller
  final _searchedPokemonController = BehaviorSubject<String>();
  Stream<String> get searchedPokemonStream => _searchedPokemonController.stream;
  String get searchedPokemon => _searchedPokemonController.value;
  Function(String) get onChangeSearchedPokemon =>
      _searchedPokemonController.sink.add;
  Function(String) get onChangeSearchedPokemonError =>
      _searchedPokemonController.sink.addError;

  /// Loading Pokemon Controller
  final _loadingPokemonsController = BehaviorSubject<bool>();
  Stream<bool> get loadingPokemonsStream => _loadingPokemonsController.stream;
  Function(bool) get isLoading => _loadingPokemonsController.sink.add;
  bool get loading => _loadingPokemonsController.value;

  /// Filter Pokemon Controller
  final _filterPokemonController = BehaviorSubject<Map<String, bool>>();
  Stream<Map<String, bool>> get filterTypes => _filterPokemonController.stream;
  Map<String, bool> get filter => _filterPokemonController.value;
  Function(Map<String, bool>) get addFilter =>
      _filterPokemonController.sink.add;

  /// Filter Mode Controller
  final _filterModeController = BehaviorSubject<int>();
  int get filterMode => _filterModeController.value;
  Stream<int> get filterModeStream => _filterModeController.stream;
  Function(int) get changeFilterMode => _filterModeController.sink.add;

  void dispose() {
    _pokedexController.close();
    _searchedPokemonController.close();
    _loadingPokemonsController.close();
    _filterPokemonController.close();
    _filterModeController.close();
    _pokemonHeightController.close();
  }

  void _handlePokedexData(List<Pokemon> pokedex, sink) {
    if (pokedex == null) return;
    List<Pokemon> filterPokedex = pokedex;
    String filterByTypes = "";
    int amountOfAvailableTypes = 0;

    /// Serach about a concept
    if (searchedPokemon != null && searchedPokemon.isNotEmpty) {
      filterPokedex = filterPokedex
          .where((Pokemon poke) =>
              poke.name.toLowerCase().contains(searchedPokemon.toLowerCase()))
          .toList();
    }

    filter.forEach((String type, bool available) {
      if (available) {
        filterByTypes += type.toLowerCase();
        amountOfAvailableTypes++;
      }
    });

    if (filterByTypes.isNotEmpty) {
      filterPokedex = filterPokedex.where((Pokemon poke) {
        var type1 = filterByTypes.contains(poke.type1);

        var type2 = (poke.type2 != null && poke.type2.isNotEmpty)
            ? filterByTypes.contains(poke.type2)
            : false;
        var show = true;

        /// if amountOfAvailablesTypes == 1, need to get all of this type and no
        /// check the other types, is like inclucive mode
        if (filterMode == filterModeInclusive || amountOfAvailableTypes == 1) {
          show = type1 || type2;
        } else if (filterMode == filterModeExclusive) {
          show = type1 && type2;
        }
        return show;
      }).toList();
    }

    if (filterPokedex.isNotEmpty) {
      sink.add(filterPokedex);
    } else {
      sink.addError("Pokemon no found");
    }
  }

  void cleanFilter() {
    _filterPokemonController.sink.add({
      "Bug": false,
      "Dragon": false,
      "Fairy": false,
      "Poison": false,
      "Fire": false,
      "Ghost": false,
      "Ground": false,
      "Rock": false,
      "Normal": false,
      "Psychic": false,
      "Steel": false,
      "Water": false,
      "Dark": false,
      "Electric": false,
      "Fighting": false,
      "Flying": false,
      "Grass": false,
      "Ice": false,
    });
    _pokemonHeightController.sink.add([]);
    this.changeFilterMode(filterModeInclusive);
  }
}
