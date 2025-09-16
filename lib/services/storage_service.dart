import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/reward.dart';
import '../models/journal_entry.dart';
import '../models/craving_log.dart';

class StorageService {
  static const String _profileKey = 'user_profile';
  static const String _rewardsKey = 'user_rewards';
  static const String _journalKey = 'journal_entries';
  static const String _cravingLogsKey = 'craving_logs';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _languageKey = 'selected_language';

  // Profile
  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    if (profileJson != null) {
      try {
        return UserProfile.fromJson(jsonDecode(profileJson));
      } catch (e) {
        print('Error loading profile: $e');
        return null;
      }
    }
    return null;
  }

  // Rewards
  Future<void> saveRewards(List<Reward> rewards) async {
    final prefs = await SharedPreferences.getInstance();
    final rewardsJson = jsonEncode(rewards.map((r) => r.toJson()).toList());
    await prefs.setString(_rewardsKey, rewardsJson);
  }

  Future<List<Reward>> loadRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final rewardsJson = prefs.getString(_rewardsKey);
    if (rewardsJson != null) {
      try {
        final List<dynamic> rewardsList = jsonDecode(rewardsJson);
        return rewardsList.map((json) => Reward.fromJson(json)).toList();
      } catch (e) {
        print('Error loading rewards: $e');
        return [];
      }
    }
    return [];
  }

  // Journal entries
  Future<void> saveJournalEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_journalKey, entriesJson);
  }

  Future<List<JournalEntry>> loadJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_journalKey);
    if (entriesJson != null) {
      try {
        final List<dynamic> entriesList = jsonDecode(entriesJson);
        return entriesList.map((json) => JournalEntry.fromJson(json)).toList();
      } catch (e) {
        print('Error loading journal entries: $e');
        return [];
      }
    }
    return [];
  }

  // Craving logs
  Future<void> saveCravingLogs(List<CravingLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = jsonEncode(logs.map((l) => l.toJson()).toList());
    await prefs.setString(_cravingLogsKey, logsJson);
  }

  Future<List<CravingLog>> loadCravingLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getString(_cravingLogsKey);
    if (logsJson != null) {
      try {
        final List<dynamic> logsList = jsonDecode(logsJson);
        return logsList.map((json) => CravingLog.fromJson(json)).toList();
      } catch (e) {
        print('Error loading craving logs: $e');
        return [];
      }
    }
    return [];
  }

  // Onboarding status
  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, completed);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  // Language preference
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}