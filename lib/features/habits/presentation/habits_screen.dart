import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddHabitDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // TODO: Open statistics
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current streak
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        '7',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
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
                          'Current Streak',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        Text(
                          '7 days in a row! 🎉',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Today's habits
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Habits",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all habits
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Expanded(
              child: ListView(
                children: [
                  _buildHabitItem(
                    context,
                    title: 'Morning Meditation',
                    time: '7:00 AM',
                    streak: 14,
                    completed: true,
                  ),
                  _buildHabitItem(
                    context,
                    title: 'Daily Journaling',
                    time: '9:00 AM',
                    streak: 7,
                    completed: true,
                  ),
                  _buildHabitItem(
                    context,
                    title: 'Evening Walk',
                    time: '6:00 PM',
                    streak: 5,
                    completed: false,
                  ),
                  _buildHabitItem(
                    context,
                    title: 'Digital Detox',
                    time: '9:00 PM',
                    streak: 3,
                    completed: false,
                  ),
                  _buildHabitItem(
                    context,
                    title: 'Gratitude Practice',
                    time: '10:00 PM',
                    streak: 21,
                    completed: false,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Achievement badges
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAchievementBadge(
                    context,
                    icon: Icons.emoji_events,
                    title: '1 Week Streak',
                    description: '7 days completed',
                    achieved: true,
                  ),
                  _buildAchievementBadge(
                    context,
                    icon: Icons.self_improvement,
                    title: 'Mindfulness Master',
                    description: '30 meditations',
                    achieved: true,
                  ),
                  _buildAchievementBadge(
                    context,
                    icon: Icons.edit,
                    title: 'Writing Warrior',
                    description: '50 journal entries',
                    achieved: false,
                  ),
                  _buildAchievementBadge(
                    context,
                    icon: Icons.nature,
                    title: 'Outdoor Explorer',
                    description: '20 walks completed',
                    achieved: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitItem(BuildContext context, {
    required String title,
    required String time,
    required int streak,
    required bool completed,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: completed,
              onChanged: (value) {
                // TODO: Toggle habit completion
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),
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
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppTheme.textSecondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        '$streak days',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!completed)
              ElevatedButton(
                onPressed: () {
                  // TODO: Mark as completed
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Complete'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool achieved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: achieved ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: achieved ? AppTheme.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: achieved ? AppTheme.primaryColor : Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: achieved ? AppTheme.primaryColor : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: achieved ? AppTheme.textSecondaryColor : Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g., Morning Meditation',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'e.g., 7:00 AM',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'daily',
                    child: Text('Daily'),
                  ),
                  DropdownMenuItem(
                    value: 'weekdays',
                    child: Text('Weekdays Only'),
                  ),
                  DropdownMenuItem(
                    value: 'weekly',
                    child: Text('Weekly'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Reminder (optional)',
                  hintText: 'e.g., 10 minutes before',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save new habit
              Navigator.pop(context);
            },
            child: const Text('Add Habit'),
          ),
        ],
      ),
    );
  }
}