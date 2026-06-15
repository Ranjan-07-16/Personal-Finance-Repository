import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Finance Tracker App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Version 1.0.0 (DartPad Edition)',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
            const Divider(height: 30),
            Text(
              'Our Mission',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The Finance Tracker App is designed to provide you with a simple, secure, and intuitive way to manage your daily income and expenses. Our mission is to empower individuals to take control of their financial well-being through clear data visualization and historical tracking.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            Text(
              'Technology Used',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This application is built entirely using the Flutter framework, ensuring a consistent experience across mobile platforms. In this DartPad version, all data is stored temporarily in memory and will reset upon page refresh.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                '© 2025 Finance Tracker Team',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
