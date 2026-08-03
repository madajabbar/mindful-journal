import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';
import 'package:mindful_journal/core/providers/providers.dart';
import 'package:mindful_journal/data/models/mood_entry.dart';

class MoodScreen extends ConsumerStatefulWidget {
  const MoodScreen({super.key});

  @override
  ConsumerState<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends ConsumerState<MoodScreen> {
  int _selectedIndex = 2; // default 🙂
  final _noteCtrl = TextEditingController();

  final _moods = ['😢', '😐', '🙂', '😊', '🥰'];
  final _labels = ['Sad', 'Neutral', 'Happy', 'Very Happy', 'Excellent'];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(moodEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text("How are you feeling today?", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(5, (i) => _moodBtn(i))),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(
                      hintText: 'Add a note...',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Save Today's Mood"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Recent Moods', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (entries) {
                entries.sort((a, b) => b.date.compareTo(a.date));
                if (entries.isEmpty) return Text('No mood entries yet', style: Theme.of(context).textTheme.bodySmall);
                return Column(children: entries.take(15).map((e) => _entryCard(e)).toList());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodBtn(int i) {
    final selected = _selectedIndex == i;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = i),
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: selected ? _color(i).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: _color(i), width: selected ? 3 : 1),
            ),
            child: Center(child: Text(_moods[i], style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 4),
          Text(_labels[i], style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _entryCard(MoodEntry e) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: _color(e.moodValue - 1).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(e.mood, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('MMM d, yyyy').format(e.date), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                  if (e.note.isNotEmpty) Text(e.note, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _color(int i) {
    switch (i) {
      case 0: return AppTheme.moodSad;
      case 1: return AppTheme.moodNeutral;
      case 2: return AppTheme.moodHappy;
      case 3: return AppTheme.moodVeryHappy;
      case 4: return AppTheme.moodExcellent;
      default: return AppTheme.moodNeutral;
    }
  }

  Future<void> _save() async {
    final db = ref.read(databaseServiceProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final existing = await db.getMoodEntryByDate(today);
    if (existing != null && existing.id.startsWith('mood_')) {
      existing.mood = _moods[_selectedIndex];
      existing.intensity = _selectedIndex + 1;
      existing.note = _noteCtrl.text.trim();
      await db.updateMoodEntry(existing);
    } else {
      await db.addMoodEntry(MoodEntry(
        id: 'mood_${today.millisecondsSinceEpoch}',
        mood: _moods[_selectedIndex],
        date: today,
        note: _noteCtrl.text.trim(),
        factors: [],
        intensity: _selectedIndex + 1,
      ));
    }

    _noteCtrl.clear();
    ref.invalidate(moodEntriesProvider);
    ref.invalidate(todayMoodProvider);
    ref.invalidate(statisticsProvider);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mood saved!'), duration: Duration(seconds: 1)));
  }
}
