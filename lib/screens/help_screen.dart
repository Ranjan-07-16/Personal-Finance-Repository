import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/help_card.dart';
import 'faq_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _showHelpCentreSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Support',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "Reach out and we'll get back to you shortly.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 28),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.email_outlined,
                      color: Colors.white, size: 20),
                ),
                title: const Text('help@financeapp.dev'),
                subtitle: const Text('Tap the copy icon to copy this address'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy_outlined, color: Colors.indigo),
                  tooltip: 'Copy email',
                  onPressed: () {
                    Clipboard.setData(
                        const ClipboardData(text: 'help@financeapp.dev'));
                    Navigator.of(sheetCtx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Email address copied to clipboard!')),
                    );
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade400,
                  child: const Icon(Icons.schedule,
                      color: Colors.white, size: 20),
                ),
                title: const Text('Mon – Fri, 9 AM – 5 PM'),
                subtitle: const Text('We typically respond within 24 hours'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeedbackSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FeedbackSheet(
        onSubmit: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            duration: Duration(seconds: 3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            HelpCard(
              icon: Icons.question_answer_outlined,
              title: "FAQ's",
              subtitle: "Find answers to frequently asked questions.",
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FaqScreen()),
              ),
              color: Colors.green.shade400,
            ),
            HelpCard(
              icon: Icons.support_agent_outlined,
              title: "Help Centre",
              subtitle:
                  "Contact our support team for personalized assistance.",
              onTap: () => _showHelpCentreSheet(context),
              color: Colors.blue.shade400,
            ),
            HelpCard(
              icon: Icons.rate_review_outlined,
              title: "Tell us how we're doing",
              subtitle: "Provide feedback on your experience.",
              onTap: () => _showFeedbackSheet(context),
              color: Colors.orange.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackSheet extends StatefulWidget {
  final VoidCallback onSubmit;

  const _FeedbackSheet({required this.onSubmit});

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + keyboardHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tell us how we're doing",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your feedback helps us improve the app.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Share your thoughts…',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.indigo, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  widget.onSubmit();
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
