import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/data/models/journal_entry.dart';
import 'package:mindful_journal/data/models/mood_entry.dart';
import 'package:mindful_journal/data/models/habit.dart';
import 'package:mindful_journal/services/database_service.dart';

// Dark mode provider
final darkModeProvider = StateProvider<bool>((ref) => false);

// Database service provider
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

// Journal entries provider
final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final db = ref.watch(databaseServiceProvider);
  return db.getAllJournalEntries();
});

// Mood entries provider
final moodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  final db = ref.watch(databaseServiceProvider);
  final now = DateTime.now();
  final startDate = now.subtract(const Duration(days: 30));
  return db.getMoodEntries(startDate, now);
});

// Today's mood provider
final todayMoodProvider = FutureProvider<MoodEntry?>((ref) async {
  final db = ref.watch(databaseServiceProvider);
  return db.getMoodEntryByDate(DateTime.now());
});

// Habits provider
final habitsProvider = FutureProvider<List<Habit>>((ref) async {
  final db = ref.watch(databaseServiceProvider);
  return db.getActiveHabits();
});

// All habits provider (including inactive)
final allHabitsProvider = FutureProvider<List<Habit>>((ref) async {
  final db = ref.watch(databaseServiceProvider);
  return db.getAllHabits();
});

// Statistics provider
final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final db = ref.watch(databaseServiceProvider);
  return db.getStatistics();
});

// Settings provider
final settingsProvider = Provider<Map<dynamic, dynamic>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return db.getSettings();
});
