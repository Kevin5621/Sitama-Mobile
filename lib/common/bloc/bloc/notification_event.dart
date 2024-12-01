import 'package:equatable/equatable.dart';

// Base class for all notification-related events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class SendNotification extends NotificationEvent {
  final Map<String, dynamic> notificationData; // Notification details (message, date, category, detailtext)
  final Set<int> userIds; // Unique IDs of users to whom notifications will be sent

  const SendNotification({
    required this.notificationData,
    required this.userIds,
  });

  @override
  List<Object> get props => [notificationData, userIds];
}
