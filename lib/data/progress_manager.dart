import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'content.dart';

class ProgressManager {
  static const String progressKey = 'flashlingo_completed_levels';
  static const String levelScoresKey = 'flashlingo_level_scores';

  final SharedPreferences _prefs;
  late List<String> _cachedCompletedLevels;
  late Map<String, int> _cachedLevelScores;

  ProgressManager(this._prefs) {
    _cachedCompletedLevels = _loadCompletedLevels();
    _cachedLevelScores = _loadLevelScores();
  }

  static Future<ProgressManager> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressManager(prefs);
  }

  List<String> _loadCompletedLevels() {
    final str = _prefs.getString(progressKey);
    if (str == null) return [];
    try {
      return List<String>.from(jsonDecode(str));
    } catch (_) {
      return [];
    }
  }

  Map<String, int> _loadLevelScores() {
    final str = _prefs.getString(levelScoresKey);
    if (str == null) return {};
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, value as int));
    } catch (_) {
      return {};
    }
  }

  List<String> getCompletedLevels() {
    return List.unmodifiable(_cachedCompletedLevels);
  }

  Map<String, int> getLevelScores() {
    return Map.unmodifiable(_cachedLevelScores);
  }

  int getLevelScore(String categoryId) {
    return _cachedLevelScores[categoryId] ?? 0;
  }

  bool hasStoredLevelScore(String categoryId) {
    return _cachedLevelScores.containsKey(categoryId);
  }

  bool hasPassedLevel(String categoryId) {
    if (getLevelScore(categoryId) >= 7) return true;
    return _cachedCompletedLevels.contains(categoryId) && !hasStoredLevelScore(categoryId);
  }

  Future<void> markLevelCompleted(String categoryId, int score) async {
    if (score < 7) return;
    if (!_cachedCompletedLevels.contains(categoryId)) {
      _cachedCompletedLevels.add(categoryId);
      await _prefs.setString(progressKey, jsonEncode(_cachedCompletedLevels));
    }
  }

  Future<void> saveLevelScore(String categoryId, int score) async {
    final currentScore = _cachedLevelScores[categoryId] ?? 0;
    if (score > currentScore) {
      _cachedLevelScores[categoryId] = score;
      await _prefs.setString(levelScoresKey, jsonEncode(_cachedLevelScores));
    }
  }

  int starsFromScore(int score) {
    if (score >= 9) return 3;
    if (score >= 8) return 2;
    if (score >= 7) return 1;
    return 0;
  }

  int getLevelStars(String categoryId) {
    if (hasStoredLevelScore(categoryId)) {
      return starsFromScore(getLevelScore(categoryId));
    }
    return getCompletedLevels().contains(categoryId) ? 1 : 0;
  }

  int getTotalStars() {
    int sum = 0;
    for (var cat in categoriesData) {
      sum += getLevelStars(cat.id);
    }
    return sum;
  }

  bool isComingSoonLevel(String categoryId) {
    return vocabularyData[categoryId]?.isEmpty ?? true;
  }

  String? getPreviousRealLevelId(String categoryId) {
    final index = categoriesData.indexWhere((c) => c.id == categoryId);
    if (index <= 0) return null;

    for (int i = index - 1; i >= 0; i--) {
      final prevId = categoriesData[i].id;
      if (!isComingSoonLevel(prevId)) return prevId;
    }
    return null;
  }

  static const String assignedGamePrefix = 'flashlingo_assigned_game_';

  String? getAssignedGame(String categoryId) {
    return _prefs.getString('$assignedGamePrefix$categoryId');
  }

  Future<void> setAssignedGame(String categoryId, String gameType) async {
    await _prefs.setString('$assignedGamePrefix$categoryId', gameType);
  }

  String getOrAssignGameForLevel(String categoryId) {
    final existing = getAssignedGame(categoryId);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final games = ['drag', 'scramble', 'pick'];
    games.shuffle();
    final picked = games.first;
    setAssignedGame(categoryId, picked);
    return picked;
  }

  Future<void> clearAssignedGame(String categoryId) async {
    await _prefs.remove('$assignedGamePrefix$categoryId');
  }

  bool isLevelUnlocked(String categoryId) {
    if (categoryId == 'B1') return true;
    final prevId = getPreviousRealLevelId(categoryId);
    if (prevId == null) return true;
    return hasPassedLevel(prevId);
  }
}
