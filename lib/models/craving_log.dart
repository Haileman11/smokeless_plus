enum CravingActionType { breathing, walk, game, call }

class CravingLog {
  final String id;
  final DateTime timestamp;
  final int intensity;
  final List<String> triggers;
  final CravingActionType actionTaken;
  final String outcome;

  CravingLog({
    required this.id,
    required this.timestamp,
    required this.intensity,
    required this.triggers,
    required this.actionTaken,
    required this.outcome,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'intensity': intensity,
    'triggers': triggers,
    'actionTaken': actionTaken.name,
    'outcome': outcome,
  };

  factory CravingLog.fromJson(Map<String, dynamic> json) => CravingLog(
    id: json['id'],
    timestamp: DateTime.parse(json['timestamp']),
    intensity: json['intensity'],
    triggers: List<String>.from(json['triggers']),
    actionTaken: CravingActionType.values.firstWhere((e) => e.name == json['actionTaken']),
    outcome: json['outcome'],
  );
}