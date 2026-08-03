import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:mindful_journal/core/theme/app_theme.dart';
import 'package:mindful_journal/core/providers/providers.dart';
import 'package:mindful_journal/data/models/journal_entry.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entries) {
          entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.book_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No journal entries yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  Text('Tap + to write your first entry', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) => _buildEntryCard(context, entries[index], ref),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryDialog(context, ref),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEntryCard(BuildContext context, JournalEntry entry, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showEntryDialog(context, ref, entry: entry),
        onLongPress: () => _confirmDelete(context, ref, entry),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text(entry.mood, style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(entry.content, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(DateFormat('MMM d, h:mm a').format(entry.createdAt), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                        if (entry.tags.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text(entry.tags.first, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.primaryColor)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showEntryDialog(BuildContext context, WidgetRef ref, {JournalEntry? entry}) {
    final titleCtrl = TextEditingController(text: entry?.title ?? '');
    final contentCtrl = TextEditingController(text: entry?.content ?? '');
    String mood = entry?.mood ?? '🙂';
    String tag = entry?.tags.isNotEmpty == true ? entry!.tags.first : 'personal';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(entry == null ? 'New Entry' : 'Edit Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 12),
                TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: "What's on your mind?"), maxLines: 5),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: mood,
                  decoration: const InputDecoration(labelText: 'Mood'),
                  items: ['😢', '😐', '🙂', '😊', '🥰'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) => setModalState(() => mood = v!),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: tag,
                  decoration: const InputDecoration(labelText: 'Tag'),
                  items: ['personal', 'work', 'health', 'mindfulness', 'family'].map((t) => DropdownMenuItem(value: t, child: Text(t[0].toUpperCase() + t.substring(1)))).toList(),
                  onChanged: (v) => setModalState(() => tag = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                final db = ref.read(databaseServiceProvider);
                if (entry == null) {
                  await db.addJournalEntry(JournalEntry(
                    id: const Uuid().v4(),
                    title: titleCtrl.text.trim(),
                    content: contentCtrl.text.trim(),
                    mood: mood,
                    tags: [tag],
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ));
                } else {
                  entry.title = titleCtrl.text.trim();
                  entry.content = contentCtrl.text.trim();
                  entry.mood = mood;
                  entry.tags = [tag];
                  entry.updatedAt = DateTime.now();
                  await db.updateJournalEntry(entry);
                }
                ref.invalidate(journalEntriesProvider);
                ref.invalidate(statisticsProvider);
                Navigator.pop(ctx);
              },
              child: Text(entry == null ? 'Save' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Delete this entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(databaseServiceProvider).deleteJournalEntry(entry.id);
              ref.invalidate(journalEntriesProvider);
              ref.invalidate(statisticsProvider);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
