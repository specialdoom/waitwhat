import '../database/app_database.dart';

class TodoSorter {
  static List<Todo> byDueDate(List<Todo> todos) {
    final pending = todos.where((t) => !t.isCompleted).toList();
    final done = todos.where((t) => t.isCompleted).toList();
    pending.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return [...pending, ...done];
  }

  static List<Todo> byPriorityThenDueDate(List<Todo> todos) {
    final pending = todos.where((t) => !t.isCompleted).toList();
    const order = {Priority.high: 0, Priority.medium: 1, Priority.low: 2};
    pending.sort((a, b) {
      final p = order[a.priority]!.compareTo(order[b.priority]!);
      if (p != 0) return p;
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return pending;
  }
}
