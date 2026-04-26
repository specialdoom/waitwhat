import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:path_provider/path_provider.dart';
import '../models/whatsapp_message.dart';
import '../models/todo.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance!;

  late Isar _isar;

  DatabaseService._();

  static Future<void> initialize() async {
    if (_instance != null) return;
    _instance = DatabaseService._();
    await _instance!._open();
  }

  Future<void> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [WhatsAppMessageSchema, TodoSchema],
      directory: dir.path,
    );
  }

  // ── Messages ──────────────────────────────────────────────────────────────

  Future<int> saveMessage(WhatsAppMessage message) =>
      _isar.writeTxn(() => _isar.whatsAppMessages.put(message));

  Future<List<WhatsAppMessage>> getAllMessages() =>
      _isar.whatsAppMessages.where().sortByTimestampDesc().findAll();

  Future<WhatsAppMessage?> getMessageById(int id) =>
      _isar.whatsAppMessages.get(id);

  Future<void> markMessageConverted(int id) => _isar.writeTxn(() async {
        final msg = await _isar.whatsAppMessages.get(id);
        if (msg == null) return;
        msg.isConvertedToTodo = true;
        await _isar.whatsAppMessages.put(msg);
      });

  Stream<List<WhatsAppMessage>> watchMessages() =>
      _isar.whatsAppMessages.where().watch(fireImmediately: true);

  // ── Todos ─────────────────────────────────────────────────────────────────

  Future<int> saveTodo(Todo todo) =>
      _isar.writeTxn(() => _isar.todos.put(todo));

  Future<List<Todo>> getAllTodos() =>
      _isar.todos.where().sortByCreatedAtDesc().findAll();

  Future<List<Todo>> getPendingTodos() => _isar.todos
      .filter()
      .isCompletedEqualTo(false)
      .sortByDueDate()
      .findAll();

  Future<void> toggleTodoCompleted(int id) => _isar.writeTxn(() async {
        final todo = await _isar.todos.get(id);
        if (todo == null) return;
        todo.isCompleted = !todo.isCompleted;
        await _isar.todos.put(todo);
      });

  Future<void> deleteTodo(int id) =>
      _isar.writeTxn(() => _isar.todos.delete(id));

  Stream<List<Todo>> watchTodos() =>
      _isar.todos.where().watch(fireImmediately: true);
}