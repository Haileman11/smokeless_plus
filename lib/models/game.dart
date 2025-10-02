class Game {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String duration;
  final String difficulty;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.duration,
    required this.difficulty,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      duration: json['duration'] as String,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'duration': duration,
      'difficulty': difficulty,
    };
  }
}