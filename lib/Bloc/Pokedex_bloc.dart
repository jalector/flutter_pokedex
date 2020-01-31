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
    clearFilter();
    _pokemonHeightController.sink.add([]);
    _pokedexController.sink.add([]);
  }

  final _pokedexController = BehaviorSubject<List<Pokemon>>();
  final _pokemonHeightController = BehaviorSubject<List<Pokemon>>();
  final _searchedPokemonController = BehaviorSubject<String>();
  final _loadingPokemonsController = BehaviorSubject<bool>();
  final _filterPokemonController = BehaviorSubject<Map<String, bool>>();
  final _filterModeController = BehaviorSubject<int>();
  final _pokemonDetailController = BehaviorSubject<Pokemon>();

  /// Pokedex Controller
  List<Pokemon> get pokedex => _pokedexController.value;
  Stream<List<Pokemon>> get pokedexStream =>
      _pokedexController.stream.transform(
        StreamTransformer<List<Pokemon>, List<Pokemon>>.fromHandlers(
          handleData: _handlePokedexData,
        ),
      );
  Function(List<Pokemon>) get pokedexAddList => _pokedexController.sink.add;
  Function(String) get pokedexAddError => _pokedexController.sink.addError;

  Function(Pokemon) get addPokemon =>
      (Pokemon pokemon) => pokedexAddList(pokedex..add(pokemon));
  Function() get clearPokedex => () => pokedexAddList([]);

  /// Pokemon Height Controller
  List<Pokemon> get pokemonHeigh => _pokemonHeightController.value;
  Stream<List<Pokemon>> get pokemonHeightStream =>
      _pokemonHeightController.stream;
  Function(String) get addErrorPokemonHeight =>
      _pokemonHeightController.sink.addError;
  Function(List<Pokemon>) get pokemonHeightAddList =>
      _pokemonHeightController.sink.add;
  Function(List<Pokemon>) get addPokemonListHeight =>
      _pokemonHeightController.sink.add;
  Function() get clearPokemonHeight => pokemonHeightAddList([]);

  Function(Pokemon) get removePokemonHeight => (Pokemon pokemon) =>
      _pokemonHeightController.sink.add(pokemonHeigh..remove(pokemon));

  /// Pokemon Detail Controller
  Pokemon get pokemonDetail => _pokemonDetailController.value;
  Stream<Pokemon> get pokemonDetailStream => _pokemonDetailController.stream;
  Function(Pokemon) get addPokemonDetail => _pokemonDetailController.sink.add;
  Function(String) get addPokemonDetailError =>
      _pokemonDetailController.sink.addError;
  Function() get clearPokemonDetail => () => addPokemonDetail(null);

  /// Search Pokemon Controller
  Stream<String> get searchedPokemonStream => _searchedPokemonController.stream;
  String get searchedPokemon => _searchedPokemonController.value;
  Function(String) get onChangeSearchedPokemon =>
      _searchedPokemonController.sink.add;
  Function(String) get onChangeSearchedPokemonError =>
      _searchedPokemonController.sink.addError;

  /// Loading Pokemon Controller
  Stream<bool> get loadingPokemonsStream => _loadingPokemonsController.stream;
  Function(bool) get isLoading => _loadingPokemonsController.sink.add;
  bool get loading => _loadingPokemonsController.value;

  /// Filter Pokemon Controller
  Stream<Map<String, bool>> get filterTypes => _filterPokemonController.stream;
  Map<String, bool> get filter => _filterPokemonController.value;
  Function(Map<String, bool>) get addFilter =>
      _filterPokemonController.sink.add;

  /// Filter Mode Controller
  Stream<int> get filterModeStream => _filterModeController.stream;
  int get filterMode => _filterModeController.value;
  Function(int) get changeFilterMode => _filterModeController.sink.add;

  void dispose() {
    _pokedexController.close();
    _searchedPokemonController.close();
    _loadingPokemonsController.close();
    _filterPokemonController.close();
    _filterModeController.close();
    _pokemonHeightController.close();
    _pokemonDetailController.close();
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
    } else if (filterByTypes.isNotEmpty ||
        (searchedPokemon != null && searchedPokemon.isNotEmpty)) {
      sink.addError("Pokemon list is empty");
    }
  }

  void clearFilter() {
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
    this.changeFilterMode(filterModeInclusive);
  }
}
