import 'package:flutter/material.dart';

import '../models/user_data.dart';

class AccountCenterScreen extends StatelessWidget {
  const AccountCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Centre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Manage your connected experiences and account settings",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.indigo,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Primary Account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Icon(UserData.defaultProfileIcon,
                            color: Colors.indigo, size: 24),
                      ),
                      title: Text(UserData.username),
                      subtitle: Text(UserData.email),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {},
                    ),
                    const Divider(),
                    const Text('Linked Experiences coming soon...',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
