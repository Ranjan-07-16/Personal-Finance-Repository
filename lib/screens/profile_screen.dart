import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_data.dart';
import '../providers/auth_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _usernameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: ref.read(userProvider).username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isEditing = false);
    await ref
        .read(userProvider.notifier)
        .updateUsername(_usernameController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  Future<void> _logout() async {
    await ref.read(userProvider.notifier).clearUser();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.indigo,
                  child: Icon(UserData.defaultProfileIcon,
                      color: Colors.white, size: 70),
                ),
              ),
              const SizedBox(height: 20),
              _isEditing
                  ? TextField(
                      controller: _usernameController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    )
                  : Text(
                      user.username,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                    ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  if (_isEditing) {
                    _saveProfile();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                label: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? Colors.green : Colors.indigo,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.indigo),
                    title: const Text('Account Centre'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/account_center'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.indigo),
                    title: const Text('App Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.contact_support_outlined,
                        color: Colors.indigo),
                    title: const Text('Help'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.of(context).pushNamed('/help'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined,
                        color: Colors.indigo),
                    title: const Text('Account Status'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/account_status'),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.info_outline, color: Colors.indigo),
                    title: const Text('About'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.of(context).pushNamed('/about'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline,
                        color: Colors.indigo),
                    title: const Text('Add Account'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/add_account'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
