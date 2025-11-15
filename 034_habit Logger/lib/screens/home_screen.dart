import 'package:flutter/material.dart';
import '../services/habit_service.dart';
import '../models/habit.dart';
import '../widgets/habit_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/progress_chart.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HabitService _habitService = HabitService();

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Habit Logger',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              _showStatsDialog(context);
            },
          ),
        ],
      ),
      body: _habitService.habits.isEmpty
          ? const EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _habitService.habits.length,
              itemBuilder: (context, index) {
                final habit = _habitService.habits[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: Key(habit.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _habitService.removeHabit(habit.id);
                      _refresh();
                    },
                    child: HabitCard(
                      habit: habit,
                      onToggle: () {
                        _habitService.toggleHabitCompletion(habit.id);
                        _refresh();
                      },
                      onDelete: () {
                        _habitService.removeHabit(habit.id);
                        _refresh();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHabitScreen(
                onHabitAdded: (habit) {
                  _habitService.addHabit(habit);
                  _refresh();
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Progress'),
        content: SizedBox(
          width: double.maxFinite,
          child: ProgressChart(habits: _habitService.habits),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}