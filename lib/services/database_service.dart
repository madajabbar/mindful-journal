import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/journal_entry.dart';
import '../data/models/mood_entry.dart';
import '../data/models/habit.dart';
import 'firebase_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() {
    return _instance;
  }
  
  DatabaseService._internal();
  
  late Box<JournalEntry> _journalBox;
  late Box<MoodEntry> _moodBox;
  late Box<Habit> _habitBox;
  late Box<Map<dynamic, dynamic>> _settingsBox;
  
  final FirebaseService _firebase = FirebaseService();
  
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Register adapters
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(MoodEntryAdapter());
    Hive.registerAdapter(HabitAdapter());
    
    // Open boxes
    _journalBox = await Hive.openBox<JournalEntry>('journal_entries');
    _moodBox = await Hive.openBox<MoodEntry>('mood_entries');
    _habitBox = await Hive.openBox<Habit>('habits');
    _settingsBox = await Hive.openBox<Map<dynamic, dynamic>>('settings');
    
    // Initialize default settings if empty
    if (_settingsBox.isEmpty) {
      await _settingsBox.put('app_settings', {
        'notifications_enabled': true,
        'dark_mode': false,
        'daily_reminder_time': '20:00',
        'language': 'en',
        'first_run': true,
      });
    }
  }
  
  // Journal Entry Operations
  Future<String> addJournalEntry(JournalEntry entry) async {
    await _journalBox.put(entry.id, entry);
    // Sync to cloud if logged in
    _firebase.syncJournalToCloud(entry).catchError((e) => print('Cloud sync error: $e'));
    return entry.id;
  }
  
  Future<JournalEntry?> getJournalEntry(String id) async {
    return _journalBox.get(id);
  }
  
  Future<List<JournalEntry>> getAllJournalEntries() async {
    return _journalBox.values.toList();
  }
  
  Future<List<JournalEntry>> getJournalEntriesByDate(DateTime date) async {
    final entries = _journalBox.values.where((entry) {
      final entryDate = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return entryDate == targetDate;
    }).toList();
    
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }
  
  Future<void> updateJournalEntry(JournalEntry entry) async {
    entry.updatedAt = DateTime.now();
    await _journalBox.put(entry.id, entry);
    _firebase.syncJournalToCloud(entry).catchError((e) => print('Cloud sync error: $e'));
  }
  
  Future<void> deleteJournalEntry(String id) async {
    await _journalBox.delete(id);
    _firebase.deleteJournalFromCloud(id).catchError((e) => print('Cloud delete error: $e'));
  }
  
  // Mood Entry Operations
  Future<String> addMoodEntry(MoodEntry entry) async {
    await _moodBox.put(entry.id, entry);
    _firebase.syncMoodToCloud(entry).catchError((e) => print('Cloud sync error: $e'));
    return entry.id;
  }
  
  Future<MoodEntry?> getMoodEntryByDate(DateTime date) async {
    final targetDate = DateTime(date.year, date.month, date.day);
    return _moodBox.values.firstWhere(
      (entry) {
        final entryDate = DateTime(
          entry.date.year,
          entry.date.month,
          entry.date.day,
        );
        return entryDate == targetDate;
      },
      orElse: () => MoodEntry.daily(date),
    );
  }
  
  Future<List<MoodEntry>> getMoodEntries(DateTime startDate, DateTime endDate) async {
    return _moodBox.values.where((entry) {
      return entry.date.isAfter(startDate) && entry.date.isBefore(endDate);
    }).toList();
  }
  
  Future<void> updateMoodEntry(MoodEntry entry) async {
    await _moodBox.put(entry.id, entry);
    _firebase.syncMoodToCloud(entry).catchError((e) => print('Cloud sync error: $e'));
  }
  
  Future<void> deleteMoodEntry(String id) async {
    await _moodBox.delete(id);
    _firebase.deleteMoodFromCloud(id).catchError((e) => print('Cloud delete error: $e'));
  }
  
  // Habit Operations
  Future<String> addHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
    _firebase.syncHabitToCloud(habit).catchError((e) => print('Cloud sync error: $e'));
    return habit.id;
  }
  
  Future<List<Habit>> getAllHabits() async {
    return _habitBox.values.toList();
  }
  
  Future<List<Habit>> getActiveHabits() async {
    return _habitBox.values.where((habit) => habit.isActive).toList();
  }
  
  Future<void> updateHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
    _firebase.syncHabitToCloud(habit).catchError((e) => print('Cloud sync error: $e'));
  }
  
  Future<void> deleteHabit(String id) async {
    await _habitBox.delete(id);
    _firebase.deleteHabitFromCloud(id).catchError((e) => print('Cloud delete error: $e'));
  }
  
  // Settings Operations
  Map<dynamic, dynamic> getSettings() {
    return _settingsBox.get('app_settings', defaultValue: {})!;
  }
  
  Future<void> updateSettings(Map<dynamic, dynamic> newSettings) async {
    final currentSettings = getSettings();
    currentSettings.addAll(newSettings);
    await _settingsBox.put('app_settings', currentSettings);
  }
  
  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final journalEntries = await getAllJournalEntries();
    final moodEntries = _moodBox.values.toList();
    final habits = await getActiveHabits();
    
    // Calculate mood average
    double moodAverage = 3.0;
    if (moodEntries.isNotEmpty) {
      final total = moodEntries.fold(0, (sum, entry) => sum + entry.moodValue);
      moodAverage = total / moodEntries.length;
    }
    
    // Calculate habit completion rate
    double habitCompletionRate = 0.0;
    if (habits.isNotEmpty) {
      final completedToday = habits.where((habit) => !habit.shouldBeCompletedToday()).length;
      habitCompletionRate = (completedToday / habits.length) * 100;
    }
    
    return {
      'total_journal_entries': journalEntries.length,
      'total_mood_entries': moodEntries.length,
      'active_habits': habits.length,
      'mood_average': moodAverage,
      'habit_completion_rate': habitCompletionRate,
      'current_streak': habits.isNotEmpty 
          ? habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b)
          : 0,
    };
  }
  
  // Cleanup
  Future<void> close() async {
    await _journalBox.close();
    await _moodBox.close();
    await _habitBox.close();
    await _settingsBox.close();
  }
  
  Future<void> clearAllData() async {
    await _journalBox.clear();
    await _moodBox.clear();
    await _habitBox.clear();
    await _settingsBox.clear();
  }
  
  // ===== CLOUD SYNC =====
  
  /// Sync all local data to Firebase Firestore
  Future<void> syncAllToCloud() async {
    if (!_firebase.isLoggedIn) return;
    try {
      await _firebase.syncAllLocalData(
        journals: _journalBox.values.toList(),
        moods: _moodBox.values.toList(),
        habits: _habitBox.values.toList(),
      );
    } catch (e) {
      print('Full sync error: $e');
    }
  }
  
  /// Download cloud data and merge into local Hive
  Future<void> syncFromCloud() async {
    if (!_firebase.isLoggedIn) return;
    try {
      // Sync journals
      final cloudJournals = await _firebase.fetchJournalFromCloud();
      for (final data in cloudJournals) {
        final entry = JournalEntry.fromMap(Map<String, dynamic>.from(data));
        if (!_journalBox.containsKey(entry.id)) {
          await _journalBox.put(entry.id, entry);
        }
      }
      
      // Sync moods
      final cloudMoods = await _firebase.fetchMoodFromCloud();
      for (final data in cloudMoods) {
        final entry = MoodEntry.fromMap(Map<String, dynamic>.from(data));
        if (!_moodBox.containsKey(entry.id)) {
          await _moodBox.put(entry.id, entry);
        }
      }
      
      // Sync habits
      final cloudHabits = await _firebase.fetchHabitsFromCloud();
      for (final data in cloudHabits) {
        final habit = Habit.fromMap(Map<String, dynamic>.from(data));
        if (!_habitBox.containsKey(habit.id)) {
          await _habitBox.put(habit.id, habit);
        }
      }
    } catch (e) {
      print('Cloud download error: $e');
    }
  }
}