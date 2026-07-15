import 'dart:math';

import 'package:flutter/material.dart';

import '../data/dolch_words.dart';
import '../models/score_record.dart';
import '../services/score_service.dart';
import 'results_screen.dart';

class GameScreen extends StatefulWidget {
  final String level;

  const GameScreen({
    super.key,
    required this.level,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final List<String> originalWords;
  late final List<String> wordQueue;

  final Set<String> practicedWords = {};
  final ScoreService scoreService = ScoreService();

  int clearedWords = 0;
  int firstTryCorrect = 0;
  bool isProcessingTap = false;

  @override
  void initState() {
    super.initState();

    final words = DolchWords.getWordsForLevel(widget.level);
    words.shuffle(Random());

    originalWords = words.take(10).toList();
    wordQueue = List<String>.from(originalWords);
  }

  Future<void> _handleKnowIt() async {
    if (isProcessingTap || wordQueue.isEmpty) {
      return;
    }

    isProcessingTap = true;

    final currentWord = wordQueue.first;

    if (!practicedWords.contains(currentWord)) {
      firstTryCorrect++;
    }

    setState(() {
      wordQueue.removeAt(0);
      clearedWords++;
    });

    if (wordQueue.isEmpty) {
      await _showRoundComplete();
      return;
    }

    if (mounted) {
      setState(() {
        isProcessingTap = false;
      });
    }
  }

  void _handlePracticeAgain() {
    if (isProcessingTap || wordQueue.isEmpty) {
      return;
    }

    isProcessingTap = true;

    final currentWord = wordQueue.removeAt(0);
    practicedWords.add(currentWord);
    wordQueue.add(currentWord);

    setState(() {
      isProcessingTap = false;
    });
  }

  Future<void> _showRoundComplete() async {
    final score = ((firstTryCorrect / originalWords.length) * 100).round();

    final scoreRecord = ScoreRecord(
      gameType: 'Flash Dash',
      level: widget.level,
      score: score,
      firstTryCorrect: firstTryCorrect,
      totalWords: originalWords.length,
      completedAt: DateTime.now(),
    );

    await scoreService.saveScore(scoreRecord);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          level: widget.level,
          score: score,
          firstTryCorrect: firstTryCorrect,
          totalWords: originalWords.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = wordQueue.isEmpty ? '' : wordQueue.first;
    final progress = clearedWords / originalWords.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEBFF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 16,
                        backgroundColor: Colors.white,
                        color: const Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$clearedWords of ${originalWords.length} cleared',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF302B63),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 64,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7B68EE),
                      Color(0xFF9C88FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.yellow,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentWord,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: FilledButton.icon(
                  onPressed: isProcessingTap ? null : _handleKnowIt,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF51CF66),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor:
                    const Color(0xFF51CF66).withValues(alpha: 0.4),
                  ),
                  icon: const Icon(
                    Icons.check_circle_rounded,
                    size: 34,
                  ),
                  label: const Text(
                    'I Know It!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: FilledButton.icon(
                  onPressed:
                  isProcessingTap ? null : _handlePracticeAgain,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA94D),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor:
                    const Color(0xFFFFA94D).withValues(alpha: 0.4),
                  ),
                  icon: const Icon(
                    Icons.replay_rounded,
                    size: 34,
                  ),
                  label: const Text(
                    'Practice Again',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}