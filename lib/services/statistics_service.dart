import '../models/user_profile.dart';
import '../constants/currencies.dart';

class StatisticsService {
  static Map<String, dynamic> calculateQuitStats(UserProfile profile) {
    final now = DateTime.now();
    final quitDateTime = DateTime(
      profile.quitDate.year,
      profile.quitDate.month,
      profile.quitDate.day,
      int.parse(profile.quitTime.split(':')[0]),
      int.parse(profile.quitTime.split(':')[1]),
    );
    
    final timeDiff = now.difference(quitDateTime);
    
    if (timeDiff.isNegative) {
      return {
        'isInFuture': true,
        'timeUntilQuit': timeDiff.abs(),
      };
    }
    
    final days = timeDiff.inDays;
    final hours = timeDiff.inHours % 24;
    final minutes = timeDiff.inMinutes % 60;
    final totalMinutes = timeDiff.inMinutes;
    
    final cigsAvoided = (totalMinutes / profile.avgMinutesPerCig).floor();
    final pricePerCig = profile.pricePerPack / profile.cigsPerPack;
    final moneySaved = cigsAvoided * pricePerCig;
    
    final currencySymbol = currencySymbols[profile.currency] ?? profile.currency;
    
    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'totalMinutes': totalMinutes,
      'cigsAvoided': cigsAvoided,
      'moneySaved': moneySaved,
      'currencySymbol': currencySymbol,
      'totalTimeSmokeFree': '$days days, $hours hours',
      'daysSinceQuit': days,
      'isInFuture': false,
      'quitDateTime': quitDateTime,
    };
  }

  static String getPersonalizedInsight(UserProfile profile, Map<String, dynamic> stats) {
    final reason = profile.reasonForQuitting;
    final insights = {
      'health': "Your lung capacity is already improving! Keep breathing easy.",
      'family': "Every smoke-free day is a gift to your loved ones.",
      'fitness': "Your stamina is increasing day by day. Feel the difference!",
      'money': "You're saving ${stats['currencySymbol'] ?? '\$'}${(stats['moneySaved'] / (stats['daysSinceQuit'] ?? 1)).toStringAsFixed(2)} per day!",
      'child': "You're creating a healthier future for your family.",
      'freedom': "Each day brings you closer to complete freedom from addiction."
    };
    return insights[reason] ?? "You're doing amazing! Keep up the great work!";
  }

  static double getHealthProgress(UserProfile profile, int minutesAfterQuit) {
    final stats = calculateQuitStats(profile);
    final totalMinutes = stats['totalMinutes'] as int;
    
    if (totalMinutes >= minutesAfterQuit) {
      return 100.0;
    }
    
    return (totalMinutes / minutesAfterQuit * 100).clamp(0.0, 100.0);
  }

  static bool isHealthMilestoneAchieved(UserProfile profile, int minutesAfterQuit) {
    final stats = calculateQuitStats(profile);
    final totalMinutes = stats['totalMinutes'] as int;
    return totalMinutes >= minutesAfterQuit;
  }
}