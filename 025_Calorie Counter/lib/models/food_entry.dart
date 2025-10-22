class FoodEntry {
  final String id;
  final String name;
  final int calories;
  final DateTime date;
  final String? description;

  FoodEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.date,
    this.description,
  });

  FoodEntry copyWith({
    String? id,
    String? name,
    int? calories,
    DateTime? date,
    String? description,
  }) {
    return FoodEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}