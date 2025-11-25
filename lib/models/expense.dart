class Expense {
  final String friendName;
  final double amount;
  final String description;
  final DateTime date;
  bool received; // true = received, false = not received

  Expense({
    required this.friendName,
    required this.amount,
    required this.description,
    required this.date,
    this.received = false,
  });

  Map<String, dynamic> toJson() => {
        'friendName': friendName,
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
        'received': received,
      };

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      friendName: json['friendName'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      date: DateTime.parse(json['date']),
      received: json['received'] ?? false,
    );
  }
}
