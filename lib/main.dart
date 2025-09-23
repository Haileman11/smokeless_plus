import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../services/language_service.dart';
import '../widgets/custom_error_widget.dart';
import './presentation/user_profile/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!_hasShownError) {
      _hasShownError = true;

      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        _hasShownError = false;
      });

      return CustomErrorWidget(
        errorDetails: details,
      );
    }
    return SizedBox.shrink();
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final languageCode = await LanguageService.loadLanguage();
    setState(() {
      _locale = LanguageService.getLocale(languageCode);
    });
  }

  void _changeLanguage(String languageCode) async {
    // Save the language preference first
    await LanguageService.saveLanguage(languageCode);

    setState(() {
      _locale = LanguageService.getLocale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'quitsmoking_tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'), // Spanish
          Locale('fr'), // French
          Locale('de'), // German
          Locale('it'), // Italian
          Locale('pt'), // Portuguese
          Locale('ar'), // Arabic
          Locale('zh'), // Chinese
          Locale('ja'), // Japanese
          Locale('ru'), // Russian
          Locale('hi'), // Hindi
        ],
        // Force locale rebuild when changed
        key: ValueKey(_locale?.languageCode ?? 'en'),
        // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        // 🚨 END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
        onGenerateRoute: (settings) {
          // Pass language change callback to all screens that need it
          switch (settings.name) {
            case '/user-profile':
              return MaterialPageRoute(
                builder: (context) => UserProfile(
                  onLanguageChanged: _changeLanguage,
                ),
                settings: settings,
              );
            default:
              return null;
          }
        },
      );
    });
  }
}
