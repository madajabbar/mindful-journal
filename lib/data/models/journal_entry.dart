import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String content;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  DateTime updatedAt;
  
  @HiveField(5)
  List<String> tags;
  
  @HiveField(6)
  String mood;
  
  @HiveField(7)
  bool isFavorite;
  
  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.mood = '😐',
    this.isFavorite = false,
  });
  
  factory JournalEntry.create({
    required String title,
    required String content,
    List<String> tags = const [],
    String mood = '😐',
  }) {
    final now = DateTime.now();
    return JournalEntry(
      id: 'entry_${now.millisecondsSinceEpoch}',
      title: title,
      content: content,
      tags: tags,
      mood: mood,
      createdAt: now,
      updatedAt: now,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'mood': mood,
      'isFavorite': isFavorite,
    };
  }
  
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      tags: List<String>.from(map['tags']),
      mood: map['mood'],
      isFavorite: map['isFavorite'],
    );
  }
}