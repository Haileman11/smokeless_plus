import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/app_state.dart';
import 'services/theme_service.dart';
import 'screens/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';
import 'constants/colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
      ],
      child: SmokeLessApp(),
    ),
  );
}

class SmokeLessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, ThemeService>(
      builder: (context, appState, themeService, child) {
        return MaterialApp(
          title: 'SmokeLess+',
          theme: themeService.lightTheme,
          darkTheme: themeService.darkTheme,
          themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(appState.currentLanguage),
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}