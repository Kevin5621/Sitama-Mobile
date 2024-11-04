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
  bool _isExpanded = false;

  IconData _getNotificationIcon() {
    switch (widget.notification.type.toLowerCase()) {
      case 'General':
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

  Color _getNotificationColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.notification.type.toLowerCase()) {
      case 'generalannouncement':
        return Colors.blue;
      case 'bimbingan':
        return Colors.green;
      case 'logbook':
        return Colors.orange;
      case 'revisi':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

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
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = theme.textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
          height: 1.3,
        );
        final hasOverflow = _hasTextOverflow(
          widget.notification.message, 
          textStyle!, 
          constraints.maxWidth - 76 // Accounting for padding and icon
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: widget.notification.isRead 
                ? Colors.white 
                : color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
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
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with notification type
                          Row(
                            children: [
                              Text(
                                widget.notification.type,
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
                          // Message
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
              // Show expand button only if text overflows
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
      }
    );
  }
}