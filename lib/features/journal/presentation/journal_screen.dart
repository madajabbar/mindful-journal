import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filters
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_note, size: 24, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Reflection',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'How are you feeling today? Write it down.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick add section
            Text(
              'Quick Add',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAddCard(
                    context,
                    icon: Icons.work,
                    title: 'Work',
                    color: Colors.blue,
                  ),
                  _buildQuickAddCard(
                    context,
                    icon: Icons.family_restroom,
                    title: 'Personal',
                    color: Colors.pink,
                  ),
                  _buildQuickAddCard(
                    context,
                    icon: Icons.fitness_center,
                    title: 'Health',
                    color: Colors.green,
                  ),
                  _buildQuickAddCard(
                    context,
                    icon: Icons.self_improvement,
                    title: 'Mindfulness',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent entries
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Entries',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all entries
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            
            Expanded(
              child: ListView(
                children: [
                  _buildJournalEntry(
                    context,
                    date: 'Today, 10:30 AM',
                    title: 'Morning Reflection',
                    preview: 'Feeling grateful for the new day. Excited to tackle...',
                    mood: '🙂',
                  ),
                  _buildJournalEntry(
                    context,
                    date: 'Yesterday, both r',
                    title: 'Work Stress',
                    preview: 'Dealing with tight deadlines. Need to manage...',
                    mood: '😐',
                  ),
                  _buildJournalEntry(
                    context,
                    date: '2 days ago, 7:00 PM',
                    title: 'Evening Walk',
                    preview: 'Beautiful sunset during my evening walk. Nature...',
                    mood: '😊',
                  ),
                  _buildJournalEntry(
                    context,
                    date: '3 days ago, 11:00 AM',
                    title: 'Family Time',
                    preview: 'Spent quality time with family over the weekend...',
                    mood: '🥰',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to new journal entry
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickAddCard(BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: () {
            // TODO: Quick add journal entry
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJournalEntry(BuildContext context, {
    required String date,
    required String title,
    required String preview,
    required String mood,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: View journal entry details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getMoodColor(mood).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    mood,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case '🥰':
        return AppTheme.moodExcellent;
      case '😊':
        return AppTheme.moodVeryHappy;
      case '🙂':
        return AppTheme.moodHappy;
      case '😐':
        return AppTheme.moodNeutral;
      case '😢':
        return AppTheme.moodSad;
      default:
        return AppTheme.moodNeutral;
    }
  }
}