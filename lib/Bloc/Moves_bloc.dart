import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../Model/Move.dart';

class MovesBloc {
  static MovesBloc _instance;

  factory MovesBloc() {
    if (_instance == null) {
      _instance = MovesBloc._();
    }

    return _instance;
  }

  MovesBloc._();

  final _movesController = BehaviorSubject<List<Move>>();

  List<Move> get moves => _movesController.value;
  Stream<List<Move>> get movesStream => _movesController.stream;
  Function(List<Move>) get movesAddList => _movesController.sink.add;
  Function(String) get movesAddError => _movesController.sink.addError;
  Function() get movesClearList => () => movesAddList(null);

  void dispose() {
    _movesController.close();
  }
}
