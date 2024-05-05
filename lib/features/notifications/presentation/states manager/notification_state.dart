part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class AllNotifications extends NotificationState {
  @override
  List<Object> get props => [];
}

class UnreadNotifications extends NotificationState {
  @override
  List<Object> get props => [];
}
