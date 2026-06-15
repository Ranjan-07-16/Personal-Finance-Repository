import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db_helper.dart';
import '../models/income.dart';
import '../models/financial_data.dart';
import '../providers/financial_providers.dart';
import '../widgets/income_block.dart';

class IncomeScreen extends ConsumerStatefulWidget {
  const IncomeScreen({super.key});

  @override
  ConsumerState<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends ConsumerState<IncomeScreen> {
  Map<String, dynamic>? _newIncomeData;

  Future<void> _addIncome() async {
    if (_newIncomeData != null && (_newIncomeData!['amount'] as double) > 0) {
      await DatabaseHelper.instance.insertIncome(Income(
        amount: _newIncomeData!['amount'] as double,
        source: _newIncomeData!['source'] as String,
        reason: _newIncomeData!['reason'] as String,
        color: _newIncomeData!['color'] as Color,
        date: DateTime.now(),
      ));
      ref.invalidate(incomeProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Income saved!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select a source and enter an amount.')),
        );
      }
    }
  }

  Future<void> _clearIncome() async {
    await DatabaseHelper.instance.clearAllIncome();
    ref.invalidate(incomeProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All income cleared!')),
      );
    }
  }

  Future<void> _showAddIncomeDialog() async {
    double? incomeAmount;
    String? selectedSource;
    final amountController = TextEditingController();
    final reasonController = TextEditingController();
    _newIncomeData = null;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              title: const Text('Add New Income'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (\$)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      onChanged: (value) {
                        setModalState(
                            () => incomeAmount = double.tryParse(value));
                      },
                    ),
                    const SizedBox(height: 16),
                    ...FinancialData.incomeSources.keys.map((source) {
                      final color = FinancialData.incomeSources[source]!;
                      return ListTile(
                        leading: Icon(
                          selectedSource == source
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: color,
                        ),
                        title: Text(source),
                        onTap: () =>
                            setModalState(() => selectedSource = source),
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
                  onPressed: selectedSource != null &&
                          incomeAmount != null &&
                          incomeAmount! > 0
                      ? () {
                          _newIncomeData = {
                            'amount': incomeAmount!,
                            'source': selectedSource!,
                            'reason': reasonController.text.isEmpty
                                ? selectedSource!
                                : reasonController.text,
                            'color':
                                FinancialData.incomeSources[selectedSource!]!,
                          };
                          Navigator.of(context).pop();
                          _addIncome();
                        }
                      : null,
                  child: const Text('Add Income'),
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
    final incomeAsync = ref.watch(incomeProvider);
    final total = ref.watch(totalIncomeProvider);
    final income = incomeAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Income'),
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
            tooltip: 'Clear All Income',
            onPressed: income.isNotEmpty ? _clearIncome : null,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIncomeDialog,
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: incomeAsync.when(
          data: (income) => income.isEmpty
              ? const Center(
                  child: Text('No income recorded. Tap + to add one!'))
              : ListView.builder(
                  itemCount: income.length,
                  itemBuilder: (context, index) =>
                      IncomeBlock(income: income[index]),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
