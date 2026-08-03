import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/journal_entry.dart';
import '../data/models/mood_entry.dart';
import '../data/models/habit.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // Collections
  CollectionReference<Map<String, dynamic>> get _journalCollection =>
      _firestore.collection('users').doc(_uid).collection('journal_entries');

  CollectionReference<Map<String, dynamic>> get _moodCollection =>
      _firestore.collection('users').doc(_uid).collection('mood_entries');

  CollectionReference<Map<String, dynamic>> get _habitsCollection =>
      _firestore.collection('users').doc(_uid).collection('habits');

  // Check if logged in
  bool get isLoggedIn => _uid != null;

  // ===== JOURNAL =====

  Future<void> syncJournalToCloud(JournalEntry entry) async {
    if (!isLoggedIn) return;
    await _journalCollection.doc(entry.id).set({
      'title': entry.title,
      'content': entry.content,
      'mood': entry.mood,
      'tags': entry.tags,
      'isFavorite': entry.isFavorite,
      'createdAt': entry.createdAt.toIso8601String(),
      'updatedAt': entry.updatedAt.toIso8601String(),
    });
  }

  Future<void> deleteJournalFromCloud(String id) async {
    if (!isLoggedIn) return;
    await _journalCollection.doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> fetchJournalFromCloud() async {
    if (!isLoggedIn) return [];
    final snapshot = await _journalCollection.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  // ===== MOOD =====

  Future<void> syncMoodToCloud(MoodEntry entry) async {
    if (!isLoggedIn) return;
    await _moodCollection.doc(entry.id).set({
      'mood': entry.mood,
      'date': entry.date.toIso8601String(),
      'note': entry.note,
      'factors': entry.factors,
      'intensity': entry.intensity,
    });
  }

  Future<void> deleteMoodFromCloud(String id) async {
    if (!isLoggedIn) return;
    await _moodCollection.doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> fetchMoodFromCloud() async {
    if (!isLoggedIn) return [];
    final snapshot = await _moodCollection.orderBy('date', descending: true).get();
    return snapshot.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  // ===== HABITS =====

  Future<void> syncHabitToCloud(Habit habit) async {
    if (!isLoggedIn) return;
    await _habitsCollection.doc(habit.id).set({
      'title': habit.title,
      'description': habit.description,
      'createdAt': habit.createdAt.toIso8601String(),
      'daysOfWeek': habit.daysOfWeek,
      'reminderTime': habit.reminderTime,
      'streak': habit.streak,
      'lastCompleted': habit.lastCompleted.toIso8601String(),
      'isActive': habit.isActive,
    });
  }

  Future<void> deleteHabitFromCloud(String id) async {
    if (!isLoggedIn) return;
    await _habitsCollection.doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> fetchHabitsFromCloud() async {
    if (!isLoggedIn) return [];
    final snapshot = await _habitsCollection.get();
    return snapshot.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  // ===== FULL SYNC =====

  /// Sync all local Hive data to Firestore
  Future<void> syncAllLocalData({
    required List<JournalEntry> journals,
    required List<MoodEntry> moods,
    required List<Habit> habits,
  }) async {
    if (!isLoggedIn) return;
    final batch = _firestore.batch();

    for (final entry in journals) {
      final ref = _journalCollection.doc(entry.id);
      batch.set(ref, {
        'title': entry.title,
        'content': entry.content,
        'mood': entry.mood,
        'tags': entry.tags,
        'isFavorite': entry.isFavorite,
        'createdAt': entry.createdAt.toIso8601String(),
        'updatedAt': entry.updatedAt.toIso8601String(),
      });
    }

    for (final entry in moods) {
      final ref = _moodCollection.doc(entry.id);
      batch.set(ref, {
        'mood': entry.mood,
        'date': entry.date.toIso8601String(),
        'note': entry.note,
        'factors': entry.factors,
        'intensity': entry.intensity,
      });
    }

    for (final habit in habits) {
      final ref = _habitsCollection.doc(habit.id);
      batch.set(ref, {
        'title': habit.title,
        'description': habit.description,
        'createdAt': habit.createdAt.toIso8601String(),
        'daysOfWeek': habit.daysOfWeek,
        'reminderTime': habit.reminderTime,
        'streak': habit.streak,
        'lastCompleted': habit.lastCompleted.toIso8601String(),
        'isActive': habit.isActive,
      });
    }

    await batch.commit();
  }
}
