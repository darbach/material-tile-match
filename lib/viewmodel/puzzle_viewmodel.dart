import 'dart:async';
import 'dart:math';

import '../model/puzzle.dart';
import '../model/tile.dart';

class PuzzleViewModel {
  static const int _size = 28; // number of puzzle tiles
  static const _defaultDuration = Duration(milliseconds: 500);
  static const int _reveal = 3000; // milliseconds

  final _tileListStreamController;
  final _moveCountStreamController;
  final _matchCountStreamController;
  final _tickStreamController;
  final _rng;

  late Puzzle _puzzle;
  Timer? _tickTimer;
  Timer? _revealTimer;

  PuzzleViewModel()
      : _tileListStreamController = StreamController<List<Tile>>(),
        _moveCountStreamController = StreamController<int>(),
        _matchCountStreamController = StreamController<int>(),
        _tickStreamController = StreamController<int>(),
        _rng = Random.secure();

  Stream<List<Tile>> get tileListStream => _tileListStreamController.stream;

  Stream<int> get moveCountStream => _moveCountStreamController.stream;

  Stream<int> get matchCountStream => _matchCountStreamController.stream;

  Stream<int> get tickStream => _tickStreamController.stream;

  newPuzzle(int imagePoolSize, [Duration tickInterval = _defaultDuration]) {
    _puzzle = Puzzle(_size, imagePoolSize, _rng);
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(
        tickInterval,
            (timer) => _tickStreamController
                .add(tickInterval.inMilliseconds * timer.tick));
  }

  select(int tileIndex) {
    PuzzleState previous = _puzzle.state;
    _puzzle.select(tileIndex);
    if (_puzzle.state != previous) {
      _tileListStreamController.add(_puzzle.tiles);
      _moveCountStreamController.add(_puzzle.moves);
      _matchCountStreamController.add(_puzzle.matches);
      if (_puzzle.state == PuzzleState.revealing) {
        _revealTimer?.cancel();
        _revealTimer = Timer(Duration(milliseconds: _reveal), () => _unreveal());
      }
    }
  }

  _unreveal() {
    _puzzle.unreveal();
    _tileListStreamController.add(_puzzle.tiles);
    _moveCountStreamController.add(_puzzle.moves);
  }

}