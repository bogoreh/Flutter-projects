import 'package:flutter/material.dart';

class Habit {
  String id;
  String title;
  String description;
  int targetDays;
  int currentStreak;
  DateTime createdDate;
  List<DateTime> completedDates;
  Color color;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDays,
    this.currentStreak = 0,
    required this.createdDate,
    this.completedDates = const [],
    this.color = Colors.blue,
  });

  double get progress {
    if (targetDays == 0) return 0.0;
    return currentStreak / targetDays;
  }

  bool isCompletedToday() {
    final now = DateTime.now();
    return completedDates.any((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
  }
}