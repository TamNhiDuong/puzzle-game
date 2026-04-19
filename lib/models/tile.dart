class Tile {
  final int correctIndex;
  int shownIndex;

  Tile({
    required this.correctIndex,
    required this.shownIndex,
  });

  bool get isCorrect => correctIndex == shownIndex;
}
