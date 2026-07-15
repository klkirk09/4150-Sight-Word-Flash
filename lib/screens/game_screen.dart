import 'dart:math';

import 'package:flutter/material.dart';
import '../data/dolch_words.dart';

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

  void _handleKnowIt() {
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
      isProcessingTap = false;
    });

    if (wordQueue.isEmpty) {
      _showRoundComplete();
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

  void _showRoundComplete() {
    final score = ((firstTryCorrect / originalWords.length) * 100).round();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Round complete: $score%',
        ),
        duration: const Duration(seconds: 2),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
              ),
              const SizedBox(height: 12),
              Text(
                '$clearedWords of ${originalWords.length} cleared',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 56,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  currentWord,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: FilledButton.icon(
                  onPressed: isProcessingTap ? null : _handleKnowIt,
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'I Know It',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: OutlinedButton.icon(
                  onPressed: isProcessingTap ? null : _handlePracticeAgain,
                  icon: const Icon(Icons.replay),
                  label: const Text(
                    'Practice Again',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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