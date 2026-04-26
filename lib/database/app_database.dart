import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

enum Priority { low, medium, high }

class WhatsAppMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sender => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isConvertedToTodo =>
      boolean().withDefault(const Constant(false))();
}

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get priority => intEnum<Priority>()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get sourceMessageId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [WhatsAppMessages, Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'waitwhat'));

  @override
  int get schemaVersion => 1;
}