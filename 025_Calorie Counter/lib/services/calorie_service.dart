import '../models/food_entry.dart';

class CalorieService {
  final List<FoodEntry> _foodEntries = [];

  List<FoodEntry> get foodEntries => _foodEntries;

  void addFoodEntry(FoodEntry entry) {
    _foodEntries.add(entry);
  }

  void removeFoodEntry(String id) {
    _foodEntries.removeWhere((entry) => entry.id == id);
  }

  int getTotalCalories() {
    return _foodEntries.fold(0, (sum, entry) => sum + entry.calories);
  }

  int getTodayCalories() {
    final today = DateTime.now();
    return _foodEntries
        .where((entry) =>
            entry.date.year == today.year &&
            entry.date.month == today.month &&
            entry.date.day == today.day)
        .fold(0, (sum, entry) => sum + entry.calories);
  }

  void clearAllEntries() {
    _foodEntries.clear();
  }
}