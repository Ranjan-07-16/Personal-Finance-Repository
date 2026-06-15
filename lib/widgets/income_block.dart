import 'package:flutter/material.dart';

import '../models/income.dart';

class IncomeBlock extends StatelessWidget {
  final Income income;

  const IncomeBlock({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: income.color.withOpacity(0.5), width: 2),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: income.color,
          radius: 25,
          child: const Icon(Icons.trending_up, color: Colors.white),
        ),
        title: Text(
          '+\$${income.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
        ),
        subtitle: Text(
          income.reason,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              income.source,
              style:
                  TextStyle(color: income.color, fontWeight: FontWeight.bold),
            ),
            Text(
              '${income.date.month}/${income.date.day}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
