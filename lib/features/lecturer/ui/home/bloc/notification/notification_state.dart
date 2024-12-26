import 'package:equatable/equatable.dart';

// Base class for all notification-related states
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

// Initial state when no action has occurred
class NotificationInitial extends NotificationState {}

// State indicating a loading process
class NotificationLoading extends NotificationState {}

// State for successful notification sending
class NotificationSent extends NotificationState {
  final String message; // Success message to provide feedback

  const NotificationSent(this.message);

  @override
  List<Object> get props => [message];
}

// State for error occurrences
class NotificationError extends NotificationState {
  final String errorMessage; // Description of the error

  const NotificationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
