class UserProfile {
  final DateTime quitDate;
  final String quitTime;
  final int baselineCigsPerDay;
  final double pricePerPack;
  final int cigsPerPack;
  final int yearsSmoking;
  final String currency;
  final String reasonForQuitting;
  final String timezone;
  final double avgMinutesPerCig;

  UserProfile({
    required this.quitDate,
    required this.quitTime,
    required this.baselineCigsPerDay,
    required this.pricePerPack,
    required this.cigsPerPack,
    required this.yearsSmoking,
    required this.currency,
    required this.reasonForQuitting,
    required this.timezone,
    required this.avgMinutesPerCig,
  });

  Map<String, dynamic> toJson() => {
    'quitDate': quitDate.toIso8601String(),
    'quitTime': quitTime,
    'baselineCigsPerDay': baselineCigsPerDay,
    'pricePerPack': pricePerPack,
    'cigsPerPack': cigsPerPack,
    'yearsSmoking': yearsSmoking,
    'currency': currency,
    'reasonForQuitting': reasonForQuitting,
    'timezone': timezone,
    'avgMinutesPerCig': avgMinutesPerCig,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    quitDate: DateTime.parse(json['quitDate']),
    quitTime: json['quitTime'],
    baselineCigsPerDay: json['baselineCigsPerDay'],
    pricePerPack: json['pricePerPack'].toDouble(),
    cigsPerPack: json['cigsPerPack'],
    yearsSmoking: json['yearsSmoking'],
    currency: json['currency'],
    reasonForQuitting: json['reasonForQuitting'],
    timezone: json['timezone'],
    avgMinutesPerCig: json['avgMinutesPerCig'].toDouble(),
  );
}