// Events
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class SendNotification extends NotificationEvent {
  final Map<String, dynamic> notificationData;
  final Set<int> userIds;

  const SendNotification({
    required this.notificationData,
    required this.userIds,
  });

  @override
  List<Object> get props => [notificationData, userIds];
}