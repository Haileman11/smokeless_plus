import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _keyLanguage = 'selected_language';

  /// Available languages in the app
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
    {'code': 'it', 'name': 'Italian', 'nativeName': 'Italiano'},
    {'code': 'pt', 'name': 'Portuguese', 'nativeName': 'Português'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
    {'code': 'zh', 'name': 'Chinese', 'nativeName': '中文'},
    {'code': 'ja', 'name': 'Japanese', 'nativeName': '日本語'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
  ];

  /// Get device default language
  static String getDeviceLanguage() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final languageCode = locale.languageCode;

    // Check if the device language is supported
    final supportedCodes =
        supportedLanguages.map((lang) => lang['code']).toList();
    if (supportedCodes.contains(languageCode)) {
      return languageCode;
    }

    // Default to English if device language is not supported
    return 'en';
  }

  /// Save selected language to local storage
  static Future<bool> saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLanguage, languageCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load selected language from local storage
  static Future<String> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_keyLanguage);

      if (savedLanguage != null) {
        return savedLanguage;
      }

      // If no language is saved, use device language
      return getDeviceLanguage();
    } catch (e) {
      // If error occurs, default to English
      return 'en';
    }
  }

  /// Get language name by code
  static String getLanguageName(String code) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    );
    return language['name']!;
  }

  /// Get native language name by code
  static String getNativeLanguageName(String code) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    );
    return language['nativeName']!;
  }

  /// Get locale from language code
  static Locale getLocale(String languageCode) {
    return Locale(languageCode);
  }

  /// Check if language is Right-to-Left (RTL)
  static bool isRTL(String languageCode) {
    const rtlLanguages = ['ar', 'he', 'fa', 'ur'];
    return rtlLanguages.contains(languageCode);
  }
}
