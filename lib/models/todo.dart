import 'package:isar/isar.dart';

part 'todo.g.dart';

enum Priority { low, medium, high }

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;
  String? notes;
  DateTime? dueDate;
  @enumerated
  Priority priority = Priority.medium;
  bool isCompleted = false;
  int? sourceMessageId;
  late DateTime createdAt;
}