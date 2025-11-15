import 'package:flutter/material.dart';
import '../models/habit.dart';

class ProgressChart extends StatelessWidget {
  final List<Habit> habits;

  const ProgressChart({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const Center(
        child: Text('No habits to display'),
      );
    }

    final completedHabits = habits.where((habit) => habit.currentStreak > 0).length;
    final totalProgress = habits.isEmpty ? 0 : habits.map((h) => h.progress).reduce((a, b) => a + b) / habits.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatCard(
          'Overall Progress',
          '${(totalProgress * 100).toStringAsFixed(1)}%',
          Icons.trending_up,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          'Active Habits',
          '${habits.length}',
          Icons.list_alt,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          'Completed Today',
          '$completedHabits/${habits.length}',
          Icons.check_circle,
          Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildHabitProgressList(),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitProgressList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habit Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...habits.map((habit) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  habit.title,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: LinearProgressIndicator(
                  value: habit.progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(habit.color),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(habit.progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}