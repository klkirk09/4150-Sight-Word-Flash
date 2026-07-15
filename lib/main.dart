import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SightWordApp());
}

class SightWordApp extends StatelessWidget {
  const SightWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Dash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}