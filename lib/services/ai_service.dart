import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/app_database.dart';

class AiQuotaExceededException implements Exception {}

class AiSuggestion {
  final String title;
  final String? notes;
  final DateTime? dueDate;
  final Priority priority;

  AiSuggestion({
    required this.title,
    this.notes,
    this.dueDate,
    required this.priority,
  });
}

class AiService {
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';
  static const _model = 'llama-3.1-8b-instant';

  static String _prompt(String sender, String body, String? customInstructions) {
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return '''
Today's date is $today.
Analyze this WhatsApp message and extract a single actionable todo item.
Messages are most often written in Romanian — detect the language of the message and respond with the title and notes in that same language.
Always include the sender "$sender" in the title (e.g. "Sună-l pe $sender", "Răspunde-i lui $sender", or the English equivalent if the message is in English).
Use today's date as reference when interpreting relative dates like "mâine", "săptămâna viitoare", "tomorrow", or "next week".${_customInstructionsBlock(customInstructions)}
First decide if the message requires any action at all. Greetings, acknowledgements, casual chat, and messages with no actionable request do NOT need a todo.
Respond with ONLY a valid JSON object:
{
  "needsTodo": true or false,
  "title": "brief action title including the sender name, or null if needsTodo is false",
  "notes": "additional context or null",
  "dueDate": "YYYY-MM-DD if a date is mentioned, otherwise null",
  "priority": "low, medium, or high based on urgency, or null if needsTodo is false"
}

Message from $sender:
$body
''';
  }

  static String _customInstructionsBlock(String? instructions) =>
      instructions != null
          ? '\nAdditional rules to follow:\n$instructions\n'
          : '';

  static Future<bool> checkQuota({required String apiKey}) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': 'Hi'},
          ],
          'max_tokens': 1,
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<AiSuggestion?> suggestTodo({
    required String sender,
    required String body,
    required String apiKey,
    String? customInstructions,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': _prompt(sender, body, customInstructions)},
          ],
          'temperature': 0,
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode == 429) throw AiQuotaExceededException();
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final content =
          (json['choices'] as List).first['message']['content'] as String;
      final data = jsonDecode(content) as Map<String, dynamic>;

      if (data['needsTodo'] == false) return null;

      final dueDateStr = data['dueDate'];
      DateTime? dueDate;
      if (dueDateStr != null && dueDateStr != 'null') {
        dueDate = DateTime.tryParse(dueDateStr as String);
      }

      final priorityStr =
          ((data['priority'] as String?) ?? 'medium').toLowerCase();
      final priority = switch (priorityStr) {
        'low' => Priority.low,
        'high' => Priority.high,
        _ => Priority.medium,
      };

      final notes = data['notes'];
      return AiSuggestion(
        title: (data['title'] as String?) ?? body,
        notes: (notes == null || notes == 'null') ? null : notes as String,
        dueDate: dueDate,
        priority: priority,
      );
    } catch (e) {
      if (e is AiQuotaExceededException) rethrow;
      final msg = e.toString().toLowerCase();
      if (msg.contains('rate_limit') ||
          msg.contains('429') ||
          msg.contains('quota')) {
        throw AiQuotaExceededException();
      }
      return null;
    }
  }
}