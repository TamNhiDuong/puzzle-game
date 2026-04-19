import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _completedLevelsKey = 'completed_levels';
  static const _highestUnlockedKey = 'highest_unlocked_level';

  Future<List<int>> getCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedLevelsKey)?.map(int.parse).toList() ??
        [];
  }

  Future<int> getHighestUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestUnlockedKey) ?? 1;
  }

  Future<void> completeLevel(int levelId) async {
    final prefs = await SharedPreferences.getInstance();

    final completed = await getCompletedLevels();
    if (!completed.contains(levelId)) {
      completed.add(levelId);
      await prefs.setStringList(
        _completedLevelsKey,
        completed.map((e) => e.toString()).toList(),
      );
    }

    final highestUnlocked = await getHighestUnlockedLevel();
    if (levelId >= highestUnlocked && levelId < 3) {
      await prefs.setInt(_highestUnlockedKey, levelId + 1);
    }
  }
}
