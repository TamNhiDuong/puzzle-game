import 'package:flutter/material.dart';
import '../models/level.dart';
import '../services/progress_service.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  final progressService = ProgressService();
  int highestUnlocked = 1;
  List<int> completed = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final unlocked = await progressService.getHighestUnlockedLevel();
    final done = await progressService.getCompletedLevels();
    setState(() {
      highestUnlocked = unlocked;
      completed = done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Level')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 700;

                  return GridView.builder(
                    itemCount: levels.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: wide ? 3 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.7,
                    ),
                    itemBuilder: (context, index) {
                      final level = levels[index];
                      final unlocked = level.id <= highestUnlocked;
                      final isCompleted = completed.contains(level.id);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Level ${level.id}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('${level.rows} x ${level.cols}'),
                              const SizedBox(height: 8),
                              if (isCompleted) const Text('Completed ✅'),
                              if (!unlocked) const Text('Locked 🔒'),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: unlocked
                                    ? () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                GameScreen.level(level: level),
                                          ),
                                        );
                                        _load();
                                      }
                                    : null,
                                child: const Text('Play'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
