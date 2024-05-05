part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class RegisterLoaded extends UserState {
  final UserModel user;

  const RegisterLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class RegisterError extends UserState {
  final String message;

  const RegisterError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class LoginLoaded extends UserState {
  final UserModel user;

  const LoginLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginError extends UserState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class UserLoaded extends UserState {
  final UserModel user;

  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserEdit extends UserState {
  final UserModel user;

  @override
  List<Object> get props => [user];

  const UserEdit({required this.user});
}

class ServicePointsLoaded extends UserState {
  final MapServicePoints servicePoints;

  const ServicePointsLoaded({required this.servicePoints});

  @override
  List<Object> get props => [servicePoints];
}

class PasswordChanged extends UserState {
  const PasswordChanged();

  @override
  List<Object> get props => [];
}

class EmailChanged extends UserState {
  const EmailChanged();

  @override
  List<Object> get props => [];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class UserLoading extends UserState {
  const UserLoading();

  @override
  List<Object> get props => [];
}

class ServicePointsLoading extends UserState {
  const ServicePointsLoading();

  @override
  List<Object> get props => [];
}

class VerificationLoaded extends UserState {
  final UserModel user;

  const VerificationLoaded({required this.user});

  @override
  List<Object> get props => [];
}

class VerificationError extends UserState {
  final String message;

  const VerificationError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class ReSendOTPLoaded extends UserState {
  @override
  List<Object> get props => [];
}

class ReSendOTPError extends UserState {
  final String message;

  const ReSendOTPError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class ForgetPasswordOtpSent extends UserState {
  const ForgetPasswordOtpSent();

  @override
  List<Object> get props => [];

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class PasswordResetCompleted extends UserState {
  const PasswordResetCompleted();

  @override
  List<Object> get props => [];

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class DirectionLoading extends UserState {
  const DirectionLoading();

  @override
  List<Object> get props => [];
}

class DirectionNotFound extends UserState {
  const DirectionNotFound();

  @override
  List<Object> get props => [];
}

class DirectionLoaded extends UserState {
  final DirectionModel direction;
  const DirectionLoaded({required this.direction});

  @override
  List<Object> get props => [];
}
