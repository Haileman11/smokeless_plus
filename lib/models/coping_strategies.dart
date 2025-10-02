class CopingStrategy {
  final int id;
  final String title;
  final String description;
  final String icon;
  final int color;
  final String duration;
  final String effectiveness;

  const CopingStrategy({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.duration,
    required this.effectiveness,
  });

  factory CopingStrategy.fromMap(Map<String, dynamic> map) {
    return CopingStrategy(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      icon: map['icon'],
      color: map['color'],
      duration: map['duration'],
      effectiveness: map['effectiveness'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color,
      'duration': duration,
      'effectiveness': effectiveness,
    };
  }
}
