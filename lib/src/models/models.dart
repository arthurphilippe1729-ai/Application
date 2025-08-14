dart
class TodoItem {
  final String id;
  final String title;
  final bool done;
  final DateTime? due; // optional

  const TodoItem({required this.id, required this.title, this.done = false, this.due});

  TodoItem copyWith({String? id, String? title, bool? done, DateTime? due}) =>
      TodoItem(id: id ?? this.id, title: title ?? this.title, done: done ?? this.done, due: due ?? this.due);

  factory TodoItem.fromJson(Map<String, dynamic> j) => TodoItem(
        id: j['id'],
        title: j['title'],
        done: j['done'] ?? false,
        due: j['due'] != null ? DateTime.parse(j['due']) : null,
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'done': done,
        'due': due?.toIso8601String(),
      };
}

class EventItem {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;

  const EventItem({required this.id, required this.title, required this.start, required this.end});

  EventItem copyWith({String? id, String? title, DateTime? start, DateTime? end}) => EventItem(
        id: id ?? this.id,
        title: title ?? this.title,
        start: start ?? this.start,
        end: end ?? this.end,
      );

  factory EventItem.fromJson(Map<String, dynamic> j) => EventItem(
        id: j['id'],
        title: j['title'],
        start: DateTime.parse(j['start']),
        end: DateTime.parse(j['end']),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      };
}