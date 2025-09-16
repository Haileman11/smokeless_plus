import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/app_state.dart';
import 'screens/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';
import 'constants/colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: SmokeLessApp(),
    ),
  );
}

class SmokeLessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'SmokeLess+',
          theme: ThemeData(
            primarySwatch: MaterialColor(
              AppColors.primary.value,
              <int, Color>{
                50: AppColors.primary.withOpacity(0.1),
                100: AppColors.primary.withOpacity(0.2),
                200: AppColors.primary.withOpacity(0.3),
                300: AppColors.primary.withOpacity(0.4),
                400: AppColors.primary.withOpacity(0.5),
                500: AppColors.primary,
                600: AppColors.primary.withOpacity(0.7),
                700: AppColors.primary.withOpacity(0.8),
                800: AppColors.primary.withOpacity(0.9),
                900: AppColors.primary.withOpacity(1.0),
              },
            ),
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: 'System',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
            ),
          ),
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