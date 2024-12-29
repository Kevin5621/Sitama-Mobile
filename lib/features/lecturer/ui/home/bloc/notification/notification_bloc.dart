import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_event.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_state.dart';
import 'package:sitama/features/student/data/models/notification.dart';
import 'package:sitama/features/student/domain/usecases/notification/add_notification.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AddNotificationsUseCase addNotificationsUseCase;

  NotificationBloc({required this.addNotificationsUseCase}) : super(NotificationInitial()) {
    on<SendNotification>(_onSendNotification);
  }

  Future<void> _onSendNotification(
    SendNotification event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final request = AddNotificationReqParams(
        userIds: event.notificationData['user_id'],
        message: event.notificationData['message'],
        date: event.notificationData['date'] ?? DateTime.now().toIso8601String().split('T').first,
        category: event.notificationData['category'] ?? 'general',
        detailText: event.notificationData['detailText'],
      );

      final result = await addNotificationsUseCase(param: request);

      result.fold(
        (failure) => emit(NotificationError(failure.toString())),
        (success) => emit(const NotificationSent('Notification sent successfully')),
      );
    } catch (e) {
      // Catch unexpected errors and emit a failure state
      emit(NotificationError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
