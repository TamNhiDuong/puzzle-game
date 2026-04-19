import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/tile.dart';

class PuzzleBoard extends StatefulWidget {
  final int rows;
  final int cols;
  final String? assetImage;
  final Uint8List? imageBytes;
  final VoidCallback onCompleted;

  const PuzzleBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.onCompleted,
    this.assetImage,
    this.imageBytes,
  });

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  late List<Tile> tiles;

  @override
  void initState() {
    super.initState();
    _initTiles();
  }

  void _initTiles() {
    final total = widget.rows * widget.cols;
    final indexes = List<int>.generate(total, (i) => i)..shuffle(Random());

    tiles = List.generate(
      total,
      (i) => Tile(
        correctIndex: i,
        shownIndex: indexes[i],
      ),
    );
  }

  void _swap(int from, int to) {
    setState(() {
      final temp = tiles[from].shownIndex;
      tiles[from].shownIndex = tiles[to].shownIndex;
      tiles[to].shownIndex = temp;
    });

    final completed = tiles.every((tile) => tile.isCorrect);
    if (completed) {
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = min(constraints.maxWidth, constraints.maxHeight);

        return SizedBox(
          width: boardSize,
          height: boardSize,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.cols,
            ),
            itemBuilder: (context, index) {
              final tile = tiles[index];

              return DragTarget<int>(
                onAcceptWithDetails: (details) {
                  _swap(details.data, index);
                },
                builder: (context, candidateData, rejectedData) {
                  return Draggable<int>(
                    data: index,
                    feedback: SizedBox(
                      width: boardSize / widget.cols,
                      height: boardSize / widget.rows,
                      child: Material(
                        color: Colors.transparent,
                        child: _buildTile(tile),
                      ),
                    ),
                    childWhenDragging: Container(
                      margin: const EdgeInsets.all(1),
                      color: Colors.grey.shade300,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      child: _buildTile(tile),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTile(Tile tile) {
    final row = tile.shownIndex ~/ widget.cols;
    final col = tile.shownIndex % widget.cols;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = constraints.maxWidth;
        final tileHeight = constraints.maxHeight;

        final fullImageWidth = tileWidth * widget.cols;
        final fullImageHeight = tileHeight * widget.rows;

        final imageWidget = widget.imageBytes != null
            ? Image.memory(
                widget.imageBytes!,
                width: fullImageWidth,
                height: fullImageHeight,
                fit: BoxFit.cover,
              )
            : Image.asset(
                widget.assetImage!,
                width: fullImageWidth,
                height: fullImageHeight,
                fit: BoxFit.cover,
              );

        return ClipRect(
          child: Stack(
            children: [
              Positioned(
                left: -col * tileWidth,
                top: -row * tileHeight,
                child: imageWidget,
              ),
            ],
          ),
        );
      },
    );
  }
}
