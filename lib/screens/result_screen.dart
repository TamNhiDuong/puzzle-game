import 'package:flutter/material.dart';
import 'level_select_screen.dart';
import 'start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int? levelId;
  final bool isCustom;

  const ResultScreen({
    super.key,
    required this.levelId,
    required this.isCustom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Puzzle Completed!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(isCustom
                      ? 'Great job on your custom puzzle.'
                      : 'Level $levelId completed.'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => isCustom
                              ? const StartScreen()
                              : const LevelSelectScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(isCustom ? 'Back to Start' : 'Back to Levels'),
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
