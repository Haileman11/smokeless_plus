import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _keyLanguage = 'selected_language';

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

  String _languageCode = 'en';

  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);
  String get currentLanguage => _languageCode;

  LanguageProvider(this._prefs) {
    _loadLanguage();
  }

  void _loadLanguage()  {
    try {
      final savedLanguage = _prefs.getString(_keyLanguage);

      if (savedLanguage != null) {
        _languageCode = savedLanguage;
      } else {
        _languageCode = getDeviceLanguage();
      }

      notifyListeners();
    } catch (_) {
      _languageCode = 'en';
      notifyListeners();
    }
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    notifyListeners(); // 🔥 Trigger rebuilds
    await _prefs.setString(_keyLanguage, code);
  }

  static String getDeviceLanguage() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final code = locale.languageCode;

    final supportedCodes =
        supportedLanguages.map((lang) => lang['code']).toList();
    return supportedCodes.contains(code) ? code : 'en';
  }

  String getLanguageName(String code) {
    return supportedLanguages
            .firstWhere((lang) => lang['code'] == code,
                orElse: () => supportedLanguages.first)['name'] ??
        'English';
  }

  String getNativeLanguageName(String code) {
    return supportedLanguages
            .firstWhere((lang) => lang['code'] == code,
                orElse: () => supportedLanguages.first)['nativeName'] ??
        'English';
  }

  bool get isRTL {
    const rtlLanguages = ['ar', 'he', 'fa', 'ur'];
    return rtlLanguages.contains(_languageCode);
  }
}
