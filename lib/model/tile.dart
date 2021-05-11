class Tile {
  final _imageIndex;
  TileState state;

  Tile(int imageIndex)
      : _imageIndex = imageIndex,
        state = TileState.hidden;

  int get imageIndex => _imageIndex;

}

enum TileState { hidden, selected, solved }