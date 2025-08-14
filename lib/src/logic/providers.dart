dart
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local_store.dart';
import '../models/models.dart';

final storeProvider = Provider((_) => LocalStore());

final todosProvider = NotifierProvider<TodosNotifier, List<TodoItem>>(TodosNotifier.new);
final eventsProvider = NotifierProvider<EventsNotifier, List<EventItem>>(EventsNotifier.new);

class TodosNotifier extends Notifier<List<TodoItem>> {
  @override
  List<TodoItem> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    final items = await ref.read(storeProvider).loadTodos();
    state = items;
  }

  Future<void> add(String title, {DateTime? due}) async {
    final id = '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1 << 32)}';
    state = [...state, TodoItem(id: id, title: title, due: due)];
    await ref.read(storeProvider).saveTodos(state);
  }

  Future<void> toggle(String id) async {
    state = [for (final t in state) if (t.id == id) t.copyWith(done: !t.done) else t];
    await ref.read(storeProvider).saveTodos(state);
  }

  Future<void> remove(String id) async {
    state = state.where((t) => t.id != id).toList();
    await ref.read(storeProvider).saveTodos(state);
  }
}

class EventsNotifier extends Notifier<List<EventItem>> {
  @override
  List<EventItem> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    final items = await ref.read(storeProvider).loadEvents();
    state = items;
  }

  Future<void> add(String title, DateTime start, DateTime end) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    state = [...state, EventItem(id: id, title: title, start: start, end: end)]..sort((a,b)=>a.start.compareTo(b.start));
    await ref.read(storeProvider).saveEvents(state);
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await ref.read(storeProvider).saveEvents(state);
  }
}