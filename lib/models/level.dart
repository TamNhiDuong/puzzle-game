class Level {
  final int id;
  final int rows;
  final int cols;
  final String? assetImage;
  final bool isCustom;

  const Level({
    required this.id,
    required this.rows,
    required this.cols,
    this.assetImage,
    this.isCustom = false,
  });
}

const levels = [
  Level(id: 1, rows: 2, cols: 2, assetImage: 'assets/images/puzzle1.jpg'),
  Level(id: 2, rows: 2, cols: 3, assetImage: 'assets/images/puzzle2.jpg'),
  Level(id: 3, rows: 3, cols: 3, assetImage: 'assets/images/puzzle3.jpg'),
];
