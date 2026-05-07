import 'package:flutter_test/flutter_test.dart';
import 'package:waitwhat/database/app_database.dart';
import 'package:waitwhat/utils/todo_sorter.dart';

Todo _todo({
  required int id,
  required String title,
  Priority priority = Priority.medium,
  DateTime? dueDate,
  bool isCompleted = false,
}) =>
    Todo(
      id: id,
      title: title,
      notes: null,
      dueDate: dueDate,
      priority: priority,
      isCompleted: isCompleted,
      sourceMessageId: null,
      createdAt: DateTime(2025, 1, 1),
    );

void main() {
  group('TodoSorter.byDueDate', () {
    test('pending todos come before completed todos', () {
      final todos = [
        _todo(id: 1, title: 'Done', isCompleted: true),
        _todo(id: 2, title: 'Pending'),
      ];
      final sorted = TodoSorter.byDueDate(todos);
      expect(sorted[0].title, 'Pending');
      expect(sorted[1].title, 'Done');
    });

    test('sorts pending todos by due date ascending', () {
      final todos = [
        _todo(id: 1, title: 'Later', dueDate: DateTime(2025, 6, 10)),
        _todo(id: 2, title: 'Sooner', dueDate: DateTime(2025, 6, 1)),
      ];
      final sorted = TodoSorter.byDueDate(todos);
      expect(sorted[0].title, 'Sooner');
      expect(sorted[1].title, 'Later');
    });

    test('todos without due date go after those with one', () {
      final todos = [
        _todo(id: 1, title: 'No date'),
        _todo(id: 2, title: 'Has date', dueDate: DateTime(2025, 6, 1)),
      ];
      final sorted = TodoSorter.byDueDate(todos);
      expect(sorted[0].title, 'Has date');
      expect(sorted[1].title, 'No date');
    });

    test('returns empty list for empty input', () {
      expect(TodoSorter.byDueDate([]), isEmpty);
    });
  });

  group('TodoSorter.byPriorityThenDueDate', () {
    test('sorts by priority high → medium → low', () {
      final todos = [
        _todo(id: 1, title: 'Low', priority: Priority.low),
        _todo(id: 2, title: 'High', priority: Priority.high),
        _todo(id: 3, title: 'Medium', priority: Priority.medium),
      ];
      final sorted = TodoSorter.byPriorityThenDueDate(todos);
      expect(sorted[0].title, 'High');
      expect(sorted[1].title, 'Medium');
      expect(sorted[2].title, 'Low');
    });

    test('within same priority sorts by due date ascending', () {
      final todos = [
        _todo(id: 1, title: 'Later', priority: Priority.high, dueDate: DateTime(2025, 6, 10)),
        _todo(id: 2, title: 'Sooner', priority: Priority.high, dueDate: DateTime(2025, 6, 1)),
      ];
      final sorted = TodoSorter.byPriorityThenDueDate(todos);
      expect(sorted[0].title, 'Sooner');
      expect(sorted[1].title, 'Later');
    });

    test('excludes completed todos', () {
      final todos = [
        _todo(id: 1, title: 'Done', isCompleted: true),
        _todo(id: 2, title: 'Pending'),
      ];
      final sorted = TodoSorter.byPriorityThenDueDate(todos);
      expect(sorted.length, 1);
      expect(sorted[0].title, 'Pending');
    });

    test('returns empty list for empty input', () {
      expect(TodoSorter.byPriorityThenDueDate([]), isEmpty);
    });
  });
}
