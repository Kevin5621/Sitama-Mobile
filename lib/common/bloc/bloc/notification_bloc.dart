import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_event.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_state.dart';
import 'package:sistem_magang/data/models/notification.dart';
import 'package:sistem_magang/domain/usecases/student/notification/add_notification.dart';

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AddNotificationsUseCase addNotificationsUseCase;

  NotificationBloc({required this.addNotificationsUseCase}) : super(NotificationInitial()) {
    on<SendNotification>(_onSendNotification);
  }

  Future<void> _onSendNotification(
    SendNotification event, 
    Emitter<NotificationState> emit
  ) async {
    emit(NotificationLoading());

    try {
      for (final userId in event.userIds) {
        final request = AddNotificationReqParams(
          userId: userId,
          message: event.notificationData['message'],
          date: event.notificationData['date'] ?? DateTime.now().toIso8601String().split('T').first,
          category: event.notificationData['category'] ?? 'general',
          detailText: event.notificationData['title'],
        );

        final result = await addNotificationsUseCase(param: request);

        result.fold(
          (failure) => emit(NotificationError(failure.toString())),
          (success) => emit(const NotificationSent('Notification sent successfully')),
        );
      }
    } catch (e) {
      emit(NotificationError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}