import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';
import 'package:mindful_journal/core/providers/providers.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statisticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats overview
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryColor.withOpacity(0.8), AppTheme.secondaryColor.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text('Your Overview', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem(context, '${stats['total_journal_entries']}', 'Entries', Icons.edit),
                        _statItem(context, '${stats['total_mood_entries']}', 'Moods', Icons.mood),
                        _statItem(context, '${stats['active_habits']}', 'Habits', Icons.check_circle),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mood average
              Text('Mood Average', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: _moodAvgColor(stats['mood_average']),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            _moodAvgEmoji(stats['mood_average']),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${stats['mood_average'].toStringAsFixed(1)} / 5.0', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Text('Average mood across all entries', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Habit completion
              Text('Habit Completion', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Completion Rate', style: Theme.of(context).textTheme.titleMedium),
                          Text('${stats['habit_completion_rate'].toStringAsFixed(0)}%', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.primaryColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: stats['habit_completion_rate'] / 100,
                        backgroundColor: Colors.grey.shade200,
                        color: AppTheme.primaryColor,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text('Best streak: ${stats['current_streak']} days', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick tip
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
                        const Icon(Icons.lightbulb, color: AppTheme.secondaryColor),
                        const SizedBox(width: 8),
                        Text('Tip', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.secondaryColor, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getTip(stats),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.9))),
      ],
    );
  }

  Color _moodAvgColor(double avg) {
    if (avg >= 4.5) return AppTheme.moodExcellent;
    if (avg >= 3.5) return AppTheme.moodVeryHappy;
    if (avg >= 2.5) return AppTheme.moodHappy;
    if (avg >= 1.5) return AppTheme.moodNeutral;
    return AppTheme.moodSad;
  }

  String _moodAvgEmoji(double avg) {
    if (avg >= 4.5) return '🥰';
    if (avg >= 3.5) return '😊';
    if (avg >= 2.5) return '🙂';
    if (avg >= 1.5) return '😐';
    return '😢';
  }

  String _getTip(Map<String, dynamic> stats) {
    final entries = stats['total_journal_entries'] as int? ?? 0;
    final moods = stats['total_mood_entries'] as int? ?? 0;
    final avg = stats['mood_average'] as double? ?? 3.0;

    if (entries == 0 && moods == 0) {
      return "Start by logging your mood today! Even one entry helps you build a habit of self-awareness. 🌱";
    }
    if (avg < 3.0) {
      return "Your average mood is a bit low lately. Consider trying a short walk, talking to a friend, or writing in your journal. 💚";
    }
    if (entries < 3) {
      return "Try writing a journal entry every evening. Studies show that reflective writing improves mental clarity and emotional well-being. 📝";
    }
    return "Great job maintaining your mental wellness routine! Keep it up — consistency is key to lasting positive change. ✨";
  }
}
