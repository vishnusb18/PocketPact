import '../models/spending.dart';

class SpendingService {
  // Mock data for demonstration
  static final List<SpendingEntry> _mockSpendingData = [
    // Today's spending
    SpendingEntry(
      id: '1',
      date: DateTime.now(),
      amount: 25.50,
      category: 'Food & Dining',
      description: 'Lunch at Subway',
      merchant: 'Subway',
    ),
    SpendingEntry(
      id: '2',
      date: DateTime.now(),
      amount: 12.99,
      category: 'Transportation',
      description: 'Uber ride',
      merchant: 'Uber',
    ),
    SpendingEntry(
      id: '3',
      date: DateTime.now(),
      amount: 89.99,
      category: 'Shopping',
      description: 'New headphones',
      merchant: 'Best Buy',
    ),

    // Yesterday's spending
    SpendingEntry(
      id: '4',
      date: DateTime.now().subtract(const Duration(days: 1)),
      amount: 45.00,
      category: 'Food & Dining',
      description: 'Dinner at Italian Restaurant',
      merchant: 'Olive Garden',
    ),
    SpendingEntry(
      id: '5',
      date: DateTime.now().subtract(const Duration(days: 1)),
      amount: 8.50,
      category: 'Transportation',
      description: 'Bus fare',
      merchant: 'City Transit',
    ),

    // Two days ago
    SpendingEntry(
      id: '6',
      date: DateTime.now().subtract(const Duration(days: 2)),
      amount: 150.00,
      category: 'Entertainment',
      description: 'Movie tickets and popcorn',
      merchant: 'AMC Theaters',
    ),
    SpendingEntry(
      id: '7',
      date: DateTime.now().subtract(const Duration(days: 2)),
      amount: 67.89,
      category: 'Shopping',
      description: 'Groceries',
      merchant: 'Whole Foods',
    ),

    // More mock data for the past week
    SpendingEntry(
      id: '8',
      date: DateTime.now().subtract(const Duration(days: 3)),
      amount: 32.50,
      category: 'Food & Dining',
      description: 'Coffee and pastry',
      merchant: 'Starbucks',
    ),
    SpendingEntry(
      id: '9',
      date: DateTime.now().subtract(const Duration(days: 4)),
      amount: 120.00,
      category: 'Bills & Utilities',
      description: 'Electricity bill',
      merchant: 'Power Company',
    ),
    SpendingEntry(
      id: '10',
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 75.00,
      category: 'Healthcare',
      description: 'Doctor visit',
      merchant: 'Medical Center',
    ),
  ];

  // Get spending data for a specific date
  static DailySpending? getSpendingForDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final entries = _mockSpendingData.where((entry) {
      return entry.date.isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
             entry.date.isBefore(dayEnd);
    }).toList();

    if (entries.isEmpty) return null;

    return DailySpending(date: dayStart, entries: entries);
  }

  // Get all spending data (for calendar markers)
  static Map<DateTime, double> getAllSpendingTotals() {
    final Map<DateTime, double> totals = {};

    for (final entry in _mockSpendingData) {
      final dateKey = DateTime(entry.date.year, entry.date.month, entry.date.day);
      totals[dateKey] = (totals[dateKey] ?? 0) + entry.amount;
    }

    return totals;
  }

  // Get spending data for a date range (for charts/analytics)
  static List<DailySpending> getSpendingForRange(DateTime start, DateTime end) {
    final Map<DateTime, List<SpendingEntry>> groupedEntries = {};

    for (final entry in _mockSpendingData) {
      if (entry.date.isAfter(start.subtract(const Duration(days: 1))) &&
          entry.date.isBefore(end.add(const Duration(days: 1)))) {
        final dateKey = DateTime(entry.date.year, entry.date.month, entry.date.day);
        groupedEntries[dateKey] = (groupedEntries[dateKey] ?? [])..add(entry);
      }
    }

    return groupedEntries.entries.map((entry) {
      return DailySpending(date: entry.key, entries: entry.value);
    }).toList();
  }

  // Add a new spending entry
  static void addSpendingEntry(SpendingEntry entry) {
    _mockSpendingData.add(entry);
  }
}
