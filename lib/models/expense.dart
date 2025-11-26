class Expense {
  final String id;
  final String name;
  final DateTime date;
  final String description;
  final double amount;

  Expense({
    required this.id,
    required this.name,
    required this.date,
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'description': description,
      'amount': amount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      amount: map['amount'].toDouble(),
    );
  }
}