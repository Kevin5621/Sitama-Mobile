// States
import 'package:equatable/equatable.dart';

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
