// notification_item.dart
import 'package:flutter/material.dart';

enum NotificationType {
  generalAnnouncement,
  guidanceApproved,
  guidanceRejected,
  logbookComment,
  newGuidance,
  revisedGuidance
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? senderName;
  final String? avatarUrl;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.senderName,
    this.avatarUrl,
  });
}

class NotificationListItem extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;

  const NotificationListItem({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
  }) : super(key: key);

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.generalAnnouncement:
        return Icons.campaign;
      case NotificationType.guidanceApproved:
        return Icons.check_circle;
      case NotificationType.guidanceRejected:
        return Icons.cancel;
      case NotificationType.logbookComment:
        return Icons.comment;
      case NotificationType.newGuidance:
        return Icons.new_releases;
      case NotificationType.revisedGuidance:
        return Icons.update;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.generalAnnouncement:
        return Colors.blue;
      case NotificationType.guidanceApproved:
        return Colors.green;
      case NotificationType.guidanceRejected:
        return Colors.red;
      case NotificationType.logbookComment:
        return Colors.purple;
      case NotificationType.newGuidance:
        return Colors.orange;
      case NotificationType.revisedGuidance:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: notification.isRead ? 0 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: notification.isRead ? Colors.transparent : _getNotificationColor(),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIcon(),
                  color: _getNotificationColor(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    if (notification.senderName != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (notification.avatarUrl != null)
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(notification.avatarUrl!),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            notification.senderName!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}