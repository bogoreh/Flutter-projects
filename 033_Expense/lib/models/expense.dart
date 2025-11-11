class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? description;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'category': category,
      'description': description,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      category: map['category'],
      description: map['description'],
    );
  }
}