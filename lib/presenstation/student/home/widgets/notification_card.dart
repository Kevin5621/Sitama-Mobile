// notification_card.dart
import 'package:flutter/material.dart';
import 'package:sistem_magang/data/models/notification.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isExpanded = false;

  IconData _getNotificationIcon() {
    switch (widget.notification.type) {
      case 'guidance':
        return Icons.school;
      case 'logbook':
        return Icons.book;
      case 'revision':
        return Icons.edit_document;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (widget.notification.type) {
      case 'guidance':
        return Colors.blue;
      case 'logbook':
        return Colors.orange;
      case 'revision':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _truncateText(String text) {
    List<String> words = text.split(' ');
    if (words.length <= 10) return text;
    return '${words.take(10).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          widget.onTap();
          setState(() {
            isExpanded = !isExpanded;
          });
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: widget.notification.isRead ? Colors.white : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.notification.isRead 
                    ? Colors.grey[100] 
                    : Colors.blue.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: _getNotificationColor(),
                    child: Icon(
                      _getNotificationIcon(),
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.notification.type.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.notification.date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpanded 
                              ? widget.notification.message
                              : _truncateText(widget.notification.message),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.3,
                            fontWeight: widget.notification.isRead 
                                ? FontWeight.normal 
                                : FontWeight.w500,
                          ),
                        ),
                        if (isExpanded && widget.notification.detailText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.notification.detailText!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Expand/Collapse button
                  if (widget.notification.message.split(' ').length > 10 || 
                      widget.notification.detailText != null)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isExpanded ? 'Show Less' : 'Read More',
                              style: TextStyle(
                                color: _getNotificationColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              isExpanded 
                                  ? Icons.keyboard_arrow_up 
                                  : Icons.keyboard_arrow_down,
                              color: _getNotificationColor(),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}