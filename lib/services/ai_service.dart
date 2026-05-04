import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/app_database.dart';

class AiQuotaExceededException implements Exception {}

enum QuotaStatus { ok, exhausted, error }

class AiSuggestion {
  final DateTime? dueDate;
  final Priority priority;

  AiSuggestion({this.dueDate, required this.priority});
}

class AiService {
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';
  static const _model = 'llama-3.1-8b-instant';

  static String _prompt(String sender, String body) {
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return '''
Today's date is $today.
Decide if the following WhatsApp message from "$sender" requires any action.
Greetings, acknowledgements, casual chat, and messages with no actionable request do NOT need a todo.
Use today's date as reference when interpreting relative dates like "mâine", "săptămâna viitoare", "tomorrow", or "next week".
Respond with ONLY a valid JSON object:
{
  "needsTodo": true or false,
  "dueDate": "YYYY-MM-DD if a specific date is mentioned, otherwise null",
  "priority": "low, medium, or high based on urgency, or null if needsTodo is false"
}

Message from $sender:
$body
''';
  }

  static Future<QuotaStatus> checkQuota({
    required String apiKey,
    http.Client? client,
  }) async {
    final c = client ?? http.Client();
    try {
      final response = await c.post(
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
      if (response.statusCode == 200) return QuotaStatus.ok;
      if (response.statusCode == 429) return QuotaStatus.exhausted;
      return QuotaStatus.error;
    } catch (_) {
      return QuotaStatus.error;
    }
  }

  static Future<AiSuggestion?> suggestTodo({
    required String sender,
    required String body,
    required String apiKey,
    http.Client? client,
  }) async {
    final c = client ?? http.Client();
    try {
      final response = await c.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': _prompt(sender, body)},
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

      return AiSuggestion(dueDate: dueDate, priority: priority);
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