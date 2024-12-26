import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/features/student/domain/entities/notification_entity.dart';

/// A stateful widget to display and manage a notification item.
/// This widget handles showing a notification card with expandable details.
/// It also marks notifications as "read" using [SharedPreferences].
class LoadNotification extends StatefulWidget {
  /// Callback to handle close events for the notification.
  final VoidCallback onClose;

  /// The notification item to be displayed.
  /// If null, the widget will render as an empty container.
  final NotificationItemEntity? notification;

  const LoadNotification({
    super.key,
    required this.onClose,
    this.notification,
  });

  @override
  State<LoadNotification> createState() => _LoadNotificationState();
}

class _LoadNotificationState extends State<LoadNotification> with SingleTickerProviderStateMixin {
  /// Controls the expanded/collapsed state of the notification details.
  bool isExpanded = false;

  /// Animation controller for managing expansion and collapse animations.
  late AnimationController _controller;

  /// Animation for smooth expansion and collapse of the detail section.
  late Animation<double> _expandAnimation;

  /// Key prefix used for storing the "read" status of notifications in [SharedPreferences].
  static const String _readKeyPrefix = 'notification_read_';

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and expansion animation.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Check if the notification has been read, and expand if it hasn't.
    _checkAndExpandNotification();
  }

  /// Checks the "read" status of the notification from [SharedPreferences].
  /// If the notification has not been read, it automatically expands it and marks it as "read".
  Future<void> _checkAndExpandNotification() async {
    if (widget.notification == null) return;

    final prefs = await SharedPreferences.getInstance();
    final notificationId = widget.notification!.id;
    final readKey = '$_readKeyPrefix$notificationId';

    final bool isRead = prefs.getBool(readKey) ?? false;

    if (!isRead) {
      if (mounted) {
        setState(() {
          isExpanded = true;
          _controller.forward();
        });
      }

      // Mark the notification as "read" in SharedPreferences.
      await prefs.setBool(readKey, true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Toggles the expansion or collapse of the notification details.
  void _toggleExpand() {
    HapticFeedback.lightImpact();
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If no notification is provided, return an empty container.
    if (widget.notification == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: 2,
          shadowColor: colorScheme.shadow.withAlpha((0.1*255).round()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: colorScheme.outline.withAlpha((0.12*255).round()),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: _toggleExpand,
            borderRadius: BorderRadius.circular(16),
            splashColor: colorScheme.primary.withAlpha((0.1*255).round()),
            highlightColor: colorScheme.primary.withAlpha((0.05*255).round()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIcon(colorScheme),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    child: widget.notification!.detailText?.isNotEmpty == true
                        ? _buildDetailSection(context, colorScheme)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the icon displayed at the top-left of the notification card.
  Widget _buildIcon(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withAlpha((0.7*255).round()),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.08*255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.campaign_rounded,
        color: colorScheme.onSecondaryContainer,
        size: 22,
      ),
    );
  }

  /// Builds the header section of the notification card.
  /// Includes the notification message and date.
  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.notification!.message,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: colorScheme.onSurface,
            ),
            maxLines: isExpanded ? null : 2,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          widget.notification!.date,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds the detail section of the notification card.
  /// This section is expandable and collapsible.
  Widget _buildDetailSection(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.tertiary.withAlpha((0.35*255).round()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withAlpha((0.5*255).round()),
            width: 1,
          ),
        ),
        child: Text(
          widget.notification!.detailText!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
