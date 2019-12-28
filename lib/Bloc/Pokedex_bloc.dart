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

  PokedexBloc._() {
    _filterPokemonController.sink.add({
      "Water": false,
      "Fire": false,
      "Grass": false,
      "Ground": false,
      "Electric": false,
    });
  }

  final _pokedexController = BehaviorSubject<List<Pokemon>>();
  final _searchedPokemonController = BehaviorSubject<String>();
  final _loadingPokemonsController = BehaviorSubject<bool>();
  final _filterPokemonController = BehaviorSubject<Map<String, bool>>();

  Stream<String> get searchedPokemonStream => _searchedPokemonController.stream;
  Stream<bool> get loadingPokemonsStream => _loadingPokemonsController.stream;
  Stream<List<Pokemon>> get pokedexStream =>
      _pokedexController.stream.transform(
        StreamTransformer<List<Pokemon>, List<Pokemon>>.fromHandlers(
          handleData: (List<Pokemon> pokedex, sink) {
            print("HERE !!!");
            if (pokedex == null) return;
            List<Pokemon> filterPokedex = pokedex;

            /// Serach about a concept
            if (searchedPokemon != null && searchedPokemon.isNotEmpty) {
              filterPokedex = filterPokedex
                  .where((Pokemon poke) => poke.name
                      .toLowerCase()
                      .contains(searchedPokemon.toLowerCase()))
                  .toList();
            }

            print("Start with: " + filterPokedex.length.toString());
            filter.forEach((String type, bool available) {
              if (available) {
                filterPokedex = filterPokedex.where((Pokemon poke) {
                  bool isType1 = type.toLowerCase().contains(poke.type1);

                  bool isType2 = (poke.type2.isEmpty)
                      ? false
                      : type.toLowerCase().contains(poke.type2);

                  return isType1 || isType2;
                }).toList();
              }
            });
            print("End with: " + filterPokedex.length.toString());

            if (filterPokedex.isNotEmpty) {
              sink.add(filterPokedex);
            } else {
              sink.addError("Pokemon no found");
            }
          },
        ),
      );

  Function(bool) get isLoading => _loadingPokemonsController.sink.add;
  Function(Map<String, bool>) get addFilter =>
      _filterPokemonController.sink.add;

  Function(List<Pokemon>) get addPokedex => _pokedexController.sink.add;
  Function(String) get addPokedexError => _pokedexController.sink.addError;

  Function(String) get onChangeSearchedPokemon =>
      _searchedPokemonController.sink.add;
  Function(String) get onChangeSearchedPokemonError =>
      _searchedPokemonController.sink.addError;

  List<Pokemon> get pokedex => _pokedexController.value;
  String get searchedPokemon => _searchedPokemonController.value;
  bool get loading => _loadingPokemonsController.value;
  Map<String, bool> get filter => _filterPokemonController.value;

  void dispose() {
    _pokedexController.close();
    _searchedPokemonController.close();
    _loadingPokemonsController.close();
    _filterPokemonController.close();
  }
}
