import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'providers/language_provider.dart';
import 'providers/currency_provider.dart';
import 'providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: '******',
    anonKey: '******',
  );

  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => CurrencyProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return MaterialApp(
            title: 'Home Management',
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: themeProvider.themeData.copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                themeProvider.isDarkMode
                    ? ThemeData.dark().textTheme
                    : ThemeData.light().textTheme,
              ).apply(
                bodyColor: themeProvider.primaryTextColor,
                displayColor: themeProvider.primaryTextColor,
              ),
            ),
            home: showOnboarding
                ? const OnboardingScreen()
                : StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasData) {
                        return DashboardScreen();
                      }
                      return const LoginScreen();
                    },
                  ),
          );
        },
      ),
    );
  }
}
