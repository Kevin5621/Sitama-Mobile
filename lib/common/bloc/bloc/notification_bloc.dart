import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sistem_magang/data/models/notification.dart';
import 'package:sistem_magang/domain/usecases/student/notification/add_notification.dart';

// Events
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

// States
abstract class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSent extends NotificationState {
  final String message;

  const NotificationSent(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationError extends NotificationState {
  final String errorMessage;

  const NotificationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

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