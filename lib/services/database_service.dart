import 'package:drift/drift.dart';
import '../database/app_database.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance!;

  final AppDatabase _db;

  DatabaseService._(this._db);

  static void initialize() {
    if (_instance != null) return;
    _instance = DatabaseService._(AppDatabase());
  }

  // ── Messages ──────────────────────────────────────────────────────────────

  Future<int> saveMessage({
    required String sender,
    required String body,
    required DateTime timestamp,
  }) =>
      _db.into(_db.whatsAppMessages).insert(
            WhatsAppMessagesCompanion.insert(
              sender: sender,
              body: body,
              timestamp: timestamp,
            ),
          );

  Future<List<WhatsAppMessage>> getAllMessages() =>
      (_db.select(_db.whatsAppMessages)
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .get();

  Future<WhatsAppMessage?> getMessageById(int id) =>
      (_db.select(_db.whatsAppMessages)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> markMessageConverted(int id) =>
      (_db.update(_db.whatsAppMessages)..where((t) => t.id.equals(id))).write(
        const WhatsAppMessagesCompanion(isConvertedToTodo: Value(true)),
      );

  Future<void> deleteMessage(int id) =>
      (_db.delete(_db.whatsAppMessages)..where((t) => t.id.equals(id))).go();

  Stream<List<WhatsAppMessage>> watchMessages() =>
      (_db.select(_db.whatsAppMessages)
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .watch();

  // ── Todos ─────────────────────────────────────────────────────────────────

  Future<int> saveTodo({
    required String title,
    String? notes,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    int? sourceMessageId,
  }) =>
      _db.into(_db.todos).insert(
            TodosCompanion.insert(
              title: title,
              notes: Value(notes),
              dueDate: Value(dueDate),
              priority: priority,
              sourceMessageId: Value(sourceMessageId),
              createdAt: DateTime.now(),
            ),
          );

  Future<void> updateTodo(int id, TodosCompanion data) =>
      (_db.update(_db.todos)..where((t) => t.id.equals(id))).write(data);

  Future<List<Todo>> getAllTodos() =>
      (_db.select(_db.todos)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Todo>> getPendingTodos() =>
      (_db.select(_db.todos)
            ..where((t) => t.isCompleted.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
          .get();

  Future<void> toggleTodoCompleted(int id) async {
    final todo = await (_db.select(_db.todos)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (todo == null) return;
    await (_db.update(_db.todos)..where((t) => t.id.equals(id)))
        .write(TodosCompanion(isCompleted: Value(!todo.isCompleted)));
  }

  Future<void> deleteTodo(int id) =>
      (_db.delete(_db.todos)..where((t) => t.id.equals(id))).go();

  Stream<List<Todo>> watchTodos() =>
      (_db.select(_db.todos)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  // ── Filtered Senders ──────────────────────────────────────────────────────

  Future<void> addSender(String name) => _db
      .into(_db.filteredSenders)
      .insertOnConflictUpdate(FilteredSendersCompanion.insert(name: name));

  Future<void> removeSender(int id) =>
      (_db.delete(_db.filteredSenders)..where((t) => t.id.equals(id))).go();

  Future<List<FilteredSender>> getAllSenders() =>
      _db.select(_db.filteredSenders).get();

  Stream<List<FilteredSender>> watchSenders() =>
      _db.select(_db.filteredSenders).watch();

  Future<List<String>> getDistinctMessageSenders() async {
    final rows = await (_db.selectOnly(_db.whatsAppMessages)
          ..addColumns([_db.whatsAppMessages.sender])
          ..groupBy([_db.whatsAppMessages.sender]))
        .get();
    return rows
        .map((r) => r.read(_db.whatsAppMessages.sender)!)
        .toList();
  }

  // ── Seen Senders ──────────────────────────────────────────────────────────

  Future<void> saveSeenSender(String name) => _db
      .into(_db.seenSenders)
      .insertOnConflictUpdate(SeenSendersCompanion.insert(name: name));

  Future<List<String>> getSeenSenderNames() async {
    final rows = await _db.select(_db.seenSenders).get();
    return rows.map((r) => r.name).toList();
  }
}