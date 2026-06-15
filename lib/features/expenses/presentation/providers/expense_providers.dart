import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sqlite_expense_repository.dart';
import '../../domain/expense.dart';
import '../../domain/expense_repository.dart';

/// Provides the active [ExpenseRepository] implementation.
/// Swap this out (e.g. for a mock) without touching any other layer.
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return const SqliteExpenseRepository();
});

/// Full list of expenses, newest first.
final expensesProvider = FutureProvider<List<Expense>>((ref) {
  return ref.watch(expenseRepositoryProvider).getAllExpenses();
});

/// Per-entry slices for the expenses pie chart.
final expensesChartDataProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
  return expenses
      .map((e) => <String, dynamic>{'amount': e.amount, 'color': e.color})
      .toList();
});

/// Running total of all expenses.
final totalExpensesProvider = Provider<double>((ref) {
  final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
  return expenses.fold(0.0, (sum, e) => sum + e.amount);
});
