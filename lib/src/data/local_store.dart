dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class LocalStore {
  static const _kTodos = 'todos';
  static const _kEvents = 'events';

  Future<List<TodoItem>> loadTodos() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kTodos);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(TodoItem.fromJson).toList();
  }

  Future<void> saveTodos(List<TodoItem> items) async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await sp.setString(_kTodos, raw);
  }

  Future<List<EventItem>> loadEvents() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kEvents);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(EventItem.fromJson).toList();
  }

  Future<void> saveEvents(List<EventItem> items) async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await sp.setString(_kEvents, raw);
  }
}