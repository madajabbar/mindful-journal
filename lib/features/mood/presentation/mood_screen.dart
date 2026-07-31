import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';

class MoodScreen extends ConsumerWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // TODO: Open calendar view
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's mood section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    "How are you feeling today?",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Mood selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMoodButton(context, mood: '😢', label: 'Sad'),
                      _buildMoodButton(context, mood: '😐', label: 'Neutral'),
                      _buildMoodButton(context, mood: '🙂', label: 'Happy'),
                      _buildMoodButton(context, mood: '😊', label: 'Very Happy'),
                      _buildMoodButton(context, mood: '🥰', label: 'Excellent'),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Quick notes
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a quick note about your mood...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Save mood entry
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Today\'s Mood'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Mood statistics
            Text(
              'Weekly Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mood Trend',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        '📈 Mood chart will appear here',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent mood entries
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Moods',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all mood entries
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Column(
              children: [
                _buildMoodEntry(
                  context,
                  date: 'Today',
                  mood: '🙂',
                  note: 'Feeling productive and focused',
                  time: '10:30 AM',
                ),
                _buildMoodEntry(
                  context,
                  date: 'Yesterday',
                  mood: '😊',
                  note: 'Great day with family',
                  time: '7:00 PM',
                ),
                _buildMoodEntry(
                  context,
                  date: '2 days ago',
                  mood: '😐',
                  note: 'Busy workday, feeling tired',
                  time: '5:00 PM',
                ),
                _buildMoodEntry(
                  context,
                  date: '3 days ago',
                  mood: '🥰',
                  note: 'Amazing weekend getaway',
                  time: '11:00 AM',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Mood patterns
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.insights, color: AppTheme.secondaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Mood Patterns',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your mood tends to be higher on weekends and during outdoor activities.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // TODO: View detailed patterns
                    },
                    child: const Text('View Detailed Analysis'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context, {
    required String mood,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _getMoodColor(mood).withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _getMoodColor(mood),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              mood,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMoodEntry(BuildContext context, {
    required String date,
    required String mood,
    required String note,
    required String time,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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