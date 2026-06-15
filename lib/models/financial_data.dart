import 'package:flutter/material.dart';

// Holds income source display constants.
// Expense categories have moved to features/expenses/domain/expense_categories.dart.
class FinancialData {
  static const Map<String, Color> incomeSources = {
    'Salary': Colors.green,
    'Freelance': Colors.lightGreen,
    'Investments': Colors.teal,
    'Bonus': Colors.blueAccent,
    'Gift': Colors.amber,
    'Custom': Colors.grey,
  };
}
