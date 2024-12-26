import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/student/ui/home/bloc/student_display_cubit.dart';
import 'package:sitama/features/student/ui/home/bloc/student_display_state.dart';
import 'package:sitama/features/student/ui/home/widgets/notification_badge.dart';


class NotificationBadgeContainer extends StatelessWidget {
  final Function(BuildContext) onPressed;
  final ColorScheme colorScheme;

  const NotificationBadgeContainer({
    super.key,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: BlocBuilder<StudentDisplayCubit, StudentDisplayState>(
        builder: (context, state) {
          int unreadCount = 0;
          
          if (state is StudentLoaded && state.notifications != null) {
            unreadCount = state.notifications!.getUnreadCount();
          }

          return NotificationBadge(
            count: unreadCount,
            child: Builder(
              builder: (BuildContext ctx) => IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: colorScheme.onPrimary,
                ),
                onPressed: () => onPressed(ctx),
              ),
            ),
          );
        },
      ),
    );
  }
}