import 'expense.dart';

/// Contract for all expense persistence operations.
/// The domain layer depends only on this abstraction — never on SQLite.
abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();
  Future<int> insertExpense(Expense expense);
  Future<int> deleteExpense(int id);
  Future<int> clearAllExpenses();
}
