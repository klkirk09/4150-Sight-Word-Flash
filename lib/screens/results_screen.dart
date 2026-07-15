import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final String level;
  final int score;
  final int firstTryCorrect;
  final int totalWords;

  const ResultsScreen({
    super.key,
    required this.level,
    required this.score,
    required this.firstTryCorrect,
    required this.totalWords,
  });

  @override
  Widget build(BuildContext context) {
    final practicedCount = totalWords - firstTryCorrect;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Round Results'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.emoji_events,
                size: 90,
              ),
              const SizedBox(height: 16),
              Text(
                '$score%',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                level,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              Text(
                '$firstTryCorrect of $totalWords known on the first try',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '$practicedCount words practiced again',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text(
                    'Play Again',
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
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                          (route) => route.isFirst,
                    );
                  },
                  icon: const Icon(Icons.home),
                  label: const Text(
                    'Home',
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