import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/expense.dart';
import '../../domain/expense_categories.dart';
import '../providers/expense_providers.dart';
import '../widgets/expense_block.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  Map<String, dynamic>? _newExpenseData;

  Future<void> _addExpense() async {
    if (_newExpenseData != null && (_newExpenseData!['amount'] as double) > 0) {
      await ref.read(expenseRepositoryProvider).insertExpense(Expense(
            amount: _newExpenseData!['amount'] as double,
            category: _newExpenseData!['category'] as String,
            reason: _newExpenseData!['reason'] as String,
            color: _newExpenseData!['color'] as Color,
            date: DateTime.now(),
          ));
      ref.invalidate(expensesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense saved!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select a category and enter an amount.')),
        );
      }
    }
  }

  Future<void> _clearExpenses() async {
    await ref.read(expenseRepositoryProvider).clearAllExpenses();
    ref.invalidate(expensesProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All expenses cleared!')),
      );
    }
  }

  Future<void> _showAddExpenseDialog() async {
    double? expenseAmount;
    String? selectedCategory;
    final amountController = TextEditingController();
    final reasonController = TextEditingController();
    _newExpenseData = null;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              title: const Text('Add New Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (\$)',
                        prefixIcon: Icon(Icons.monetization_on),
                      ),
                      onChanged: (value) {
                        setModalState(
                            () => expenseAmount = double.tryParse(value));
                      },
                    ),
                    const SizedBox(height: 16),
                    ...expenseCategories.keys.map((category) {
                      final color = expenseCategories[category]!;
                      return ListTile(
                        leading: Icon(
                          selectedCategory == category
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: color,
                        ),
                        title: Text(category),
                        onTap: () =>
                            setModalState(() => selectedCategory = category),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Custom Message/Reason',
                        prefixIcon: Icon(Icons.chat_bubble_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FilledButton(
                  onPressed: selectedCategory != null &&
                          expenseAmount != null &&
                          expenseAmount! > 0
                      ? () {
                          _newExpenseData = {
                            'amount': expenseAmount!,
                            'category': selectedCategory!,
                            'reason': reasonController.text.isEmpty
                                ? selectedCategory!
                                : reasonController.text,
                            'color': expenseCategories[selectedCategory!]!,
                          };
                          Navigator.of(context).pop();
                          _addExpense();
                        }
                      : null,
                  child: const Text('Add Expense'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesProvider);
    final total = ref.watch(totalExpensesProvider);
    final expenses = expensesAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear All Expenses',
            onPressed: expenses.isNotEmpty ? _clearExpenses : null,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: expensesAsync.when(
          data: (expenses) => expenses.isEmpty
              ? const Center(
                  child: Text('No expenses recorded. Tap + to add one!'))
              : ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) =>
                      ExpenseBlock(expense: expenses[index]),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
