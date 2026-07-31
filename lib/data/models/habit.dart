import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  List<int> daysOfWeek; // 0=Sunday, 1=Monday, ..., 6=Saturday
  
  @HiveField(5)
  String reminderTime; // Format: "HH:MM"
  
  @HiveField(6)
  int streak;
  
  @HiveField(7)
  DateTime lastCompleted;
  
  @HiveField(8)
  bool isActive;
  
  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.daysOfWeek = const [0, 1, 2, 3, 4, 5, 6], // Everyday by default
    this.reminderTime = '',
    this.streak = 0,
    required this.lastCompleted,
    this.isActive = true,
  });
  
  factory Habit.create({
    required String title,
    required String description,
    List<int> daysOfWeek = const [0, 1, 2, 3, 4, 5, 6],
    String reminderTime = '',
  }) {
    final now = DateTime.now();
    return Habit(
      id: 'habit_${now.millisecondsSinceEpoch}',
      title: title,
      description: description,
      createdAt: now,
      daysOfWeek: daysOfWeek,
      reminderTime: reminderTime,
      streak: 0,
      lastCompleted: now.subtract(const Duration(days: 1)),
      isActive: true,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'daysOfWeek': daysOfWeek,
      'reminderTime': reminderTime,
      'streak': streak,
      'lastCompleted': lastCompleted.toIso8601String(),
      'isActive': isActive,
    };
  }
  
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      daysOfWeek: List<int>.from(map['daysOfWeek']),
      reminderTime: map['reminderTime'],
      streak: map['streak'],
      lastCompleted: DateTime.parse(map['lastCompleted']),
      isActive: map['isActive'],
    );
  }
  
  bool shouldBeCompletedToday() {
    final today = DateTime.now();
    final lastCompletionDate = DateTime(
      lastCompleted.year,
      lastCompleted.month,
      lastCompleted.day,
    );
    final todayDate = DateTime(today.year, today.month, today.day);
    
    // Check if habit is active and scheduled for today
    return isActive && 
           daysOfWeek.contains(today.weekday % 7) &&
           todayDate.isAfter(lastCompletionDate);
  }
  
  void markCompleted() {
    final today = DateTime.now();
    final lastCompletionDate = DateTime(
      lastCompleted.year,
      lastCompleted.month,
      lastCompleted.day,
    );
    final todayDate = DateTime(today.year, today.month, today.day);
    
    if (todayDate.isAfter(lastCompletionDate.add(const Duration(days: 1)))) {
      // Streak broken
      streak = 1;
    } else if (todayDate.isAfter(lastCompletionDate)) {
      // Continue streak
      streak++;
    }
    
    lastCompleted = today;
  }
  
  void resetStreak() {
    streak = 0;
    lastCompleted = DateTime.now().subtract(const Duration(days: 1));
  }
}