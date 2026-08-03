import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';
import 'package:mindful_journal/core/providers/providers.dart';
import 'package:mindful_journal/data/models/habit.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(allHabitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Builder'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddDialog(context)),
        ],
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (habits) {
          final active = habits.where((h) => h.isActive).toList();
          final completedToday = active.where((h) {
            final now = DateTime.now();
            final last = DateTime(h.lastCompleted.year, h.lastCompleted.month, h.lastCompleted.day);
            final today = DateTime(now.year, now.month, now.day);
            return !today.isAfter(last);
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Streak summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Text(
                            habits.isEmpty ? '0' : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b).toString(),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Best Streak', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondaryColor)),
                            Text('${completedToday.length}/${active.length} done today', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text("Today's Habits", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                if (active.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text('No habits yet', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500)),
                          const SizedBox(height: 4),
                          Text('Tap + to create your first habit', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  )
                else
                  ...active.map((h) => _habitCard(h)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _habitCard(Habit habit) {
    final now = DateTime.now();
    final last = DateTime(habit.lastCompleted.year, habit.lastCompleted.month, habit.lastCompleted.day);
    final today = DateTime(now.year, now.month, now.day);
    final doneToday = !today.isAfter(last);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: doneToday,
              onChanged: doneToday ? null : (_) => _toggleHabit(habit),
              activeColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      decoration: doneToday ? TextDecoration.lineThrough : null,
                      color: doneToday ? Colors.grey : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: habit.streak > 0 ? Colors.orange : Colors.grey),
                      const SizedBox(width: 4),
                      Text('${habit.streak} days', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: habit.streak > 0 ? Colors.orange : Colors.grey)),
                      if (habit.reminderTime.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: AppTheme.textSecondaryColor),
                        const SizedBox(width: 4),
                        Text(habit.reminderTime, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'delete') _confirmDelete(habit);
              },
              itemBuilder: (_) => [const PopupMenuItem(value: 'delete', child: Text('Delete'))],
              icon: const Icon(Icons.more_vert, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleHabit(Habit habit) async {
    habit.markCompleted();
    await ref.read(databaseServiceProvider).updateHabit(habit);
    ref.invalidate(allHabitsProvider);
    ref.invalidate(habitsProvider);
    ref.invalidate(statisticsProvider);
  }

  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final timeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Habit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Habit Name')),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description (optional)')),
              const SizedBox(height: 12),
              TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Reminder time (e.g. 7:00 AM)', hintText: 'Optional')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              final db = ref.read(databaseServiceProvider);
              await db.addHabit(Habit(
                id: const Uuid().v4(),
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                createdAt: DateTime.now(),
                daysOfWeek: [0, 1, 2, 3, 4, 5, 6],
                reminderTime: timeCtrl.text.trim(),
                streak: 0,
                lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
                isActive: true,
              ));
              ref.invalidate(allHabitsProvider);
              ref.invalidate(habitsProvider);
              ref.invalidate(statisticsProvider);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Delete "${habit.title}"? Streak will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(databaseServiceProvider).deleteHabit(habit.id);
              ref.invalidate(allHabitsProvider);
              ref.invalidate(habitsProvider);
              ref.invalidate(statisticsProvider);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
