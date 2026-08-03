import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';
import 'package:mindful_journal/core/providers/providers.dart';
import 'package:mindful_journal/services/auth_service.dart';
import 'package:mindful_journal/services/database_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkModeProvider);
    final authAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account section
            authAsync.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (user) {
                if (user != null) {
                  return Card(
                    child: _settingsItem(
                      context,
                      title: user.displayName ?? 'User',
                      subtitle: user.email ?? '',
                      icon: Icons.account_circle,
                      trailing: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        onPressed: () => _confirmLogout(),
                      ),
                    ),
                  );
                }
                return Card(
                  child: _settingsItem(
                    context,
                    title: 'Not logged in',
                    subtitle: 'Sign in to sync across devices',
                    icon: Icons.account_circle_outlined,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Appearance
            Text('Appearance', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Card(
              child: _settingsItem(
                context,
                title: 'Dark Mode',
                subtitle: isDark ? 'Dark theme enabled' : 'Light theme enabled',
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                trailing: Switch(
                  value: isDark,
                  onChanged: (v) => ref.read(darkModeProvider.notifier).state = v,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cloud Sync
            Text('Cloud', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Card(
              child: _settingsItem(
                context,
                title: 'Sync to Cloud',
                subtitle: 'Backup all data to Firebase',
                icon: Icons.cloud_upload,
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await DatabaseService().syncAllToCloud();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Synced to cloud!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Data
            Text('Data', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Card(
              child: _settingsItem(
                context,
                title: 'Clear All Data',
                subtitle: 'Delete everything from this device',
                icon: Icons.delete_forever,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearDialog(),
              ),
            ),
            const SizedBox(height: 24),

            // About
            Text('About', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _settingsItem(
                    context,
                    title: 'Privacy Policy',
                    subtitle: 'Your data stays on your device',
                    icon: Icons.shield,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  _settingsItem(
                    context,
                    title: 'Version',
                    subtitle: '1.0.0',
                    icon: Icons.info_outline,
                    trailing: const Text('v1.0.0'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Made with 💜 for your mental wellness',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Your local data will stay on this device. Cloud sync will stop.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will permanently delete all journal entries, mood records, and habits. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await DatabaseService().clearAllData();
              ref.invalidate(journalEntriesProvider);
              ref.invalidate(moodEntriesProvider);
              ref.invalidate(todayMoodProvider);
              ref.invalidate(habitsProvider);
              ref.invalidate(allHabitsProvider);
              ref.invalidate(statisticsProvider);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear Everything'),
          ),
        ],
      ),
    );
  }
}
