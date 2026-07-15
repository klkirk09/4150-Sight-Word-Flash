import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final String level;

  const GameScreen({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(level),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '$level game coming next',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}