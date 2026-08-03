import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';
import 'package:mindful_journal/core/providers/providers.dart';
import 'package:mindful_journal/services/database_service.dart';
import 'package:mindful_journal/services/auth_service.dart';
import 'package:mindful_journal/features/auth/presentation/login_screen.dart';
import 'package:mindful_journal/features/journal/presentation/journal_screen.dart';
import 'package:mindful_journal/features/mood/presentation/mood_screen.dart';
import 'package:mindful_journal/features/habits/presentation/habits_screen.dart';
import 'package:mindful_journal/features/insights/presentation/insights_screen.dart';
import 'package:mindful_journal/features/settings/presentation/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Initialize local database first (fast, offline)
  await DatabaseService().init();
  
  // Launch app immediately — heavy init runs in background
  runApp(const ProviderScope(child: MyApp()));
  
  // Background initialization (non-blocking)
  // Firebase
  Firebase.initializeApp().then((_) {
    print('Firebase initialized');
    // Cloud sync after Firebase ready
    DatabaseService().syncFromCloud().catchError((e) => print('Cloud sync skipped: $e'));
  }).catchError((e) {
    print('Firebase init skipped (offline/no config): $e');
  });
  
  // AdMob — never block startup, add timeout
  MobileAds.instance.initialize().then((_) {
    print('AdMob initialized');
  }).timeout(const Duration(seconds: 5), onTimeout: () {
    print('AdMob init timeout — will retry later');
  }).catchError((e) {
    print('AdMob init skipped: $e');
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Mindful Journal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        loading: () => const HomeScreen(), // Show app immediately (offline-first)
        error: (_, __) => const HomeScreen(),
        data: (user) {
          if (user != null) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    JournalScreen(),
    MoodScreen(),
    HabitsScreen(),
    InsightsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
