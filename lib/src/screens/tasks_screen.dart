dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/providers.dart';
import '../models/models.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: todos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final t = todos[i];
            return Card(
              child: ListTile(
                leading: Checkbox(value: t.done, onChanged: (_) => ref.read(todosProvider.notifier).toggle(t.id)),
                title: Text(t.title, style: TextStyle(decoration: t.done ? TextDecoration.lineThrough : null)),
                subtitle: t.due != null ? Text(_formatDate(t.due!)) : null,
                trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => ref.read(todosProvider.notifier).remove(t.id)),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final titleCtrl = TextEditingController();
    DateTime? due;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvelle tâche'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titre')), 
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                icon: const Icon(Icons.event_outlined),
                label: Text(due == null ? 'Échéance (optionnel)' : _formatDate(due!)),
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(context: ctx, firstDate: now.subtract(const Duration(days: 1)), lastDate: now.add(const Duration(days: 365*5)), initialDate: now);
                  if (picked != null) {
                    due = DateTime(picked.year, picked.month, picked.day);
                    (ctx as Element).markNeedsBuild();
                  }
                },
              ))
            ])
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          FilledButton(onPressed: () async {
            if (titleCtrl.text.trim().isEmpty) return;
            await ref.read(todosProvider.notifier).add(titleCtrl.text.trim(), due: due);
            if (ctx.mounted) Navigator.pop(ctx);
          }, child: const Text('Ajouter')),
        ],
      ),
    );
  }
}