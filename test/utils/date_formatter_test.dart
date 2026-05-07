import 'package:flutter_test/flutter_test.dart';
import 'package:waitwhat/utils/date_formatter.dart';

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  group('DateFormatter.dueDate', () {
    test('returns Today for today', () {
      expect(DateFormatter.dueDate(today), 'Today');
    });

    test('returns Tomorrow for tomorrow', () {
      expect(DateFormatter.dueDate(today.add(const Duration(days: 1))), 'Tomorrow');
    });

    test('returns Yesterday for yesterday', () {
      expect(DateFormatter.dueDate(today.subtract(const Duration(days: 1))), 'Yesterday');
    });

    test('returns Month Day for other dates', () {
      final date = today.add(const Duration(days: 10));
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      expect(DateFormatter.dueDate(date), '${months[date.month - 1]} ${date.day}');
    });

    test('returns correct month abbreviation for each month', () {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      for (var i = 0; i < 12; i++) {
        final date = DateTime(2025, i + 1, 10);
        expect(DateFormatter.dueDate(date), contains(months[i]));
      }
    });
  });

  group('DateFormatter.dueDateWidget', () {
    test('returns Today for today', () {
      expect(DateFormatter.dueDateWidget(today), 'Today');
    });

    test('returns Tomorrow for tomorrow', () {
      expect(DateFormatter.dueDateWidget(today.add(const Duration(days: 1))), 'Tomorrow');
    });

    test('returns Overdue for past dates', () {
      expect(DateFormatter.dueDateWidget(today.subtract(const Duration(days: 1))), 'Overdue');
      expect(DateFormatter.dueDateWidget(today.subtract(const Duration(days: 30))), 'Overdue');
    });

    test('returns Month Day for future dates beyond tomorrow', () {
      final date = today.add(const Duration(days: 10));
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      expect(DateFormatter.dueDateWidget(date), '${months[date.month - 1]} ${date.day}');
    });
  });

  group('DateFormatter.messageTime', () {
    test('returns HH:MM AM/PM for messages today', () {
      final morning = DateTime(today.year, today.month, today.day, 9, 5);
      expect(DateFormatter.messageTime(morning), '9:05 AM');

      final afternoon = DateTime(today.year, today.month, today.day, 14, 30);
      expect(DateFormatter.messageTime(afternoon), '2:30 PM');
    });

    test('returns 12:xx for noon and midnight', () {
      final noon = DateTime(today.year, today.month, today.day, 12, 0);
      expect(DateFormatter.messageTime(noon), '12:00 PM');

      final midnight = DateTime(today.year, today.month, today.day, 0, 0);
      expect(DateFormatter.messageTime(midnight), '12:00 AM');
    });

    test('returns day abbreviation for messages within the last week', () {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final threeDaysAgo = today.subtract(const Duration(days: 3));
      expect(DateFormatter.messageTime(threeDaysAgo), days[threeDaysAgo.weekday - 1]);
    });

    test('returns Month Day for messages older than a week', () {
      final old = DateTime(2024, 3, 5, 10, 0);
      expect(DateFormatter.messageTime(old), 'Mar 5');
    });
  });
}
