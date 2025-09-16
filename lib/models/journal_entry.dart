enum MoodType { terrible, bad, okay, good, great }

class JournalEntry {
  final String id;
  final MoodType? mood;
  final String notes;
  final DateTime date;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    this.mood,
    required this.notes,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'mood': mood?.name,
    'notes': notes,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    mood: json['mood'] != null ? MoodType.values.firstWhere((e) => e.name == json['mood']) : null,
    notes: json['notes'],
    date: DateTime.parse(json['date']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}