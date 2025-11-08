import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String name;
  final String? note;
  final String category;
  final int duration;
  final bool done;
  final Timestamp createdAt;

  Activity({
    required this.id,
    required this.name,
    this.note,
    required this.category,
    required this.duration,
    this.done = false,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'note': note,
      'category': category,
      'duration': duration,
      'done': done,
      'createdAt': createdAt,
    };
  }

  factory Activity.fromDoc(String id, Map<String, dynamic> data) {
    return Activity(
      id: id,
      name: data['name'] ?? '',
      note: data['note'],
      category: data['category'] ?? 'autre',
      duration: data['duration'] ?? 0,
      done: data['done'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(), // ✅ FIX ICI
    );
  }
}
