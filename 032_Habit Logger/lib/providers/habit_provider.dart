import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(String title, String description, int targetDays, Color color) {
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      targetDays: targetDays,
      createdDate: DateTime.now(),
      color: color,
    );
    _habits.add(habit);
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  void toggleHabitCompletion(String id) {
    final habitIndex = _habits.indexWhere((h) => h.id == id);
    if (habitIndex == -1) return;

    final habit = _habits[habitIndex];
    final now = DateTime.now();
    
    if (habit.isCompletedToday()) {
      habit.completedDates.removeWhere((date) =>
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day);
      habit.currentStreak = _calculateCurrentStreak(habit.completedDates);
    } else {
      habit.completedDates.add(now);
      habit.currentStreak = _calculateCurrentStreak(habit.completedDates);
    }
    notifyListeners();
  }

  int _calculateCurrentStreak(List<DateTime> completedDates) {
    if (completedDates.isEmpty) return 0;
    
    completedDates.sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (int i = 0; i < completedDates.length; i++) {
      final completedDate = completedDates[i];
      if (_isConsecutiveDay(completedDate, currentDate)) {
        streak++;
        currentDate = completedDate;
      } else {
        break;
      }
    }
    
    return streak;
  }

  bool _isConsecutiveDay(DateTime date1, DateTime date2) {
    final difference = date2.difference(date1).inDays;
    return difference == 1 || (difference == 0 && date1.day == date2.day);
  }
}