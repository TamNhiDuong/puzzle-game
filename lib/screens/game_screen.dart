import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/level.dart';
import '../services/progress_service.dart';
import '../widgets/puzzle_board.dart';
import 'result_screen.dart';

class GameScreen extends StatelessWidget {
  final Level? level;
  final Uint8List? imageBytes;
  final int rows;
  final int cols;
  final bool isCustom;

  const GameScreen.level({
    super.key,
    required this.level,
  })  : imageBytes = null,
        rows = 0,
        cols = 0,
        isCustom = false;

  const GameScreen.custom({
    super.key,
    required this.imageBytes,
    required this.rows,
    required this.cols,
  })  : level = null,
        isCustom = true;

  Future<void> _complete(BuildContext context) async {
    if (!isCustom && level != null) {
      await ProgressService().completeLevel(level!.id);
    }

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          levelId: level?.id,
          isCustom: isCustom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = isCustom ? 'Custom Puzzle' : 'Level ${level!.id}';
    final boardRows = isCustom ? rows : level!.rows;
    final boardCols = isCustom ? cols : level!.cols;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: PuzzleBoard(
                      rows: boardRows,
                      cols: boardCols,
                      assetImage: level?.assetImage,
                      imageBytes: imageBytes,
                      onCompleted: () => _complete(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
