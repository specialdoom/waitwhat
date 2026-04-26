import 'package:isar/isar.dart';

part 'whatsapp_message.g.dart';

@collection
class WhatsAppMessage {
  Id id = Isar.autoIncrement;

  late String sender;
  late String body;
  late DateTime timestamp;
  bool isConvertedToTodo = false;
}