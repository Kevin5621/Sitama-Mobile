// Notification Manager class to handle logbook notifications
import 'package:sitama/domain/entities/log_book_entity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager {
  static const String _keyPrefix = 'logbook_last_read';
  String _getKey(int studentId) => '${_keyPrefix}_$studentId';

  // Method to check if there are any unread logbooks for a student
  Future<bool> hasUnreadLogBooks({
    required int studentId,
    required List<LogBookEntity> logBooks,
  }) async {
    if (logBooks.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(studentId);
    final lastReadTime = prefs.getString(key);

    if (lastReadTime == null) return true;

    final lastRead = DateTime.parse(lastReadTime);
    return logBooks.any((logBook) => logBook.date.isAfter(lastRead));
  }

  // Method to mark all logbooks as read for a student
  Future<void> markLogBooksAsRead({
    required int studentId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(studentId);
    await prefs.setString(key, DateTime.now().toIso8601String());
  }
}

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}