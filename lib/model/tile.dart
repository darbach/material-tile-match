class Tile {
  final _pairId;
  TileState state;

  Tile(int pairId)
      : _pairId = pairId,
        state = TileState.hidden;

  int get pairId => _pairId;

}

enum TileState { hidden, selected, solved }