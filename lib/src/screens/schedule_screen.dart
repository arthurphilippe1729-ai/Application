`dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/providers.dart';
import '../models/models.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: events.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _EventCard(item: events[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  Future<void> _showAddEventDialog(BuildContext context, WidgetRef ref) async {
    final titleCtrl = TextEditingController();
    DateTime start = DateTime.now();
    DateTime end = start.add(const Duration(hours: 1));

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvel évènement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titre')),
            const SizedBox(height: 12),
            _TimeField(
              label: 'Début',
              value: start,
              onPick: (v) { start = v; (ctx as Element).markNeedsBuild(); },
            ),
            const SizedBox(height: 8),
            _TimeField(
              label: 'Fin',
              value: end,
              onPick: (v) { end = v; (ctx as Element).markNeedsBuild(); },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          FilledButton(onPressed: () async {
            if (titleCtrl.text.trim().isEmpty) return;
            if (!end.isAfter(start)) return; // simple guard
            await ref.read(eventsProvider.notifier).add(titleCtrl.text.trim(), start, end);
            if (ctx.mounted) Navigator.pop(ctx);
          }, child: const Text('Ajouter')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          const Text('Aucun évènement. Ajoutez votre première plage horaire !')
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventItem item;
  const _EventCard({required this.item});
  @override
  Widget build(BuildContext context) {
    final time = '${_fmt(item.start)} — ${_fmt(item.end)}';
    return Card(
      child: ListTile(
        title: Text(item.title),
        subtitle: Text(time),
        trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {
          final ref = ProviderScope.containerOf(context);
          ref.read(eventsProvider.notifier).remove(item.id);
        }),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')} ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
}

class _TimeField extends StatelessWidget {
  final String label; final DateTime value; final ValueChanged<DateTime> onPick;
  const _TimeField({required this.label, required this.value, required this.onPick});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: OutlinedButton.icon(
        icon: const Icon(Icons.schedule),
        label: Text('$label: ${_fmt(value)}'),
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365*5)),
            initialDate: value,
          );
          if (date == null) return;
          final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(value));
          if (time == null) return;
          final picked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          onPick(picked);
        },
      ))
    ]);
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')} ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
}