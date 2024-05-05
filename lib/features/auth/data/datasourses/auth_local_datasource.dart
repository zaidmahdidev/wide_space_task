// import 'dart:convert';
//
// import 'package:dartz/dartz.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../core/constants.dart';
// import '../../../../core/errors/exceptions.dart';
// import '../models/user_model.dart';
//
// class AuthLocalDataSourceImplementationWithSharedPreferences {
//   final SharedPreferences sharedPreferences;
//
//   AuthLocalDataSourceImplementationWithSharedPreferences(
//       {required this.sharedPreferences});
//
//   Future<Unit> cacheMyInfo(UserModel user) {
//     Map<String, dynamic> userJson = user.toJson();
//     sharedPreferences.setString(cachedUserInfo, json.encode(userJson));
//     print("user is " + user.toString());
//     return Future.value(unit);
//   }
//
//   Future<UserModel> getMyInfo() {
//     final jsonString = sharedPreferences.getString(cachedUserInfo);
//     if (jsonString != null) {
//       Map<String, dynamic> decodedJsonData = json.decode(jsonString);
//       UserModel userInfo = UserModel.fromJson(decodedJsonData);
//
//       return Future.value(userInfo);
//     } else {
//       throw EmptyCacheException();
//     }
//   }
//
//   Future<bool> deleteMyInfo() {
//     try {
//       sharedPreferences.setString(cachedUserInfo, '');
//       sharedPreferences.setString(tokenKey, '');
//       sharedPreferences.setString(myIdKey, '');
//       return Future.value(true);
//     } catch (e) {
//       return Future.value(false);
//     }
//   }
// }
