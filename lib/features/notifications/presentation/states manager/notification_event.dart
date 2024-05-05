part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class ToAllNotifications extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ToUnreadNotifications extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
