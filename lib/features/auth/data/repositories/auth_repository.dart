// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:ebn_balady/core/errors/failures.dart';
// import 'package:ebn_balady/core/repository.dart';
// import 'package:ebn_balady/injection_container.dart' as di;
// import 'package:oauth_dio/oauth_dio.dart';
//
// import '../../../../core/data_providers/remote_data_provider.dart';
// import '../../../../core/errors/exceptions.dart';
// import '../../../../core/network/data_source_url.dart';
// import '../../../../core/utils/common_utils.dart';
// import '../../../user/data/repositories/oauth_repository.dart';
// import '../models/auth_model.dart';
// import '../models/user_model.dart';
//
// class AuthRepository extends Repository {
//   Future<Either<Failure, dynamic>> login({
//     required String id,
//     required String password,
//   }) async {
//     return await sendRequest(
//         checkConnection: networkInfo.isConnected,
//         remoteFunction: () async {
//           try {
//             if (!OAuthRepository.isExists || password.isNotEmpty) {
//               await di.sl<OAuth>().storage.clear();
//               await di.sl<OAuth>().requestTokenAndSave(
//                     PasswordGrant(
//                       username: parsePhone(id)!,
//                       password: password,
//                       scope: [],
//                     ),
//                   );
//             }
//           } on DioError catch (e) {
//             if ((e.response!.data is Map) &&
//                 (e.response!.data as Map).containsKey('errors')) {
//               throw CustomException(
//                   message: ((e.response!.data['errors'] as Map)[
//                           (e.response!.data['errors'] as Map).keys.first]
//                       as List)[0]);
//             } else {
//               throw InvalidException();
//             }
//           }
//
//           final dynamic remoteData;
//           try {
//             remoteData = await remoteDataProvider.sendData(
//               requestType: RequestTypes.post,
//               url: DataSourceURL.getLoginEndPoint,
//               retrievedDataType: UserModel.init(),
//               returnType: Map,
//               body: {"username": id, "password": password},
//               cacheKey: 'CACHED_USER',
//             );
//           } catch (e, s) {
//             di.logger.d('login catch', e, s);
//             return throw UnexpectedException();
//           }
//           return remoteData;
//         });
//
//     //   try {
//     //     final remoteAuth = await remoteDataSource.login(authModel);
//     //     localDataSource.cacheMyInfo(remoteAuth);
//     //     return Right(remoteAuth);
//     //   } on ServerException {
//     //     return Left(ServerFailure());
//     //   }
//     // } else {
//     //   try {
//     //     return Left(OfflineFailure());
//     //   } on EmptyCacheException {
//     //     return Left(EmptyCacheFailure());
//     //   }
//     // }
//   }
//
//   Future<Either<Failure, bool>> logout() async {
//     // final infoDeleted = await localDataSource.deleteMyInfo();
//     // if (infoDeleted) {
//     //   return Right(infoDeleted);
//     // } else {
//     //   return Left(EmptyCacheFailure());
//     // }
//     return const Right(true);
//   }
//
//   Future<Either<Failure, dynamic>> signup(AuthModel auth) async {
//     return await sendRequest(
//         checkConnection: networkInfo.isConnected,
//         remoteFunction: () async {
//           final dynamic remoteData;
//           try {
//             remoteData = await remoteDataProvider.sendData(
//               requestType: RequestTypes.post,
//               url: DataSourceURL.getSignupEndPoint,
//               retrievedDataType: UserModel.init(),
//               returnType: Map,
//               body: {
//                 'firstName': auth.firstName,
//                 'middleName': auth.middleName,
//                 'lastName': auth.lastName,
//                 'username': auth.username,
//                 'password': auth.password,
//                 'gender': auth.gender,
//                 'email': auth.email,
//                 'country': auth.country,
//                 'city': auth.city,
//                 'district': auth.district,
//                 'neighborhood': auth.neighborhood,
//                 'phones': auth.phones,
//               },
//               cacheKey: 'CACHED_USER',
//             );
//           } catch (e, s) {
//             di.logger.d('login catch', e, s);
//             return throw UnexpectedException();
//           }
//           return remoteData;
//         });
//     //   try {
//     //     await remoteDataSource.signup(authModel);
//     //     return const Right(unit);
//     //   } on ServerException {
//     //     return Left(ServerFailure());
//     //   }
//     // } else {
//     //   try {
//     //     return Left(OfflineFailure());
//     //   } on EmptyCacheException {
//     //     return Left(EmptyCacheFailure());
//     //   }
//     // }
//   }
//
//   Future<Either<Failure, dynamic>> changePasswordRequest({
//     required String oldPassword,
//     required String newPassword,
//   }) async {
//     return await sendRequest(
//       checkConnection: networkInfo.isConnected,
//       remoteFunction: () async {
//         final dynamic remoteData;
//
//         remoteData = await remoteDataProvider.sendData(
//           url: DataSourceURL.getChangePasswordPoint,
//           retrievedDataType: UserModel.init(),
//           body: {'old': oldPassword, 'new': newPassword},
//         );
//
//         return remoteData;
//       },
//     );
//   }
//
//   Future<Either<Failure, dynamic>> getMyInfo() async {
//     return await sendRequest(
//       checkConnection: networkInfo.isConnected,
//       remoteFunction: () async {
//         final dynamic remoteData;
//         try {
//           remoteData = await remoteDataProvider.sendData(
//             requestType: RequestTypes.get,
//             url: DataSourceURL.getMyEndPoint,
//             returnType: Map,
//             retrievedDataType: UserModel.init(),
//             cacheKey: 'CACHED_USER',
//           );
//         } catch (e) {
//           return throw ServerException();
//         }
//         return remoteData;
//       },
//     );
//
//     // if (await networkInfo.isConnected) {
//     //   try {
//     //     final remoteAuth = await remoteDataSource.getMyInfo();
//     //     return Right(remoteAuth);
//     //   } on ServerException {
//     //     return Left(ServerFailure());
//     //   }
//     // } else {
//     //   try {
//     //     final localUserInfo = await localDataSource.getMyInfo();
//     //     return Right(localUserInfo);
//     //   } on OfflineFailure {
//     //     return Left(OfflineFailure());
//     //   } on EmptyCacheException {
//     //     return Left(EmptyCacheFailure());
//     //   }
//     // }
//   }
//
//   Future<Either<Failure, dynamic>> getUserInfo({
//     required int userId,
//   }) async {
//     return await sendRequest(
//       checkConnection: networkInfo.isConnected,
//       remoteFunction: () async {
//         final dynamic remoteData;
//
//         remoteData = await remoteDataProvider.sendData(
//           url: DataSourceURL.getUserEndPoint(userId: userId),
//           requestType: RequestTypes.get,
//           retrievedDataType: UserModel.init(),
//           returnType: Map,
//         );
//         return remoteData;
//       },
//     );
//     // if (await networkInfo.isConnected) {
//     //   try {
//     //     final remoteAuth = await remoteDataSource.getUserInfo(userId);
//     //     return Right(remoteAuth);
//     //   } on ServerException {
//     //     return Left(ServerFailure());
//     //   }
//     // } else {
//     //   try {
//     //     return Left(OfflineFailure());
//     //   } on EmptyCacheException {
//     //     return Left(EmptyCacheFailure());
//     //   }
//     // }
//   }
//
//   Future<Either<Failure, dynamic>> editMyInfo(UserModel user) async {
//     return await sendRequest(
//       checkConnection: networkInfo.isConnected,
//       remoteFunction: () async {
//         final dynamic remoteData;
//         remoteData = await remoteDataProvider.sendData(
//           url: DataSourceURL.getMyEndPoint,
//           retrievedDataType: UserModel.init(),
//           requestType: RequestTypes.post,
//           returnType: Map,
//           body: user.toFormData(),
//         );
//         return remoteData;
//       },
//     );
//     // if (await networkInfo.isConnected) {
//     //   UserModel userModel = UserModel(
//     //     avatar: user.avatar,
//     //     username: user.username,
//     //     firstName: user.firstName,
//     //     middleName: user.middleName,
//     //     lastName: user.lastName,
//     //     neighborhood: user.neighborhood,
//     //     country: user.country,
//     //     city: user.city,
//     //     district: user.district,
//     //     phones: user.phones,
//     //   );
//     //   try {
//     //     final remoteAuth = await remoteDataSource.editMyInfo(userModel);
//     //     localDataSource.cacheMyInfo(remoteAuth);
//     //     return Right(remoteAuth);
//     //   } on ServerException {
//     //     return Left(ServerFailure());
//     //   }
//     // } else {
//     //   try {
//     //     return Left(OfflineFailure());
//     //   } on EmptyCacheException {
//     //     return Left(EmptyCacheFailure());
//     //   }
//     // }
//   }
// }
