import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import '../database/app_database.dart';
import 'database_service.dart';

class WidgetService {
  static const _androidName = 'TodoWidgetProvider';

  static Future<void> update() async {
    try {
      final todos = await DatabaseService.instance.getPendingTodos();
      final sorted = _sorted(todos);
      final data = sorted.take(5).map((t) => {
            'title': t.title,
            'priority': t.priority.name,
            'due': t.dueDate != null ? _formatDate(t.dueDate!) : '',
          }).toList();

      await HomeWidget.saveWidgetData<String>('widget_todos', jsonEncode(data));
      await HomeWidget.updateWidget(androidName: _androidName);
    } catch (_) {}
  }

  static List<Todo> _sorted(List<Todo> todos) {
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

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff =
        DateTime(date.year, date.month, date.day).difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 0) return 'Overdue';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
