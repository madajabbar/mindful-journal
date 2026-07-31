import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'U',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Profile',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Edit your profile information',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Edit profile
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Preferences
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Notifications',
                    subtitle: 'Daily reminders and notifications',
                    icon: Icons.notifications,
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Toggle notifications
                      },
                    ),
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Dark Mode',
                    subtitle: 'Enable dark theme',
                    icon: Icons.dark_mode,
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        // TODO: Toggle dark mode
                      },
                    ),
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Daily Reminders',
                    subtitle: 'Set reminder times',
                    icon: Icons.access_time,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Set reminder times
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'App Language',
                    subtitle: 'English (US)',
                    icon: Icons.language,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Change language
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Data Management
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Export Data',
                    subtitle: 'Export journal entries as PDF/CSV',
                    icon: Icons.upload_file,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Export data
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Backup & Restore',
                    subtitle: 'Cloud backup settings',
                    icon: Icons.backup,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Backup settings
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Clear Local Data',
                    subtitle: 'Delete all local entries',
                    icon: Icons.delete,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showClearDataDialog(context);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Premium Features
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.8),
                    AppTheme.secondaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Features',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock advanced insights, unlimited storage, and premium features',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Open premium purchase
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Upgrade to Premium'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About & Support
            Text(
              'About & Support',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    icon: Icons.privacy_tip,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open privacy policy
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms and conditions',
                    icon: Icons.description,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open terms
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Help & Support',
                    subtitle: 'Contact us for help',
                    icon: Icons.help,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open support
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Rate the App',
                    subtitle: 'Leave a review on Play Store',
                    icon: Icons.star,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Rate app
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'App Version',
                    subtitle: '1.0.0',
                    icon: Icons.info,
                    trailing: const Text('v1.0.0'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Logout button
            Center(
              child: OutlinedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Local Data'),
        content: const Text(
          'This will delete all journal entries, mood tracking data, and habits from your device. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Clear data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Local data cleared')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Logout
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}