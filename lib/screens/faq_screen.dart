import 'package:flutter/material.dart';

typedef _FaqItem = ({String question, String answer});

const List<_FaqItem> _faqItems = [
  (
    question: 'How do I add an expense?',
    answer:
        'Open "My Expenses" from the dashboard, then tap the red + button. Choose a category, enter the amount, and add an optional reason before confirming.',
  ),
  (
    question: 'How do I record income?',
    answer:
        'Open "My Income" from the dashboard, then tap the green + button. Select a source, enter the amount, and add an optional note.',
  ),
  (
    question: 'How do I view my spending breakdown?',
    answer:
        'The dashboard shows a live pie chart of your expenses by category and a separate chart for income sources. Both update automatically whenever you add or clear entries.',
  ),
  (
    question: 'Can I delete a specific transaction?',
    answer:
        'Per-item deletion is coming in a future update. For now, use the trash icon (top-right of each list screen) to clear all entries at once.',
  ),
  (
    question: 'How do I update my username?',
    answer:
        'Tap your profile avatar in the top-right corner of the dashboard, then tap "Edit Profile". Update your username and tap "Save Profile" to apply the change.',
  ),
  (
    question: 'How do I log out?',
    answer:
        'Go to My Profile and scroll to the bottom of the menu. Tap "Logout" to end your current session.',
  ),
  (
    question: 'Is my financial data stored securely?',
    answer:
        'All data is stored locally on your device using SQLite. Nothing is sent to external servers. Backing up your device will preserve your financial records.',
  ),
  (
    question: 'What expense categories are available?',
    answer:
        'Food, Housing, Entertainment, Clothing, Transport, and Custom. The Custom option lets you label the expense with a free-text reason.',
  ),
  (
    question: 'What income sources are available?',
    answer:
        'Salary, Freelance, Investments, Bonus, Gift, and Custom.',
  ),
  (
    question: 'Can I use the app on multiple devices?',
    answer:
        'The app currently stores data locally on one device. Cloud sync and multi-device support are planned for a future release.',
  ),
];

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ's"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _faqItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return ExpansionTile(
            leading: Icon(Icons.help_outline, color: Colors.indigo.shade400),
            title: Text(
              item.question,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.indigo.shade100),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.indigo.shade100),
            ),
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.indigo.shade50,
            expandedAlignment: Alignment.centerLeft,
            childrenPadding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Text(
                item.answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
