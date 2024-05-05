part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class RegisterRequest extends UserEvent {
  final UserModel user;
  final String password;

  const RegisterRequest({required this.user, required this.password});

  @override
  List<Object> get props => [user, password];
}

class LoginRequest extends UserEvent {
  final String id;
  final String password;

  const LoginRequest({
    required this.id,
    required this.password,
  });

  @override
  List<Object> get props => [id, password];
}

class Logout extends UserEvent {
  final bool clearCache;

  const Logout({required this.clearCache});
  @override
  List<Object> get props => [clearCache];
}

class ChangePasswordRequest extends UserEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class ChangeEmailRequest extends UserEvent {
  final String oldEmail;
  final String newEmail;

  const ChangeEmailRequest({
    required this.oldEmail,
    required this.newEmail,
  });

  @override
  List<Object> get props => [oldEmail, newEmail];
}

class VerifyUserRequest extends UserEvent {
  final String firebaseUserId;

  const VerifyUserRequest({
    required this.firebaseUserId,
  });

  @override
  List<Object> get props => [firebaseUserId];
}

class VerifyOTP extends UserEvent {
  final String otp;

  const VerifyOTP({
    required this.otp,
  });

  @override
  List<Object> get props => [otp];
}

class ReSendOTP extends UserEvent {
  const ReSendOTP();

  @override
  List<Object> get props => [];
}

class GetUserRequest extends UserEvent {
  final int userId;
  const GetUserRequest({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetMyProfileData extends UserEvent {
  const GetMyProfileData();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequest extends UserEvent {
  final UserModel user;

  const UpdateProfileRequest({required this.user});

  @override
  List<Object?> get props => [user];
}

class SwitchToViewProfile extends UserEvent {
  @override
  List<Object?> get props => [];
}

class SwitchToEditProfile extends UserEvent {
  @override
  List<Object?> get props => [];
}

class ForgetPassword extends UserEvent {
  final String phoneNumber;

  const ForgetPassword({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class GetServicePoints extends UserEvent {
  const GetServicePoints();

  @override
  List<Object> get props => [];
}

class GetDirections extends UserEvent {
  final LatLng origin;
  final LatLng destination;

  const GetDirections({required this.origin, required this.destination});

  @override
  List<Object> get props => [];
}

class ResetPassword extends UserEvent {
  final String phoneNumber;
  final String password;
  final String otp;

  const ResetPassword({
    required this.phoneNumber,
    required this.password,
    required this.otp,
  });

  @override
  List<Object> get props => [phoneNumber, password, otp];
}
