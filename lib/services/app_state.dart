import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/reward.dart';
import '../models/journal_entry.dart';
import '../models/craving_log.dart';
import 'storage_service.dart';
import 'statistics_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();
  
  UserProfile? _profile;
  List<Reward> _rewards = [];
  List<JournalEntry> _journalEntries = [];
  List<CravingLog> _cravingLogs = [];
  bool _hasCompletedOnboarding = false;
  Timer? _timer;
  String _currentLanguage = 'en';

  // Getters
  UserProfile? get profile => _profile;
  List<Reward> get rewards => _rewards;
  List<JournalEntry> get journalEntries => _journalEntries;
  List<CravingLog> get cravingLogs => _cravingLogs;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  String get currentLanguage => _currentLanguage;

  Future<void> initialize() async {
    await loadAllData();
    startRealTimeUpdates();
  }

  Future<void> loadAllData() async {
    // Load all data from storage
    _profile = await _storage.loadProfile();
    _rewards = await _storage.loadRewards();
    _journalEntries = await _storage.loadJournalEntries();
    _cravingLogs = await _storage.loadCravingLogs();
    _hasCompletedOnboarding = await _storage.isOnboardingCompleted();
    _currentLanguage = await _storage.loadLanguage();
    
    notifyListeners();
  }

  void startRealTimeUpdates() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => notifyListeners());
  }

  // Profile management
  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
    _hasCompletedOnboarding = true;
    
    await _storage.saveProfile(profile);
    await _storage.setOnboardingCompleted(true);
    
    notifyListeners();
  }

  // Rewards management
  Future<void> addReward(String title, double costAmount, String currency) async {
    final reward = Reward(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      costAmount: costAmount,
      currency: currency,
      createdAt: DateTime.now(),
    );
    
    _rewards.add(reward);
    await _storage.saveRewards(_rewards);
    notifyListeners();
  }

  Future<void> redeemReward(String rewardId) async {
    final index = _rewards.indexWhere((r) => r.id == rewardId);
    if (index != -1) {
      _rewards[index] = Reward(
        id: _rewards[index].id,
        title: _rewards[index].title,
        costAmount: _rewards[index].costAmount,
        currency: _rewards[index].currency,
        createdAt: _rewards[index].createdAt,
        redeemedAt: DateTime.now(),
      );
      await _storage.saveRewards(_rewards);
      notifyListeners();
    }
  }

  Future<void> deleteReward(String rewardId) async {
    _rewards.removeWhere((r) => r.id == rewardId);
    await _storage.saveRewards(_rewards);
    notifyListeners();
  }

  // Journal management
  Future<void> addJournalEntry(MoodType? mood, String notes, DateTime date) async {
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: mood,
      notes: notes,
      date: date,
      createdAt: DateTime.now(),
    );
    
    _journalEntries.insert(0, entry); // Add to beginning for recent entries first
    
    // Keep only last 100 entries to prevent storage bloat
    if (_journalEntries.length > 100) {
      _journalEntries = _journalEntries.take(100).toList();
    }
    
    await _storage.saveJournalEntries(_journalEntries);
    notifyListeners();
  }

  // Craving logs management
  Future<void> addCravingLog(CravingActionType actionTaken, {
    int intensity = 3,
    List<String> triggers = const [],
    String outcome = 'success',
  }) async {
    final log = CravingLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      intensity: intensity,
      triggers: triggers,
      actionTaken: actionTaken,
      outcome: outcome,
    );
    
    _cravingLogs.insert(0, log); // Add to beginning for recent logs first
    
    // Keep only last 50 logs to prevent storage bloat
    if (_cravingLogs.length > 50) {
      _cravingLogs = _cravingLogs.take(50).toList();
    }
    
    await _storage.saveCravingLogs(_cravingLogs);
    notifyListeners();
  }

  // Language management
  Future<void> changeLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    await _storage.saveLanguage(languageCode);
    notifyListeners();
  }

  // Statistics
  Map<String, dynamic> getQuitStats() {
    if (_profile == null) return {};
    return StatisticsService.calculateQuitStats(_profile!);
  }

  String getPersonalizedInsight() {
    if (_profile == null) return "You're doing amazing! Keep up the great work!";
    final stats = getQuitStats();
    return StatisticsService.getPersonalizedInsight(_profile!, stats);
  }

  double getHealthProgress(int minutesAfterQuit) {
    if (_profile == null) return 0.0;
    return StatisticsService.getHealthProgress(_profile!, minutesAfterQuit);
  }

  bool isHealthMilestoneAchieved(int minutesAfterQuit) {
    if (_profile == null) return false;
    return StatisticsService.isHealthMilestoneAchieved(_profile!, minutesAfterQuit);
  }

  // Data management
  Future<void> clearAllData() async {
    _profile = null;
    _rewards.clear();
    _journalEntries.clear();
    _cravingLogs.clear();
    _hasCompletedOnboarding = false;
    
    // Clear from storage
    await _storage.clearAllData();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}