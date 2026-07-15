import 'dart:async';
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
  static const int secondsPerWord = 10;

  late final List<String> originalWords;
  late final List<String> wordQueue;

  final Set<String> practicedWords = {};
  final ScoreService scoreService = ScoreService();

  Timer? wordTimer;

  int secondsRemaining = secondsPerWord;
  int clearedWords = 0;
  int firstTryCorrect = 0;

  bool isProcessingTap = false;
  bool roundComplete = false;

  @override
  void initState() {
    super.initState();

    final words = DolchWords.getWordsForLevel(widget.level);
    words.shuffle(Random());

    originalWords = words.take(10).toList();
    wordQueue = List<String>.from(originalWords);

    _startWordTimer();
  }

  void _startWordTimer() {
    wordTimer?.cancel();

    secondsRemaining = secondsPerWord;

    wordTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted || roundComplete) {
          timer.cancel();
          return;
        }

        if (secondsRemaining > 1) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          timer.cancel();
          _handleTimeExpired();
        }
      },
    );
  }

  Future<void> _handleKnowIt() async {
    if (isProcessingTap || wordQueue.isEmpty || roundComplete) {
      return;
    }

    isProcessingTap = true;
    wordTimer?.cancel();

    final currentWord = wordQueue.first;

    if (!practicedWords.contains(currentWord)) {
      firstTryCorrect++;
    }

    setState(() {
      wordQueue.removeAt(0);
      clearedWords++;
    });

    if (wordQueue.isEmpty) {
      roundComplete = true;
      await _showRoundComplete();
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isProcessingTap = false;
    });

    _startWordTimer();
  }

  void _handlePracticeAgain() {
    if (isProcessingTap || wordQueue.isEmpty || roundComplete) {
      return;
    }

    isProcessingTap = true;
    wordTimer?.cancel();

    _moveCurrentWordToBack();
  }

  void _handleTimeExpired() {
    if (isProcessingTap || wordQueue.isEmpty || roundComplete) {
      return;
    }

    isProcessingTap = true;

    _moveCurrentWordToBack();
  }

  void _moveCurrentWordToBack() {
    final currentWord = wordQueue.removeAt(0);

    practicedWords.add(currentWord);
    wordQueue.add(currentWord);

    if (!mounted) {
      return;
    }

    setState(() {
      isProcessingTap = false;
      secondsRemaining = secondsPerWord;
    });

    _startWordTimer();
  }

  Future<void> _showRoundComplete() async {
    wordTimer?.cancel();

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
  void dispose() {
    wordTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = wordQueue.isEmpty ? '' : wordQueue.first;
    final roundProgress = clearedWords / originalWords.length;
    final timerProgress = secondsRemaining / secondsPerWord;

    final timerColor = secondsRemaining <= 3
        ? const Color(0xFFFF6B6B)
        : const Color(0xFFFFA94D);

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
                        value: roundProgress,
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
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: timerColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: timerColor,
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_rounded,
                          color: timerColor,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$secondsRemaining seconds',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: timerColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: timerProgress,
                        minHeight: 10,
                        backgroundColor: Colors.white,
                        color: timerColor,
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
                      color: const Color(
                        0xFF6C63FF,
                      ).withValues(alpha: 0.3),
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
                    shadowColor: const Color(
                      0xFF51CF66,
                    ).withValues(alpha: 0.4),
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
                    shadowColor: const Color(
                      0xFFFFA94D,
                    ).withValues(alpha: 0.4),
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