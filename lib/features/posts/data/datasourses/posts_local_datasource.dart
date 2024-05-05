// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:dartz/dartz.dart';
// import 'package:ebn_balady/core/errors/exceptions.dart';
// import 'package:ebn_balady/features/posts/data/models/post/Post.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../core/constants.dart';
//
// abstract class PostsLocalDataSource {
//   Future<List<PostModel>> getCachedPosts();
//
//   Future<Unit> cachePosts(List<PostModel> posts);
// }
//
// class PostsLocalDataSourceImplementationWithSharedPreferences
//     implements PostsLocalDataSource {
//   final SharedPreferences sharedPreferences;
//
//   PostsLocalDataSourceImplementationWithSharedPreferences(
//       {required this.sharedPreferences});
//
//   @override
//   Future<Unit> cachePosts(List<PostModel> posts) async {
//     log("insise");
//     List requestsJson =
//         posts.map<Map<String, dynamic>>((request) => request.toJson()).toList();
//     log("insise");
//     log("requestsJson $requestsJson");
//     log("requestsJson json${json.encode(requestsJson).runtimeType}");
//     await sharedPreferences.setString(
//         cachedPostsKey, json.encode(requestsJson));
//     log("requestsJson $requestsJson");
//     return Future.value(unit);
//   }
//
//   @override
//   Future<List<PostModel>> getCachedPosts() {
//     final jsonString = sharedPreferences.getString(cachedPostsKey);
//     if (jsonString != null) {
//       List decodedJsonData = json.decode(jsonString);
//       List<PostModel> posts = decodedJsonData.map<PostModel>((jsonPost) {
//         print("***********************************");
//         log("json post is $jsonPost");
//         print("***********************************");
//         return PostModel.fromJson(jsonPost);
//       }).toList();
//       return Future.value(posts);
//     } else {
//       throw EmptyCacheException();
//     }
//   }
// }
