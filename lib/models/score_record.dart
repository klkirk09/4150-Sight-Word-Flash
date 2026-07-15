class ScoreRecord {
  final String gameType;
  final String level;
  final int score;
  final int firstTryCorrect;
  final int totalWords;
  final DateTime completedAt;

  const ScoreRecord({
    required this.gameType,
    required this.level,
    required this.score,
    required this.firstTryCorrect,
    required this.totalWords,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameType': gameType,
      'level': level,
      'score': score,
      'firstTryCorrect': firstTryCorrect,
      'totalWords': totalWords,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory ScoreRecord.fromJson(Map<String, dynamic> json) {
    return ScoreRecord(
      gameType: json['gameType'] as String,
      level: json['level'] as String,
      score: json['score'] as int,
      firstTryCorrect: json['firstTryCorrect'] as int,
      totalWords: json['totalWords'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}