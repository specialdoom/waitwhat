import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:waitwhat/database/app_database.dart';
import 'package:waitwhat/services/ai_service.dart' show AiService, AiQuotaExceededException, QuotaStatus;

http.Response _groqResponse(Map<String, dynamic> payload, {int status = 200}) {
  final content = jsonEncode(payload);
  final body = jsonEncode({
    'choices': [
      {
        'message': {'content': content},
      },
    ],
  });
  return http.Response(body, status);
}

void main() {
  setUp(() => AiService.clearCache());

  group('AiService.suggestTodo', () {
    test('returns AiSuggestion when needsTodo is true', () async {
      final client = MockClient((_) async => _groqResponse({
            'needsTodo': true,
            'dueDate': '2026-05-01',
            'priority': 'high',
          }));

      final result = await AiService.suggestTodo(
        sender: 'John',
        body: 'Please buy milk tomorrow',
        apiKey: 'test_key',
        client: client,
      );

      expect(result, isNotNull);
      expect(result!.dueDate, DateTime(2026, 5, 1));
      expect(result.priority, Priority.high);
    });

    test('returns null when needsTodo is false', () async {
      final client = MockClient((_) async => _groqResponse({
            'needsTodo': false,
            'dueDate': null,
            'priority': null,
          }));

      final result = await AiService.suggestTodo(
        sender: 'John',
        body: 'Hey how are you?',
        apiKey: 'test_key',
        client: client,
      );

      expect(result, isNull);
    });

    test('throws AiQuotaExceededException on 429', () async {
      final client = MockClient((_) async => http.Response('', 429));

      await expectLater(
        AiService.suggestTodo(
          sender: 'John',
          body: 'call me',
          apiKey: 'test_key',
          client: client,
        ),
        throwsA(isA<AiQuotaExceededException>()),
      );
    });

    test('returns null on non-200 non-429 response', () async {
      final client = MockClient((_) async => http.Response('error', 500));

      final result = await AiService.suggestTodo(
        sender: 'John',
        body: 'call me',
        apiKey: 'test_key',
        client: client,
      );

      expect(result, isNull);
    });

    test('handles null dueDate', () async {
      final client = MockClient((_) async => _groqResponse({
            'needsTodo': true,
            'dueDate': null,
            'priority': 'medium',
          }));

      final result = await AiService.suggestTodo(
        sender: 'Jane',
        body: 'Call me',
        apiKey: 'test_key',
        client: client,
      );

      expect(result!.dueDate, isNull);
      expect(result.priority, Priority.medium);
    });

    test('handles "null" string for dueDate', () async {
      final client = MockClient((_) async => _groqResponse({
            'needsTodo': true,
            'dueDate': 'null',
            'priority': 'low',
          }));

      final result = await AiService.suggestTodo(
        sender: 'Bob',
        body: 'ping',
        apiKey: 'test_key',
        client: client,
      );

      expect(result!.dueDate, isNull);
    });

    test('maps all priority strings correctly', () async {
      final cases = [
        ('low', Priority.low),
        ('medium', Priority.medium),
        ('high', Priority.high),
        ('unknown', Priority.medium),
      ];

      for (final (priorityStr, expected) in cases) {
        final client = MockClient((_) async => _groqResponse({
              'needsTodo': true,
              'dueDate': null,
              'priority': priorityStr,
            }));

        final result = await AiService.suggestTodo(
          sender: 'X',
          body: 'test_$priorityStr',
          apiKey: 'key',
          client: client,
        );
        expect(result!.priority, expected, reason: 'priority "$priorityStr"');
      }
    });
  });

  group('AiService.checkQuota', () {
    test('returns ok on 200', () async {
      final client = MockClient((_) async => http.Response('{}', 200));
      expect(
        await AiService.checkQuota(apiKey: 'key', client: client),
        QuotaStatus.ok,
      );
    });

    test('returns exhausted on 429', () async {
      final client = MockClient((_) async => http.Response('', 429));
      expect(
        await AiService.checkQuota(apiKey: 'key', client: client),
        QuotaStatus.exhausted,
      );
    });

    test('returns error on non-200 non-429', () async {
      final client = MockClient((_) async => http.Response('', 401));
      expect(
        await AiService.checkQuota(apiKey: 'key', client: client),
        QuotaStatus.error,
      );
    });

    test('returns error on network exception', () async {
      final client = MockClient((_) async => throw Exception('network error'));
      expect(
        await AiService.checkQuota(apiKey: 'key', client: client),
        QuotaStatus.error,
      );
    });
  });
}
