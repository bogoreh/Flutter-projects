import 'package:flutter/material.dart';
import '../models/food_entry.dart';
import '../services/calorie_service.dart';
import '../widgets/calorie_card.dart';
import '../widgets/food_entry_item.dart';
import '../widgets/add_food_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CalorieService _calorieService = CalorieService();
  final List<FoodEntry> _foodEntries = [];

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    // Add some sample data for demonstration
    final sampleEntries = [
      FoodEntry(
        id: '1',
        name: 'Apple',
        calories: 95,
        date: DateTime.now(),
        description: 'Medium sized apple',
      ),
      FoodEntry(
        id: '2',
        name: 'Chicken Salad',
        calories: 320,
        date: DateTime.now(),
        description: 'Grilled chicken with greens',
      ),
    ];

    for (var entry in sampleEntries) {
      _calorieService.addFoodEntry(entry);
    }
    _updateFoodEntries();
  }

  void _updateFoodEntries() {
    setState(() {
      _foodEntries.clear();
      _foodEntries.addAll(_calorieService.foodEntries);
      _foodEntries.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _addFoodEntry(String name, int calories, String description) {
    final newEntry = FoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      calories: calories,
      date: DateTime.now(),
      description: description.isEmpty ? null : description,
    );

    _calorieService.addFoodEntry(newEntry);
    _updateFoodEntries();
    _showSnackBar('$name added successfully!');
  }

  void _editFoodEntry(FoodEntry entry, String name, int calories, String description) {
    final updatedEntry = entry.copyWith(
      name: name,
      calories: calories,
      description: description,
    );

    _calorieService.removeFoodEntry(entry.id);
    _calorieService.addFoodEntry(updatedEntry);
    _updateFoodEntries();
    _showSnackBar('$name updated successfully!');
  }

  void _deleteFoodEntry(String id) {
    final entry = _foodEntries.firstWhere((e) => e.id == id);
    _calorieService.removeFoodEntry(id);
    _updateFoodEntries();
    _showSnackBar('${entry.name} deleted');
  }

  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (context) => AddFoodDialog(onAdd: _addFoodEntry),
    );
  }

  void _showEditFoodDialog(FoodEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AddFoodDialog(
        onAdd: (name, calories, description) =>
            _editFoodEntry(entry, name, calories, description),
        initialName: entry.name,
        initialCalories: entry.calories,
        initialDescription: entry.description ?? '',
        isEditing: true,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = _calorieService.getTotalCalories();
    final todayCalories = _calorieService.getTodayCalories();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calorie Counter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_foodEntries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                _calorieService.clearAllEntries();
                _updateFoodEntries();
                _showSnackBar('All entries cleared');
              },
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: CalorieCard(
                    title: 'Today',
                    calories: todayCalories,
                    color: Colors.green,
                    icon: Icons.today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CalorieCard(
                    title: 'Total',
                    calories: totalCalories,
                    color: Colors.blue,
                    icon: Icons.assessment,
                  ),
                ),
              ],
            ),
          ),

          // Food Entries List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Food Entries',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${_foodEntries.length} items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Food List
          Expanded(
            child: _foodEntries.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No food entries yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first meal',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _foodEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _foodEntries[index];
                      return FoodEntryItem(
                        entry: entry,
                        onDelete: () => _deleteFoodEntry(entry.id),
                        onEdit: () => _showEditFoodDialog(entry),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFoodDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}