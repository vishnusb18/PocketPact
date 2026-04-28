class SpendingEntry {
  final String id;
  final DateTime date;
  final double amount;
  final String category;
  final String description;
  final String merchant;

  SpendingEntry({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.description,
    required this.merchant,
  });

  factory SpendingEntry.fromJson(Map<String, dynamic> json) {
    return SpendingEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      category: json['category'],
      description: json['description'],
      merchant: json['merchant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category,
      'description': description,
      'merchant': merchant,
    };
  }
}

class DailySpending {
  final DateTime date;
  final List<SpendingEntry> entries;
  final double totalAmount;

  DailySpending({
    required this.date,
    required this.entries,
  }) : totalAmount = entries.fold(0, (sum, entry) => sum + entry.amount);

  Map<String, double> getSpendingByCategory() {
    final Map<String, double> categoryTotals = {};
    for (final entry in entries) {
      categoryTotals[entry.category] = (categoryTotals[entry.category] ?? 0) + entry.amount;
    }
    return categoryTotals;
  }
}