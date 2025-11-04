class Activity {
  final String id;
  final String name;
  final String category;
  final int duration; // en minutes
  final bool done;
  final String? note;

  Activity({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.done,
    this.note,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'category': category,
    'duration': duration,
    'done': done,
    'note': note,
  };

  static Activity fromDoc(String id, Map<String, dynamic> m) => Activity(
    id: id,
    name: m['name'] ?? '',
    category: m['category'] ?? '',
    duration: (m['duration'] ?? 0) as int,
    done: (m['done'] ?? false) as bool,
    note: m['note'],
  );
}
