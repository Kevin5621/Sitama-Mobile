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
      case 'bimbingan':
        return Icons.school;
      case 'logbook':
        return Icons.book;
      case 'revisi':
        return Icons.edit_document;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(ColorScheme colorScheme) {
    switch (widget.notification.type) {
      case 'bimbingan':
        return Colors.blue;
      case 'logbook':
        return Colors.orange;
      case 'revisi':
        return Colors.red;
      default:
        return colorScheme.onSecondary;
    }
  }

  String _truncateText(String text) {
    List<String> words = text.split(' ');
    if (words.length <= 10) return text;
    return '${words.take(10).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notificationColor = _getNotificationColor(colorScheme);

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
          color: widget.notification.isRead 
          ? colorScheme.surface 
          : colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with seamless gradient
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: notificationColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getNotificationIcon(),
                      size: 16,
                      color: notificationColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.notification.type.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: notificationColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.notification.date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.3,
                            fontWeight: widget.notification.isRead 
                                ? FontWeight.normal 
                                : FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (isExpanded && widget.notification.detailText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.notification.detailText!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                height: 1.4,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Expand/Collapse button with gradient-aware styling
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
                          color: widget.notification.isRead
                              ? colorScheme.surfaceContainerHighest.withOpacity(0.3)
                              : colorScheme.primary.withOpacity(0.05),
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
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: notificationColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              isExpanded 
                                  ? Icons.keyboard_arrow_up 
                                  : Icons.keyboard_arrow_down,
                              color: notificationColor,
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