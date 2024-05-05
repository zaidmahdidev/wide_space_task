// import 'dart:convert';
//
// import 'package:dartz/dartz.dart';
// import 'package:ebn_balady/core/errors/exceptions.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../core/constants.dart';
// import '../models/comment/comment_model.dart';
//
// abstract class CommentsLocalDataSource {
//   Future<List<CommentModel>> getCachedComments();
//
//   Future<Unit> cacheComments(List<CommentModel> comments);
// }
//
// class CommentsLocalDataSourceImplementationWithSharedPreferences
//     implements CommentsLocalDataSource {
//   final SharedPreferences sharedPreferences;
//
//   CommentsLocalDataSourceImplementationWithSharedPreferences(
//       {required this.sharedPreferences});
//
//   @override
//   Future<Unit> cacheComments(List<CommentModel> comments) {
//     List requestsJson = comments
//         .map<Map<String, dynamic>>((request) => request.toJson())
//         .toList();
//     sharedPreferences.setString(cachedCommentsKey, json.encode(requestsJson));
//     return Future.value(unit);
//   }
//
//   @override
//   Future<List<CommentModel>> getCachedComments() {
//     final jsonString = sharedPreferences.getString(cachedCommentsKey);
//     if (jsonString != null) {
//       List decodedJsonData = json.decode(jsonString);
//       List<CommentModel> comments = decodedJsonData
//           .map<CommentModel>(
//               (jsonComment) => CommentModel.fromJson(jsonComment))
//           .toList();
//       return Future.value(comments);
//     } else {
//       throw EmptyCacheException();
//     }
//   }
// }
