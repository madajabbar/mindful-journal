import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 1)
class MoodEntry extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String mood;
  
  @HiveField(2)
  DateTime date;
  
  @HiveField(3)
  String note;
  
  @HiveField(4)
  List<String> factors;
  
  @HiveField(5)
  int intensity;
  
  MoodEntry({
    required this.id,
    required this.mood,
    required this.date,
    this.note = '',
    this.factors = const [],
    this.intensity = 3,
  });
  
  factory MoodEntry.create({
    required String mood,
    String note = '',
    List<String> factors = const [],
    int intensity = 3,
  }) {
    final now = DateTime.now();
    return MoodEntry(
      id: 'mood_${now.millisecondsSinceEpoch}',
      mood: mood,
      date: now,
      note: note,
      factors: factors,
      intensity: intensity,
    );
  }
  
  factory MoodEntry.daily(DateTime date, {String mood = '😐'}) {
    return MoodEntry(
      id: 'mood_${date.millisecondsSinceEpoch}',
      mood: mood,
      date: date,
      note: '',
      factors: [],
      intensity: 3,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'date': date.toIso8601String(),
      'note': note,
      'factors': factors,
      'intensity': intensity,
    };
  }
  
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      mood: map['mood'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      factors: List<String>.from(map['factors']),
      intensity: map['intensity'],
    );
  }
  
  int get moodValue {
    switch (mood) {
      case '😢':
        return 1;
      case '😐':
        return 2;
      case '🙂':
        return 3;
      case '😊':
        return 4;
      case '🥰':
        return 5;
      default:
        return 3;
    }
  }
}