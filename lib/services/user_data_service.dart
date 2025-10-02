import 'package:shared_preferences/shared_preferences.dart';
import 'package:smokeless_plus/services/motivational_quotes_service.dart';

/// Service class for managing user data and quit-smoking calculations
class UserDataService {
  static const String _keyQuitDate = 'quit_date';
  static const String _keyCigarettesPerDay = 'cigarettes_per_day';
  static const String _keyCostPerPack = 'cost_per_pack';
  static const String _keyCigarettesPerPack = 'cigarettes_per_pack';
  static const String _keyUserName = 'user_name';
  static const String _keyYearsSmoking =
      'years_smoking'; // New field for years of smoking
  static const String _keyCurrency = 'currency';

  /// Calculate various metrics based on user's quit data
  static Map<String, dynamic> calculateQuittingMetrics({
    required DateTime quitDate,
    required int cigarettesPerDay,
    required double costPerPack,
    int cigarettesPerPack = 20,
    double yearsSmoking = 0.0, // New parameter for years of smoking
  }) {
    final now = DateTime.now();
    final timeDifference = now.difference(quitDate);

    // Handle different scenarios for quit date
    bool hasStartedQuitting = now.isAfter(quitDate);

    // Time calculations - only positive if user has actually started quitting
    final daysSinceQuit = hasStartedQuitting ? timeDifference.inDays : 0;
    final totalHours = hasStartedQuitting ? timeDifference.inHours : 0;
    final totalMinutes = hasStartedQuitting ? timeDifference.inMinutes : 0;
    final totalSeconds = hasStartedQuitting ? timeDifference.inSeconds : 0;

    // Precise time calculations for animated counter
    final daysDisplay = daysSinceQuit;
    final hoursDisplay = totalHours % 24;
    final minutesDisplay = totalMinutes % 60;
    final secondsDisplay = totalSeconds % 60;

    // Core calculations - only calculate if user has started quitting
    final cigarettesAvoided = hasStartedQuitting
        ? daysSinceQuit * cigarettesPerDay +
            ((totalHours % 24) * cigarettesPerDay / 24).floor()
        : 0;

    // Calculate money saved correctly based on cigarettes avoided
    final costPerCigarette = costPerPack / cigarettesPerPack;
    final moneySaved =
        hasStartedQuitting ? cigarettesAvoided * costPerCigarette : 0.0;

    // NEW: Calculate total cigarettes smoked during smoking period
    final totalDaysSmoking =
        (yearsSmoking * 365.25).round(); // Include leap years
    final totalCigarettesSmoked = totalDaysSmoking * cigarettesPerDay;
    final totalMoneySpent = totalCigarettesSmoked * costPerCigarette;

    // Health progress calculation (0-100% based on various milestones)
    double healthProgress = 0.0;
    if (!hasStartedQuitting) {
      healthProgress = 0.0;
    } else {
      // Time-based health milestones (more granular for early stages)
      if (totalHours >= 1)
        healthProgress = 5.0; // 1 hour: Nicotine levels dropping
      if (totalHours >= 12)
        healthProgress = 15.0; // 12 hours: Carbon monoxide normalizing
      if (totalHours >= 24)
        healthProgress = 25.0; // 1 day: Heart attack risk decreasing
      if (totalHours >= 72)
        healthProgress = 35.0; // 3 days: Nicotine eliminated
      if (daysSinceQuit >= 7)
        healthProgress = 45.0; // 1 week: Taste and smell improving
      if (daysSinceQuit >= 14)
        healthProgress = 55.0; // 2 weeks: Circulation improving
      if (daysSinceQuit >= 30)
        healthProgress = 65.0; // 1 month: Lung function increasing
      if (daysSinceQuit >= 90)
        healthProgress = 75.0; // 3 months: Major lung improvement
      if (daysSinceQuit >= 365)
        healthProgress = 85.0; // 1 year: Heart disease risk halved
      if (daysSinceQuit >= 1825)
        healthProgress = 95.0; // 5 years: Stroke risk normalized
      if (daysSinceQuit >= 3650)
        healthProgress = 100.0; // 10 years: Cancer risk halved
    }

    // Determine current health stage and next milestone
    String healthStage;
    String nextMilestone;
    String timeToNext;

    if (!hasStartedQuitting) {
      healthStage = "Ready to Begin";
      nextMilestone = "Start Your Journey";
      final hoursUntilStart = quitDate.difference(now).inHours;
      final daysUntilStart = quitDate.difference(now).inDays;
      if (daysUntilStart > 0) {
        timeToNext = "In $daysUntilStart day${daysUntilStart == 1 ? '' : 's'}";
      } else if (hoursUntilStart > 0) {
        timeToNext =
            "In $hoursUntilStart hour${hoursUntilStart == 1 ? '' : 's'}";
      } else {
        timeToNext = "Soon";
      }
    } else if (totalHours < 1) {
      healthStage = "Journey Begins";
      nextMilestone = "Nicotine Levels Dropping";
      timeToNext = "In ${60 - (totalMinutes % 60)} minutes";
    } else if (totalHours < 12) {
      healthStage = "Nicotine Dropping";
      nextMilestone = "Carbon Monoxide Clearing";
      timeToNext = "In ${12 - (totalHours % 24)} hours";
    } else if (totalHours < 24) {
      healthStage = "CO Levels Normalizing";
      nextMilestone = "Heart Attack Risk Decreasing";
      timeToNext = "In ${24 - (totalHours % 24)} hours";
    } else if (totalHours < 72) {
      healthStage = "Heart Risk Decreasing";
      nextMilestone = "Nicotine Elimination";
      timeToNext = "In ${72 - totalHours} hours";
    } else if (daysSinceQuit < 7) {
      healthStage = "Nicotine Free Body";
      nextMilestone = "Taste & Smell Revival";
      timeToNext = "In ${7 - daysSinceQuit} days";
    } else if (daysSinceQuit < 14) {
      healthStage = "Senses Improving";
      nextMilestone = "Circulation Boost";
      timeToNext = "In ${14 - daysSinceQuit} days";
    } else if (daysSinceQuit < 30) {
      healthStage = "Circulation Improving";
      nextMilestone = "Lung Function Boost";
      timeToNext = "In ${30 - daysSinceQuit} days";
    } else if (daysSinceQuit < 90) {
      healthStage = "Lung Function Improving";
      nextMilestone = "Major Lung Recovery";
      timeToNext = "In ${90 - daysSinceQuit} days";
    } else if (daysSinceQuit < 365) {
      healthStage = "Significant Recovery";
      nextMilestone = "Heart Risk Halved";
      timeToNext = "In ${365 - daysSinceQuit} days";
    } else if (daysSinceQuit < 1825) {
      healthStage = "Heart Disease Risk Reduced";
      nextMilestone = "Stroke Risk Normalized";
      timeToNext = "In ${1825 - daysSinceQuit} days";
    } else if (daysSinceQuit < 3650) {
      healthStage = "Stroke Risk Normalized";
      nextMilestone = "Cancer Risk Halved";
      timeToNext = "In ${3650 - daysSinceQuit} days";
    } else {
      healthStage = "Maximum Health Recovery";
      nextMilestone = "Maintaining Excellence";
      timeToNext = "Achieved";
    }

    return {
      "currentStreak": daysSinceQuit,
      "cigarettesAvoided": cigarettesAvoided,
      "moneySaved": moneySaved,
      "healthProgress": healthProgress / 100.0, // Convert to 0-1 scale
      "healthStage": healthStage,
      "nextMilestone": nextMilestone,
      "timeToNext": timeToNext,
      "costPerCigarette": costPerCigarette,
      "hasStartedQuitting": hasStartedQuitting,
      "quitDateFormatted": quitDate.toIso8601String(),
      // NEW: Add smoking history calculations
      "yearsSmoking": yearsSmoking,
      "totalCigarettesSmoked": totalCigarettesSmoked,
      "totalMoneySpent": totalMoneySpent,
      "smokingPeriodDays": totalDaysSmoking,
      // Precise time fields for animated counter
      "preciseTimeData": {
        "totalDays": daysDisplay,
        "hours": hoursDisplay,
        "minutes": minutesDisplay,
        "seconds": secondsDisplay,
        "totalHours": totalHours,
        "totalMinutes": totalMinutes,
        "totalSeconds": totalSeconds,
      },
    };
  }

  /// Calculate achievements based on actual user data
  static Map<String, dynamic> calculateDynamicAchievements({
    required DateTime quitDate,
    required int currentStreak,
    required double moneySaved,
    required int cigarettesAvoided,
    required bool hasStartedQuitting,
  }) {
    final now = DateTime.now();
    final timeDifference = now.difference(quitDate);
    final totalHours = hasStartedQuitting ? timeDifference.inHours : 0;

    List<Map<String, dynamic>> unlockedAchievements = [];
    List<Map<String, dynamic>> upcomingAchievements = [];
    int totalPoints = 0;

    // Define all achievements with their unlock criteria
    final List<Map<String, dynamic>> allAchievements = [
// Time-based achievements
      {
        'id': 'first_hour',
        'points': 25,
        'icon': 'access_time',
        'category': 'Streak',
        'unlockCondition': () => totalHours >= 1,
      },
      {
        'id': 'first_day',
        'points': 50,
        'icon': 'looks_one',
        'category': 'Streak',
        'unlockCondition': () => currentStreak >= 1,
      },
      {
        'id': 'first_week',
        'points': 100,
        'icon': 'calendar_view_week',
        'category': 'Streak',
        'unlockCondition': () => currentStreak >= 7,
      },
      {
        'id': 'first_month',
        'points': 250,
        'icon': 'calendar_month',
        'category': 'Streak',
        'unlockCondition': () => currentStreak >= 30,
      },
      {
        'id': 'hundred_days',
        'points': 500,
        'icon': 'military_tech',
        'category': 'Streak',
        'unlockCondition': () => currentStreak >= 100,
      },
      {
        'id': 'first_year',
        'points': 1000,
        'icon': 'emoji_events',
        'category': 'Streak',
        'unlockCondition': () => currentStreak >= 365,
      },

// Health achievements
      {
        'id': 'nicotine_drop',
        'points': 30,
        'icon': 'trending_down',
        'category': 'Health',
        'unlockCondition': () => totalHours >= 1,
      },
      {
        'id': 'co_normal',
        'points': 75,
        'icon': 'air',
        'category': 'Health',
        'unlockCondition': () => totalHours >= 12,
      },
      {
        'id': 'taste_revival',
        'points': 100,
        'icon': 'restaurant',
        'category': 'Health',
        'unlockCondition': () => totalHours >= 72,
      },
      {
        'id': 'lung_healing',
        'points': 200,
        'icon': 'healing',
        'category': 'Health',
        'unlockCondition': () => currentStreak >= 14,
      },

// Financial achievements
      {
        'id': 'first_10_saved',
        'title': 'First \$10 Saved',
        'points': 25,
        'icon': 'attach_money',
        'category': 'Financial',
        'unlockCondition': () => moneySaved >= 10,
      },
      {
        'id': 'hundred_saved',
        'points': 100,
        'icon': 'savings',
        'category': 'Financial',
        'unlockCondition': () => moneySaved >= 100,
        'unlockMessage': 'Unlocked after saving \$100',
      },
      {
        'id': 'five_hundred_saved',
        'points': 250,
        'icon': 'account_balance_wallet',
        'category': 'Financial',
        'unlockCondition': () => moneySaved >= 500,
      },
      {
        'id': 'thousand_saved',
        'points': 500,
        'icon': 'monetization_on',
        'category': 'Financial',
        'unlockCondition': () => moneySaved >= 1000,
      },

// Cigarette avoidance achievements
      {
        'id': 'first_pack_avoided',
        'points': 50,
        'icon': 'smoke_free',
        'category': 'Progress',
        'unlockCondition': () => cigarettesAvoided >= 20,
      },
      {
        'id': 'carton_avoided',
        'points': 150,
        'icon': 'inventory_2',
        'category': 'Progress',
        'unlockCondition': () => cigarettesAvoided >= 200,
      },
    ].map((toElement) {
      return {
        ...toElement,
        'title': DynamicLocalization()
            .getAchievement(toElement['id'] as String)["title"] as String,
        'description': DynamicLocalization()
            .getAchievement(toElement['id'] as String)["description"] as String,
        'unlockMessage': DynamicLocalization()
                .getAchievement(toElement['id'] as String)["unlockMessage"]
            as String,
      };
    }).toList();

    // Process each achievement
    for (var achievement in allAchievements) {
      bool isUnlocked = achievement['unlockCondition']();

      if (isUnlocked) {
        unlockedAchievements.add({
          ...achievement,
          'isUnlocked': true,
          'unlockDate': now.toIso8601String(),
        });
        totalPoints += achievement['points'] as int;
      } else {
        upcomingAchievements.add({...achievement, 'isUnlocked': false});
      }
    }

    // Calculate level based on points
    int currentLevel = (totalPoints / 200).floor() + 1;
    int pointsForCurrentLevel = ((currentLevel - 1) * 200);
    int pointsForNextLevel = (currentLevel * 200);
    int pointsToNextLevel = pointsForNextLevel - totalPoints;

    return {
      'unlockedAchievements': unlockedAchievements,
      'upcomingAchievements': upcomingAchievements,
      'totalPoints': totalPoints,
      'currentLevel': currentLevel,
      'pointsToNextLevel': pointsToNextLevel,
      'pointsForNextLevel': pointsForNextLevel,
      'totalAchievements': allAchievements.length,
      'unlockedCount': unlockedAchievements.length,
    };
  }

  /// Calculate enhanced health milestones with scientific basis
  static List<Map<String, dynamic>> getDetailedHealthMilestones({
    required DateTime quitDate,
    required bool hasStartedQuitting,
  }) {
    final now = DateTime.now();
    final timeDifference = now.difference(quitDate);
    final totalMinutes = hasStartedQuitting ? timeDifference.inMinutes : 0;
    final totalHours = hasStartedQuitting ? timeDifference.inHours : 0;
    final totalDays = hasStartedQuitting ? timeDifference.inDays : 0;

    final List<Map<String, dynamic>> milestones = [
      // Short-Term Milestones (First 48 Hours)
      {
        "id": "20_minutes",
        "icon": "favorite",
        "category": "Short-Term",
        "targetMinutes": 20,
        "isAchieved": totalMinutes >= 20,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 20 ? 1.0 : totalMinutes / 20)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          20,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 20
            ? quitDate.add(Duration(minutes: 20)).toIso8601String()
            : null,
      },
      {
        "id": "8_hours",
        "icon": "air",
        "category": "Short-Term",
        "targetMinutes": 480, // 8 hours
        "isAchieved": totalMinutes >= 480,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 480 ? 1.0 : totalMinutes / 480)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          480,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 480
            ? quitDate.add(Duration(minutes: 480)).toIso8601String()
            : null,
      },
      {
        "id": "24_hours",
        "icon": "monitor_heart",
        "category": "Short-Term",
        "targetMinutes": 1440, // 24 hours
        "isAchieved": totalMinutes >= 1440,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 1440 ? 1.0 : totalMinutes / 1440)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          1440,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 1440
            ? quitDate.add(Duration(minutes: 1440)).toIso8601String()
            : null,
      },
      {
        "id": "48_hours",
        "icon": "restaurant",
        "category": "Short-Term",
        "targetMinutes": 2880, // 48 hours
        "isAchieved": totalMinutes >= 2880,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 2880 ? 1.0 : totalMinutes / 2880)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          2880,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 2880
            ? quitDate.add(Duration(minutes: 2880)).toIso8601String()
            : null,
      },

      // Medium-Term Milestones (2 Weeks to 1 Year)
      {
        "id": "2_weeks",
        "icon": "healing",
        "category": "Medium-Term",
        "targetMinutes": 20160, // 14 days
        "isAchieved": totalMinutes >= 20160,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 20160 ? 1.0 : totalMinutes / 20160)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          20160,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 20160
            ? quitDate.add(Duration(minutes: 20160)).toIso8601String()
            : null,
      },
      {
        "id": "1_to_9_months",
        "icon": "self_improvement",
        "category": "Medium-Term",
        "targetMinutes": 43200, // 30 days
        "isAchieved": totalMinutes >= 43200,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 43200 ? 1.0 : totalMinutes / 43200)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          43200,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 43200
            ? quitDate.add(Duration(minutes: 43200)).toIso8601String()
            : null,
      },

      // Long-Term Milestones (1 to 10+ Years)
      {
        "id": "1_to_5_years",
        "icon": "health_and_safety",
        "category": "Long-Term",
        "targetMinutes": 525600, // 365 days
        "isAchieved": totalMinutes >= 525600,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 525600 ? 1.0 : totalMinutes / 525600)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          525600,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 525600
            ? quitDate.add(Duration(minutes: 525600)).toIso8601String()
            : null,
      },
      {
        "id": "10_years",
        "icon": "shield",
        "category": "Long-Term",
        "targetMinutes": 5256000, // 10 years
        "isAchieved": totalMinutes >= 5256000,
        "progress": hasStartedQuitting
            ? (totalMinutes >= 5256000 ? 1.0 : totalMinutes / 5256000)
            : 0.0,
        "countdownText": _getCountdownText(
          totalMinutes,
          5256000,
          hasStartedQuitting,
        ),
        "achievedDate": hasStartedQuitting && totalMinutes >= 5256000
            ? quitDate.add(Duration(minutes: 5256000)).toIso8601String()
            : null,
      },
    ].map((toElement) {
      return {
        ...toElement,
        'title': DynamicLocalization()
                .getDetailedHealthMilestones(toElement['id'] as String)["title"]
            as String,
        'description': DynamicLocalization().getDetailedHealthMilestones(
            toElement['id'] as String)["description"] as String,
        'timeframe': DynamicLocalization().getDetailedHealthMilestones(
            toElement['id'] as String)["timeframe"] as String,
        'scientificBasis': DynamicLocalization().getDetailedHealthMilestones(
            toElement['id'] as String)["scientificBasis"] as String,
      };
    }).toList();
    return milestones;
  }

  static String _getCountdownText(
    int currentMinutes,
    int targetMinutes,
    bool hasStartedQuitting,
  ) {
    if (!hasStartedQuitting) {
      return "Not Started";
    }

    if (currentMinutes >= targetMinutes) {
      return "Achieved";
    }

    final remainingMinutes = targetMinutes - currentMinutes;

    if (remainingMinutes < 60) {
      return "In ${remainingMinutes}m";
    } else if (remainingMinutes < 1440) {
      final hours = (remainingMinutes / 60).floor();
      return "In ${hours}h";
    } else if (remainingMinutes < 43200) {
      final days = (remainingMinutes / 1440).floor();
      return "In ${days}d";
    } else if (remainingMinutes < 525600) {
      final months = (remainingMinutes / 43200).floor();
      return "In ${months}mo";
    } else {
      final years = (remainingMinutes / 525600).floor();
      return "In ${years}y";
    }
  }

  /// Save user's quit smoking data to local storage
  static Future<bool> saveUserData({
    required DateTime quitDate,
    required int cigarettesPerDay,
    required double costPerPack,
    required String currency,
    int cigarettesPerPack = 20,
    String userName = 'User',
    double yearsSmoking = 0.0, // New parameter for years of smoking
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_keyQuitDate, quitDate.toIso8601String());
      await prefs.setInt(_keyCigarettesPerDay, cigarettesPerDay);
      await prefs.setDouble(_keyCostPerPack, costPerPack);
      await prefs.setInt(_keyCigarettesPerPack, cigarettesPerPack);
      await prefs.setString(_keyUserName, userName);
      await prefs.setDouble(
          _keyYearsSmoking, yearsSmoking); // Save years of smoking
      await prefs.setString(_keyCurrency, currency);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load user's quit smoking data from local storage
  static Future<Map<String, dynamic>?> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final quitDateStr = prefs.getString(_keyQuitDate);
      if (quitDateStr == null) return null;

      final quitDate = DateTime.parse(quitDateStr);
      final cigarettesPerDay = prefs.getInt(_keyCigarettesPerDay) ?? 20;
      final costPerPack = prefs.getDouble(_keyCostPerPack) ?? 12.50;
      final cigarettesPerPack = prefs.getInt(_keyCigarettesPerPack) ?? 20;
      final userName = prefs.getString(_keyUserName) ?? 'User';
      final yearsSmoking =
          prefs.getDouble(_keyYearsSmoking) ?? 0.0; // Load years of smoking
      final currency =
          prefs.getString(_keyCurrency) ?? 'USD'; // Default currency
      // Calculate current metrics with years of smoking
      final metrics = calculateQuittingMetrics(
        quitDate: quitDate,
        cigarettesPerDay: cigarettesPerDay,
        costPerPack: costPerPack,
        cigarettesPerPack: cigarettesPerPack,
        yearsSmoking: yearsSmoking,
      );

      // Calculate achievements based on current progress
      final achievements = calculateDynamicAchievements(
        quitDate: quitDate,
        currentStreak: metrics['currentStreak'],
        moneySaved: metrics['moneySaved'],
        cigarettesAvoided: metrics['cigarettesAvoided'],
        hasStartedQuitting: metrics['hasStartedQuitting'],
      );

      return {
        "name": userName,
        "quitDate": quitDate.toIso8601String(),
        "cigarettesPerDay": cigarettesPerDay,
        "costPerPack": costPerPack,
        "cigarettesPerPack": cigarettesPerPack,
        "yearsSmoking": yearsSmoking, // Include years of smoking in return data
        "currency": currency,
        ...metrics,
        "achievements": achievements,
      };
    } catch (e) {
      return null;
    }
  }

  /// Clear all user data
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyQuitDate);
      await prefs.remove(_keyCigarettesPerDay);
      await prefs.remove(_keyCostPerPack);
      await prefs.remove(_keyCigarettesPerPack);
      await prefs.remove(_keyUserName);
      await prefs.remove(_keyYearsSmoking); // Clear years of smoking
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if user data exists
  static Future<bool> hasUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_keyQuitDate);
    } catch (e) {
      return false;
    }
  }
}
