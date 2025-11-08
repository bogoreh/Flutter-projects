import 'package:flutter/material.dart';
import '../models/habit.dart';

class ProgressChart extends StatelessWidget {
  final Habit habit;
  final bool showTitle;

  const ProgressChart({
    super.key,
    required this.habit,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    color: habit.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    habit.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            // Progress Overview
            _buildProgressOverview(),
            const SizedBox(height: 16),
            // Weekly Calendar View
            _buildWeeklyCalendar(),
            const SizedBox(height: 16),
            // Streak Information
            _buildStreakInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Overview',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: habit.progress,
                backgroundColor: Colors.grey.shade200,
                color: habit.color,
                borderRadius: BorderRadius.circular(10),
                minHeight: 12,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${(habit.progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: habit.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${habit.currentStreak} of ${habit.targetDays} days completed',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendar() {
    final now = DateTime.now();
    final daysInWeek = 7;
    final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This Week',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(daysInWeek, (index) {
            final dayOffset = index - now.weekday;
            final date = DateTime(now.year, now.month, now.day + dayOffset);
            final isCompleted = habit.completedDates.any((completedDate) =>
                completedDate.year == date.year &&
                completedDate.month == date.month &&
                completedDate.day == date.day);
            final isToday = date.day == now.day;

            return _buildDayIndicator(
              day: weekDays[index],
              date: date.day,
              isCompleted: isCompleted,
              isToday: isToday,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDayIndicator({
    required String day,
    required int date,
    required bool isCompleted,
    required bool isToday,
  }) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted
                ? habit.color
                : isToday
                    ? habit.color.withOpacity(0.2)
                    : Colors.grey.shade100,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: habit.color, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              date.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isCompleted
                    ? Colors.white
                    : isToday
                        ? habit.color
                        : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakInfo() {
    final longestStreak = _calculateLongestStreak();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          title: 'Current Streak',
          value: '${habit.currentStreak}',
          icon: Icons.local_fire_department,
          color: habit.currentStreak > 0 ? Colors.orange : Colors.grey,
        ),
        _buildStatItem(
          title: 'Longest Streak',
          value: '$longestStreak',
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
        _buildStatItem(
          title: 'Completion',
          value: '${(habit.progress * 100).toStringAsFixed(0)}%',
          icon: Icons.check_circle,
          color: habit.progress >= 1 ? Colors.green : Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  int _calculateLongestStreak() {
    if (habit.completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(habit.completedDates)
      ..sort((a, b) => a.compareTo(b));

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final previousDate = sortedDates[i - 1];
      final currentDate = sortedDates[i];
      final difference = currentDate.difference(previousDate).inDays;

      if (difference == 1) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
      } else if (difference > 1) {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }
}

// Compact version for use in lists
class CompactProgressChart extends StatelessWidget {
  final Habit habit;

  const CompactProgressChart({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Circular progress indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: habit.progress,
                    backgroundColor: Colors.grey.shade200,
                    color: habit.color,
                    strokeWidth: 4,
                  ),
                ),
                Text(
                  '${(habit.progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: habit.color,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Streak: ${habit.currentStreak} days',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: habit.progress,
                    backgroundColor: Colors.grey.shade200,
                    color: habit.color,
                    borderRadius: BorderRadius.circular(2),
                    minHeight: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}