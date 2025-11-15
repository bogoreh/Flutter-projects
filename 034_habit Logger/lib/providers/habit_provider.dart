import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void removeHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  void toggleHabitCompletion(String id) {
    final habitIndex = _habits.indexWhere((habit) => habit.id == id);
    if (habitIndex != -1) {
      final habit = _habits[habitIndex];
      final now = DateTime.now();
      
      if (habit.isCompletedToday()) {
        // Remove today's completion
        habit.completedDates.removeWhere((date) => 
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day
        );
        habit.currentStreak = _calculateCurrentStreak(habit);
      } else {
        // Add today's completion
        habit.completedDates.add(DateTime(now.year, now.month, now.day));
        habit.currentStreak = _calculateCurrentStreak(habit);
      }
      
      notifyListeners();
    }
  }

  int _calculateCurrentStreak(Habit habit) {
    if (habit.completedDates.isEmpty) return 0;
    
    final sortedDates = List<DateTime>.from(habit.completedDates)..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (int i = 0; i < sortedDates.length; i++) {
      final completedDate = DateTime(sortedDates[i].year, sortedDates[i].month, sortedDates[i].day);
      final expectedDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
      
      if (completedDate.isAtSameMomentAs(expectedDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  void updateHabit(String id, Habit updatedHabit) {
    final habitIndex = _habits.indexWhere((habit) => habit.id == id);
    if (habitIndex != -1) {
      _habits[habitIndex] = updatedHabit;
      notifyListeners();
    }
  }
}