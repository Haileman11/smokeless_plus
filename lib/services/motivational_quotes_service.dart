import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Service for managing daily motivational quotes with automatic refresh
class MotivationalQuotesService {
  static const String _keyMorningQuoteIndex = 'morning_quote_index';
  static const String _keyEveningQuoteIndex = 'evening_quote_index';
  static const String _keyLastMorningUpdate = 'last_morning_update';
  static const String _keyLastEveningUpdate = 'last_evening_update';

  /// Get a quote that refreshes automatically 2 times per day (morning and evening)
  static Future<Map<String, String>> getDailyMotivationalQuote() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final isMorning = now.hour >= 6 && now.hour < 18;

    return isMorning
        ? await _getMorningQuote(prefs, now)
        : await _getEveningQuote(prefs, now);
  }

  static Future<Map<String, String>> _getMorningQuote(
    SharedPreferences prefs,
    DateTime now,
  ) async {
    final lastUpdate = prefs.getString(_keyLastMorningUpdate);
    final currentIndex = prefs.getInt(_keyMorningQuoteIndex) ?? 0;

    bool shouldRefresh = lastUpdate == null ||
        DateTime.parse(lastUpdate).day != now.day;

    int newIndex = currentIndex;
    final totalQuotes = DynamicLocalization().quoteCount;

    if (shouldRefresh) {
      newIndex = _generateNewQuoteIndex(currentIndex, totalQuotes);
      await prefs.setInt(_keyMorningQuoteIndex, newIndex);
      await prefs.setString(_keyLastMorningUpdate, now.toIso8601String());
    }

    return DynamicLocalization().getQuoteByIndex(newIndex);
  }

  static Future<Map<String, String>> _getEveningQuote(
    SharedPreferences prefs,
    DateTime now,
  ) async {
    final lastUpdate = prefs.getString(_keyLastEveningUpdate);
    final currentIndex = prefs.getInt(_keyEveningQuoteIndex) ?? 1;
    final morningIndex = prefs.getInt(_keyMorningQuoteIndex) ?? 0;

    bool shouldRefresh = lastUpdate == null ||
        DateTime.parse(lastUpdate).day != now.day;

    int newIndex = currentIndex;
    final totalQuotes = DynamicLocalization().quoteCount;

    if (shouldRefresh) {
      newIndex = _generateNewQuoteIndex(currentIndex, totalQuotes,
          avoidIndex: morningIndex);
      await prefs.setInt(_keyEveningQuoteIndex, newIndex);
      await prefs.setString(_keyLastEveningUpdate, now.toIso8601String());
    }

    return DynamicLocalization().getQuoteByIndex(newIndex);
  }

  static int _generateNewQuoteIndex(int previousIndex, int totalQuotes,
      {int? avoidIndex}) {
    final random = Random();
    int newIndex = previousIndex;

    if (totalQuotes <= 1) return newIndex;

    do {
      newIndex = random.nextInt(totalQuotes);
    } while (newIndex == previousIndex ||
        (avoidIndex != null && newIndex == avoidIndex));

    return newIndex;
  }

  /// Force refresh the quote (manual override)
  static Future<Map<String, String>> forceRefreshQuote() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final isMorning = now.hour >= 6 && now.hour < 18;

    final totalQuotes = DynamicLocalization().quoteCount;
    final currentIndex = isMorning
        ? prefs.getInt(_keyMorningQuoteIndex) ?? 0
        : prefs.getInt(_keyEveningQuoteIndex) ?? 1;

    final avoidIndex =
        isMorning ? null : prefs.getInt(_keyMorningQuoteIndex) ?? 0;

    final newIndex = _generateNewQuoteIndex(currentIndex, totalQuotes,
        avoidIndex: avoidIndex);

    if (isMorning) {
      await prefs.setInt(_keyMorningQuoteIndex, newIndex);
      await prefs.setString(_keyLastMorningUpdate, now.toIso8601String());
    } else {
      await prefs.setInt(_keyEveningQuoteIndex, newIndex);
      await prefs.setString(_keyLastEveningUpdate, now.toIso8601String());
    }

    return DynamicLocalization().getQuoteByIndex(newIndex);
  }

  /// Get total number of available quotes
  static int getTotalQuotesCount() {
    return DynamicLocalization().quoteCount;
  }

  /// Get info about refresh schedule
  static Future<Map<String, dynamic>> getQuoteScheduleInfo() async {
    final now = DateTime.now();
    final isMorning = now.hour >= 6 && now.hour < 18;

    DateTime nextRefreshTime;
    String nextRefreshPeriod;

    if (isMorning) {
      nextRefreshTime = DateTime(now.year, now.month, now.day, 18);
      nextRefreshPeriod = 'Evening';
    } else {
      final tomorrow = now.add(Duration(days: 1));
      nextRefreshTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 6);
      nextRefreshPeriod = 'Morning';
    }

    final duration = nextRefreshTime.difference(now);

    return {
      'currentPeriod': isMorning ? 'Morning' : 'Evening',
      'nextRefreshTime': nextRefreshTime,
      'nextRefreshPeriod': nextRefreshPeriod,
      'hoursUntilRefresh': duration.inHours,
      'minutesUntilRefresh': duration.inMinutes % 60,
      'totalQuotes': DynamicLocalization().quoteCount,
      'refreshFrequency': '2 times per day (6 AM & 6 PM)',
    };
  }

  /// Clear all preferences (for testing/reset)
  static Future<void> clearQuotePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyMorningQuoteIndex);
    await prefs.remove(_keyEveningQuoteIndex);
    await prefs.remove(_keyLastMorningUpdate);
    await prefs.remove(_keyLastEveningUpdate);
  }
}

// lib/services/dynamic_localization.dart



class DynamicLocalization {
  static final DynamicLocalization _instance = DynamicLocalization._internal();

  factory DynamicLocalization() => _instance;

  DynamicLocalization._internal();

  late Map<String, dynamic> _translations;

  Future<void> load(String localeCode) async {
    try {
      final path = 'assets/l10n/intl_$localeCode.arb';
      final jsonString = await rootBundle.loadString(path);
      _translations = json.decode(jsonString);
    } catch (e) {
      // Fallback to English if loading fails
      print('Error loading localization for $localeCode, falling back to English.');
      final fallbackPath = 'assets/l10n/intl_en.arb';
      final fallbackJsonString = await rootBundle.loadString(fallbackPath);
      _translations = json.decode(fallbackJsonString);
    }
  }

  String? lookup(String key) => _translations[key];

  int get quoteCount {
    return _translations.keys
        .where((k) => k.startsWith('quote_') && k.endsWith('_message'))
        .length;
  }  

  Map<String, String> getQuoteByIndex(int index) {
    final paddedIndex = index.toString().padLeft(3, '0');
    return {
      "message": lookup("quote_${paddedIndex}_message") ?? "",
      "author": lookup("quote_${paddedIndex}_author") ?? "",
    };
  }
  
  Map<String, String> getAchievement(String id) {
    
    return {
      "title": lookup("${id}_title") ?? "",
      "description": lookup("${id}_description") ?? "",
      "unlockMessage": lookup("${id}_unlockMessage") ?? "",
    };
  }

  Map<String, String> getDetailedHealthMilestones(String id) {

    return {
      "timeframe": lookup("${id}_timeframe") ?? "",
      "title": lookup("${id}_title") ?? "",
      "description": lookup("${id}_description") ?? "",
      "scientificBasis": lookup("${id}_scientificBasis") ?? "",
    };
  }
}
