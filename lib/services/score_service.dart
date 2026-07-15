import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/score_record.dart';

class ScoreService {
  static const String _scoresKey = 'score_history';

  Future<List<ScoreRecord>> loadScores() async {
    final preferences = await SharedPreferences.getInstance();
    final savedScores = preferences.getStringList(_scoresKey) ?? [];

    final scores = <ScoreRecord>[];

    for (final savedScore in savedScores) {
      try {
        final decodedScore = jsonDecode(savedScore) as Map<String, dynamic>;
        scores.add(ScoreRecord.fromJson(decodedScore));
      } catch (_) {
        // Ignore damaged score entries instead of crashing the app.
      }
    }

    return scores;
  }

  Future<void> saveScore(ScoreRecord scoreRecord) async {
    final preferences = await SharedPreferences.getInstance();
    final savedScores = preferences.getStringList(_scoresKey) ?? [];

    savedScores.add(
      jsonEncode(scoreRecord.toJson()),
    );

    await preferences.setStringList(_scoresKey, savedScores);
  }
}