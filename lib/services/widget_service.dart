import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import '../utils/date_formatter.dart';
import '../utils/todo_sorter.dart';
import 'database_service.dart';

class WidgetService {
  static const _androidName = 'TodoWidgetProvider';

  static Future<void> update() async {
    try {
      final todos = await DatabaseService.instance.getPendingTodos();
      final sorted = TodoSorter.byPriorityThenDueDate(todos);
      final data = sorted.take(5).map((t) => {
            'title': t.title,
            'priority': t.priority.name,
            'due': t.dueDate != null ? DateFormatter.dueDateWidget(t.dueDate!) : '',
          }).toList();

      await HomeWidget.saveWidgetData<String>('widget_todos', jsonEncode(data));
      await HomeWidget.updateWidget(androidName: _androidName);
    } catch (_) {}
  }

}
