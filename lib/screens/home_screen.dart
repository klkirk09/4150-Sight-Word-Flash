import 'package:flutter/material.dart';
import '../data/dolch_words.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = DolchWords.levels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Dash'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stats screen coming later'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Stats',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.flash_on,
                size: 90,
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose a Level',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: levels.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final level = levels[index];

                    return SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(level: level),
                            ),
                          );
                        },
                        child: Text(
                          level,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}