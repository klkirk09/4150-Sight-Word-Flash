import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/score_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final ScoreService scoreService = ScoreService();

  late Future<List<ScoreRecord>> scoresFuture;

  @override
  void initState() {
    super.initState();
    scoresFuture = scoreService.loadScores();
  }

  int _calculateAverage(List<ScoreRecord> scores) {
    if (scores.isEmpty) {
      return 0;
    }

    final total = scores.fold<int>(
      0,
          (sum, record) => sum + record.score,
    );

    return (total / scores.length).round();
  }

  int _calculateBest(List<ScoreRecord> scores) {
    if (scores.isEmpty) {
      return 0;
    }

    return scores
        .map((record) => record.score)
        .reduce((current, next) => current > next ? current : next);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ScoreRecord>>(
        future: scoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Stats could not be loaded.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }

          final scores = snapshot.data ?? [];

          if (scores.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 90,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Play a round to see your stats!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final averageScore = _calculateAverage(scores);
          final bestScore = _calculateBest(scores);
          final newestFirst = scores.reversed.toList();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Rounds',
                          value: '${scores.length}',
                          icon: Icons.sports_esports,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Average',
                          value: '$averageScore%',
                          icon: Icons.insights,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Best',
                          value: '$bestScore%',
                          icon: Icons.emoji_events,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Score History',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: newestFirst.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final record = newestFirst[index];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${record.score}%'),
                            ),
                            title: Text(record.level),
                            subtitle: Text(
                              '${record.firstTryCorrect} of '
                                  '${record.totalWords} first try'
                                  ' • ${_formatDate(record.completedAt)}',
                            ),
                            trailing: const Icon(Icons.flash_on),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        child: Column(
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}