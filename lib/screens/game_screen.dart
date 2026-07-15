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
  late final List<String> roundWords;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    final words = DolchWords.getWordsForLevel(widget.level);
    words.shuffle(Random());

    roundWords = words.take(10).toList();
  }

  void _goToNextWord() {
    if (currentIndex >= roundWords.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Round complete'),
        ),
      );
      return;
    }

    setState(() {
      currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = roundWords[currentIndex];

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
                value: (currentIndex + 1) / roundWords.length,
              ),
              const SizedBox(height: 12),
              Text(
                '${currentIndex + 1} of ${roundWords.length}',
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
                child: FilledButton(
                  onPressed: _goToNextWord,
                  child: const Text(
                    'Next Word',
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