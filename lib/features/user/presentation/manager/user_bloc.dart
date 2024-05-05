import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/current_provider.dart';
import '../../../../core/utils/common_utils.dart';
import '../../data/models/direction_model.dart';
import '../../data/models/map_service_points_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<UserEvent>(_onUserEvent);
  }

  void _onUserEvent(UserEvent event, Emitter<UserState> emit) async {
    if (kDebugMode) {
      print("event is $event");
    }
    if (event is LoginRequest) {
      emit(const UserLoading());

      final failureOrData = await repository.sendLoginRequest(
        id: event.id,
        password: event.password,
      );

      failureOrData.fold(
        (failure) {
          emit(LoginError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(LoginLoaded(user: data));
        },
      );
    }

    if (event is RegisterRequest) {
      emit(const UserLoading());

      final failureOrData = await repository.sendSignUpRequest(
          user: event.user, password: event.password);

      failureOrData.fold(
        (failure) {
          emit(RegisterError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(RegisterLoaded(user: data));
        },
      );
    }

    if (event is Logout) {
      logout(redirect: true, clearCache: event.clearCache);
      emit(UserInitial());
    }

    if (event is VerifyOTP) {
      final failureOrData = await repository.sendVerifyOTPRequest(
        otp: event.otp,
      );

      failureOrData.fold(
        (failure) {
          emit(VerificationError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(VerificationLoaded(user: data));
        },
      );
    }

    if (event is ReSendOTP) {
      final failureOrData = await repository.resendOTPRequest();
      failureOrData.fold(
        (failure) {
          emit(ReSendOTPError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(ReSendOTPLoaded());
        },
      );
    }

    if (event is GetMyProfileData) {
      emit(const UserLoading());
      final failureOrData = await repository.getMyInfo();

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          Current.user = data;
          emit(UserLoaded(user: data));
        },
      );
    }

    if (event is GetUserRequest) {
      emit(const UserLoading());
      final failureOrData = await repository.getUserInfo(userId: event.userId);

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(UserLoaded(user: data));
        },
      );
    }

    if (event is UpdateProfileRequest) {
      emit(const UserLoading());

      final failureOrData = await repository.editMyInfo(user: event.user);

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          Current.user = data;
          emit(UserLoaded(user: data));
        },
      );
    }

    if (event is SwitchToEditProfile) {
      emit(UserEdit(user: Current.user));
    }

    if (event is SwitchToViewProfile) {
      emit(UserLoaded(user: Current.user));
    }

    if (event is ChangePasswordRequest) {
      emit(const UserLoading());

      final failureOrData = await repository.changePasswordRequest(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(const PasswordChanged());
        },
      );
    }

    if (event is ForgetPassword) {
      emit(const UserLoading());

      final failureOrData = await repository.forgetPassword(
        phoneNumber: event.phoneNumber,
      );

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(const ForgetPasswordOtpSent());
        },
      );
    }

    if (event is ResetPassword) {
      emit(const UserLoading());

      final failureOrData = await repository.resetPassword(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
        newPassword: event.password,
      );

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(const PasswordResetCompleted());
        },
      );
    }

    if (event is GetServicePoints) {
      emit(const ServicePointsLoading());

      final failureOrData = await repository.getServicePoints();

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          emit(ServicePointsLoaded(servicePoints: data));
        },
      );
    }

    if (event is GetDirections) {
      emit(const DirectionLoading());
      final failureOrData = await repository.getDirections(
          origin: event.origin, destination: event.destination);

      failureOrData.fold(
        (failure) {
          emit(UserError(message: mapFailureToMessage(failure)));
        },
        (data) {
          if (data.totalDistance?.isEmpty ?? true) {
            emit(const DirectionNotFound());
          } else {
            emit(DirectionLoaded(direction: data));
          }
        },
      );
    }
  }
}
