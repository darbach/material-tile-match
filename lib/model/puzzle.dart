import 'dart:math';

import 'tile.dart';

class Puzzle {
  final List<int> _selections;
  final int size;
  late final List<Tile> tiles;
  PuzzleState _state;
  int _moves;
  int _matches;
  Tile? _selection;

  Puzzle(this.size, int imagePoolSize, [Random? rng])
      : _selections = List.empty(growable: true),
        _state = PuzzleState.inProgress,
        _moves = 0,
        _matches = 0 {
    final pool = List.generate(imagePoolSize, (index) => index);
    pool.shuffle(rng);
    final rawTiles = pool
        .sublist(0, (size / 2).floor())
        .expand((index) => [Tile(index), Tile(index)])
        .toList(growable: false);
    rawTiles.shuffle(rng);
    tiles = List.unmodifiable(rawTiles);
  }

  List<int> get selections => List.unmodifiable(_selections);

  PuzzleState get state => _state;

  int get moves => _moves;

  int get matches => _matches;

  select(int position) {
    _selections.add(position);
    final tile = tiles[position];
    if (tile.state == TileState.hidden) {
      switch (_state) {
        case PuzzleState.inProgress:
          _state = PuzzleState.guessing;
          tile.state = TileState.selected;
          _selection = tile;
          break;
        case PuzzleState.guessing:
          _moves++;
          _state = PuzzleState.revealing;
          tile.state = TileState.selected;
          if (_selection?.imageIndex == tile.imageIndex) {
            _matches++;
            _state = (_matches / 2 >= size)
                ? PuzzleState.completed
                : PuzzleState.inProgress;
            tile.state = TileState.solved;
            _selection!.state = TileState.solved;
          }
          _selection = null;
          break;
        case PuzzleState.revealing:
        // Fall-through.
        case PuzzleState.completed:
          // Ignore the selection.
          break;
      }
    }
  }

  unreveal() {
    if (_state == PuzzleState.revealing) {
      tiles
          .where((tile) => tile.state == TileState.selected)
          .forEach((tile) => tile.state = TileState.hidden);
      _state = PuzzleState.inProgress;
    }
  }
}

enum PuzzleState { inProgress, guessing, revealing, completed }
