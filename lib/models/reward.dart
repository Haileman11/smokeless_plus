class Reward {
  final String id;
  final String title;
  final double costAmount;
  final String currency;
  final DateTime createdAt;
  final DateTime? redeemedAt;

  Reward({
    required this.id,
    required this.title,
    required this.costAmount,
    required this.currency,
    required this.createdAt,
    this.redeemedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'costAmount': costAmount,
    'currency': currency,
    'createdAt': createdAt.toIso8601String(),
    'redeemedAt': redeemedAt?.toIso8601String(),
  };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json['id'],
    title: json['title'],
    costAmount: json['costAmount'].toDouble(),
    currency: json['currency'],
    createdAt: DateTime.parse(json['createdAt']),
    redeemedAt: json['redeemedAt'] != null ? DateTime.parse(json['redeemedAt']) : null,
  );

  bool get isRedeemed => redeemedAt != null;
}