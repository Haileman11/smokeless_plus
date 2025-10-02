class Reward {
  final int id;
  final String title;
  final String description;
  final int points;
  final String icon;
  final bool available;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.available,
  });

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      points: map['points'] as int,
      icon: map['icon'] as String,
      available: map['available'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'icon': icon,
      'available': available,
    };
  }
}

// Example of creating a Reward instance from a map.
final reward = Reward.fromMap({
  'id': 1,
  'title': 'Premium Motivational Content',
  'description': 'Access exclusive daily motivational quotes and success stories',
  'points': 500,
  'icon': 'auto_stories',
  'available': true,
});