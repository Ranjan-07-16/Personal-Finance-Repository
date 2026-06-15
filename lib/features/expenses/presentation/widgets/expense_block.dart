import 'package:flutter/material.dart';

import '../../domain/expense.dart';

class ExpenseBlock extends StatelessWidget {
  final Expense expense;

  const ExpenseBlock({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: expense.color.withOpacity(0.5), width: 2),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: expense.color,
          radius: 25,
          child: Text(
            '\$',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        title: Text(
          '-\$${expense.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
        ),
        subtitle: Text(
          expense.reason,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              expense.category,
              style:
                  TextStyle(color: expense.color, fontWeight: FontWeight.bold),
            ),
            Text(
              '${expense.date.month}/${expense.date.day}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
