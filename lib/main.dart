import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';
import 'package:mindful_journal/features/journal/presentation/journal_screen.dart';
import 'package:mindful_journal/features/mood/presentation/mood_screen.dart';
import 'package:mindful_journal/features/habits/presentation/habits_screen.dart';
import 'package:mindful_journal/features/insights/presentation/insights_screen.dart';
import 'package:mindful_journal/features/settings/presentation/settings_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful Journal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
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

  final List<Widget> _screens = [
    const JournalScreen(),
    const MoodScreen(),
    const HabitsScreen(),
    const InsightsScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Journal',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.mood),
      label: 'Mood',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.check_circle),
      label: 'Habits',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.insights),
      label: 'Insights',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: _navItems,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}