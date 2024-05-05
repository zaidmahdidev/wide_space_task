// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:ebn_balady/features/auth/data/models/auth_model.dart';
// import 'package:ebn_balady/injection_container.dart' as di;
//
// import '../../../../core/constants.dart';
// import '../../../../core/data_providers/remote_data_provider.dart';
// import '../../../../core/errors/exceptions.dart';
// import '../../../../core/network/data_source_url.dart';
// import '../models/user_model.dart';
//
// class AuthRemoteDataSource extends RemoteDataProvider {
//   final Dio dio;
//
//
//
//   Future<UserModel> login(AuthModel auth) async {
//     final response =
//         await signinOrSignup(auth, DataSourceURL.getLoginEndPoint());
//     if (response.statusCode == 200) {
//       Map<String, dynamic> decodedJsonData = response.data;
//       UserModel userModel = UserModel.fromJson(decodedJsonData);
//       print("usermodel inside is $userModel");
//       token = userModel.token ?? '';
//       di.sl.get<SharedPreferences>().setInt(myIdKey, userModel.id ?? 0);
//       if (token != null && token != '') {
//         di.sl.get<SharedPreferences>().setString(tokenKey, token ?? "");
//       }
//       return Future.value(userModel);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   Future<Unit> signup(AuthModel auth) async {
//     final response =
//         await signinOrSignup(auth, DataSourceURL.getSignupEndPoint());
//     if (response.statusCode == 201) {
//       return Future.value(unit);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   Future<Response> signinOrSignup(AuthModel auth, endPoint) async {
//     try {
//       final response = await dio.post(endPoint,
//           data: auth.toFormData(),
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Accept": "application/json",
//           }));
//       return response;
//     } on DioError catch (e) {
//       print(e.response?.data);
//     }
//     throw ServerException();
//   }
//
//   Future<UserModel> getUserInfo(int userId) async {
//     const endPoint = "v1/users/";
//     try {
//       final response = await dio.get(baseUrl + endPoint + userId.toString(),
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Accept": "application/json",
//             "Authorization": "Bearer $token"
//           }));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> decodedJsonData = response.data;
//         UserModel userModel = UserModel.fromJson(decodedJsonData);
//         return Future.value(userModel);
//       } else {
//         throw ServerException();
//       }
//     } catch (e) {
//       print("exception is : $e");
//       throw ServerException();
//     }
//   }
//
//   Future<UserModel> editMyInfo(UserModel user) async {
//     const endPoint = "v1/users/me";
//     const method = "?_method=PUT";
//     print("user insite edit remote is $user");
//     user.toFormData();
//     try {
//       final response = await dio.post("$baseUrl$endPoint$method",
//           data: user.toFormData(),
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Accept": "application/json",
//             "Authorization": "Bearer $token"
//           }));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> decodedJsonData = response.data;
//         print("decoded json insite edit remote is $decodedJsonData");
//         UserModel userModel = UserModel.fromJson(decodedJsonData);
//         print("userModel insite edit remote is $userModel");
//         return Future.value(userModel);
//       } else {
//         throw ServerException();
//       }
//     } catch (e, s) {
//       print(s);
//       print(e);
//       throw ServerException();
//     }
//   }
//
//   Future<UserModel> getMyInfo() async {
//     const endPoint = "v1/users/me";
//     try {
//       final response = await dio.get(baseUrl + endPoint,
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Accept": "application/json",
//             "Authorization": "Bearer $token"
//           }));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> decodedJsonData = response.data;
//         UserModel userModel = UserModel.fromJson(decodedJsonData);
//
//         return Future.value(userModel);
//       } else {
//         throw ServerException();
//       }
//     } catch (e) {
//       print("exception is : $e");
//       throw ServerException();
//     }
//   }
// }
