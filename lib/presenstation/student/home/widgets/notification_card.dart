import 'package:flutter/material.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/data/models/notification.dart';

// NotificationCard with dynamic theming support
class NotificationCard extends StatefulWidget {
  final NotificationItemEntity notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  // Tracks the expanded state of the notification card
  bool _isExpanded = false;

  // Pemetaan nama kategori untuk ditampilkan
  final Map<String, String> categoryDisplayNames = {
    'general': 'Pengumuman Dosen',
    'guidance': 'Bimbingan',
    'log_book': 'Catatan Harian',
    'revisi': 'Revisi',
  };

  // Toggles the expanded state and triggers optional callback
  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Map notification categories to specific icons
    // Use theme-based colors for consistency
    IconData icon;
    Color color;
    switch (widget.notification.category.toLowerCase()) {
      case 'general':
        icon = Icons.campaign;
        color = colorScheme.primary;
        break;
      case 'guidance':
        icon = Icons.check;
        color = AppColors.lightSuccess;
        break;
      case 'log_book':
        icon = Icons.book;
        color = colorScheme.tertiary;
        break;
      case 'revisi':
        icon = Icons.edit_document;
        color = AppColors.lightDanger;
        break;
      default:
        icon = Icons.notifications;
        color = colorScheme.primary;
    }

    // Main notification card container with theme-aware design
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            // Smooth transition for visual state changes
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // Background color varies based on read status and theme
            decoration: BoxDecoration(
              color: widget.notification.isRead == 1 
                ? colorScheme.surfaceContainer
                : color.withAlpha((0.1*255).round()),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // Enable tap interaction to expand/collapse
                onTap: _toggleExpand,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row with icon, category, and date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Circular icon container with theme-based color
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withAlpha((0.1*255).round()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: color, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category and date header
                                Row(
                                  children: [
                                    Text(
                                          categoryDisplayNames[widget.notification.category.toLowerCase()] ?? 
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
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Notification message with read status styling
                                Text(
                                  widget.notification.message,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    // Emphasize unread notifications
                                    fontWeight: widget.notification.isRead == 1 
                                      ? FontWeight.normal 
                                      : FontWeight.w600,
                                  ),
                                  // Limit lines and handle overflow
                                  maxLines: _isExpanded ? null : 2,
                                  overflow: _isExpanded 
                                    ? TextOverflow.visible 
                                    : TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Expandable detailed text section
                      // Only shown when card is expanded and detail exists
                      if (widget.notification.detailText != null && _isExpanded)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // Subtle background for additional details using theme colors
                              color: colorScheme.tertiary.withAlpha((0.2*255).round()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.notification.detailText!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}