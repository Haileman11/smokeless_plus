import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/services/motivational_quotes_service.dart';
import 'package:smokeless_plus/services/notification_sevice.dart';
import 'package:smokeless_plus/services/subscription_service.dart';
import 'package:smokeless_plus/services/theme_service.dart';

import '../core/app_export.dart';
import '../services/language_service.dart';
import '../widgets/custom_error_widget.dart';
import './presentation/user_profile/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AdMob
  MobileAds.instance.initialize();
  
  // Add permission check
  if (Platform.isIOS) {
    final granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    print("iOS notification permissions granted: $granted");
  } else {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
    print("Android notification permission status: ${await Permission.notification.status}");
  }
  
  await initNotifications();
    
  
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

   final SharedPreferences prefs = await SharedPreferences.getInstance();

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  await DynamicLocalization().load(prefs.getString('selected_language') ?? 'en');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  final subscriptionProvider = SubscriptionProvider();
  await subscriptionProvider.initialize();

  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
        ChangeNotifierProvider.value(value: subscriptionProvider),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, _) {
        
        return FutureBuilder(
          future: DynamicLocalization().load(languageProvider.locale.languageCode),
          builder: (context, asyncSnapshot) {
            final isLoading = asyncSnapshot.connectionState != ConnectionState.done;
            if (isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return MaterialApp(
              title: 'quitsmoking_tracker',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              locale: languageProvider.locale,
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
              key: ValueKey(languageProvider.locale.languageCode),
              // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(1.0),
                  ),
                  child:  Sizer(builder: (context, orientation, screenType)=> child!),
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
                        onLanguageChanged: languageProvider.setLanguage,
                      ),
                      settings: settings,
                    );
                  default:
                    return null;
                }
              },
            );
          }
        );
      }
    );
  }
}
