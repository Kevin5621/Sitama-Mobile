import 'package:flutter/material.dart';
import 'package:sistem_magang/data/models/notification.dart';

// This widget includes an expandable feature for messages with overflow
// and dynamically adjusts based on the notification's category and read status.
class NotificationCard extends StatefulWidget {
  // The notification data to be displayed.
  final NotificationItemEntity notification;

  // A callback function triggered when the card is tapped.
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  // Tracks whether the notification's message is expanded or collapsed.
  bool _isExpanded = false;

  // Determines the icon to display based on the notification category.
  IconData _getNotificationIcon() {
    switch (widget.notification.category.toLowerCase()) {
      case 'general':
        return Icons.campaign;
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

  // Determines the color to use based on the notification category.
  Color _getNotificationColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.notification.category.toLowerCase()) {
      case 'general':
        return Colors.blue;
      case 'guidance':
        return Colors.green;
      case 'logbook':
        return Colors.orange;
      case 'revisi':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  // Checks if the notification's message overflows within the provided constraints.
  bool _hasTextOverflow(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getNotificationColor(context);
    final textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          height: 1.3,
        );
        final hasOverflow = _hasTextOverflow(
          widget.notification.message,
          textStyle!,
          constraints.maxWidth - 76,
        );

        final backgroundColor = widget.notification.isRead == 1
            ? (theme.brightness == Brightness.dark
                ? Colors.black54
                : Colors.white)
            : color.withOpacity(0.1); 

        final containerDecoration = BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: widget.notification.isRead == 0
              ? Border.all(color: color.withOpacity(0.3))
              : null,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: containerDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getNotificationIcon(),
                        size: 20,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Notification content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category and date
                          Row(
                            children: [
                              Text(
                                widget.notification.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                widget.notification.date,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Notification message
                          Text(
                            widget.notification.message,
                            style: textStyle,
                            maxLines: _isExpanded ? null : 3,
                            overflow: _isExpanded ? null : TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // "View more" toggle for overflowing text
              if (hasOverflow)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded ? 'Lihat lebih sedikit' : 'Lihat selengkapnya',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: color,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
