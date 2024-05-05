// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:ebn_balady/features/auth/data/models/auth_model.dart';
// import 'package:ebn_balady/features/auth/data/models/user_model.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../../../../core/constants.dart';
// import '../../../../../core/errors/failures.dart';
// import '../../../data/repositories/auth_repository.dart';
//
// part 'auth_event.dart';
// part 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepository;
//   AuthBloc({
//     required this.authRepository,
//   }) : super(AuthInitial()) {
//     on<AuthEvent>((event, emit) async {
//       if (event is Login) {
//         emit(AuthLoading());
//         final failureOrUser =
//             await authRepository.login(password: event.password, id: event.id);
//         emit(_mapFailureOrUserToState(failureOrUser));
//       } else if (event is Signup) {
//         emit(AuthLoading());
//         final failureOrUnit = await authRepository.signup(event.auth);
//         emit(_mapFailureOrUnitToState(failureOrUnit));
//       } else if (event is Logout) {
//         emit(AuthLoading());
//         await authRepository.logout();
//         emit(AuthInitial());
//       }
//     });
//   }
//
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return serverFailureMessage;
//       case EmptyCacheFailure:
//         return emptyCacheFailureMessage;
//       case OfflineFailure:
//         return offlineFailureMessage;
//       default:
//         return unexpectedFailureMessage;
//     }
//   }
//
//   AuthState _mapFailureOrUserToState(
//       Either<Failure, dynamic> failureOrRequests) {
//     return failureOrRequests.fold(
//         (failure) => AuthError(message: _mapFailureToMessage(failure)),
//         (user) => AuthLoaded(user: user));
//   }
//
//   AuthState _mapFailureOrUnitToState(Either<Failure, dynamic> failureOrUnit) {
//     return failureOrUnit.fold(
//         (failure) => AuthError(message: _mapFailureToMessage(failure)),
//         (unit) => AuthRegistered());
//   }
// }
