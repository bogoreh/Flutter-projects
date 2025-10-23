import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MatchScoreApp());
}

class MatchScoreApp extends StatelessWidget {
  const MatchScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Score',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}