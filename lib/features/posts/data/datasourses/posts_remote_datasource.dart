// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:ebn_balady/core/errors/exceptions.dart';
// import 'package:ebn_balady/injection_container.dart' as di;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../core/constants.dart';
// import '../../../../core/network/data_source_url.dart';
// import '../models/post/Post.dart';
//
// String? token = di.sl.get<SharedPreferences>().getString(tokenKey);
//
// abstract class PostsRemoteDataSource {
//   Future<List<PostModel>> getPosts(int pageNumber);
//
//   Future<PostModel> getPost(int postId);
//
//   Future<Unit> deletePost(int postId);
//
//   Future<Unit> addPost(PostModel postModel);
//
//   Future<Unit> updatePost(PostModel postModel);
//
//   Future<PostModel> addLike(int postId);
//
//   Future<PostModel> removeLike(int postId);
// }
//
// class PostsRemoteDataSourceImplementationWithDio
//     implements PostsRemoteDataSource {
//   final Dio dio;
//
//   @override
//   Future<List<PostModel>> getPosts(int pageNumber) async {
//     final response =
//         await dio.get(DataSourceURL.getPostEndPoint(pageNumber: pageNumber),
//             options: Options(headers: {
//               "Content-Type": "application/json",
//               'Accept': 'application/json',
//               "Authorization": "Bearer $token"
//             }));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       List decodedJsonData = map['data'];
//       List<PostModel> posts = decodedJsonData
//           .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
//           .toList();
//       return Future.value(posts);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<PostModel> getPost(int postId) async {
//     final response =
//         await dio.get(DataSourceURL.getPostEndPoint(postId: postId),
//             options: Options(headers: {
//               "Content-Type": "application/json",
//               'Accept': 'application/json',
//               "Authorization": "Bearer $token"
//             }));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       PostModel post = PostModel.fromJson(decodedJsonData);
//       return Future.value(post);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   PostsRemoteDataSourceImplementationWithDio({required this.dio});
//
//   @override
//   Future<Unit> addPost(PostModel postModel) async {
//     final response = await dio.post(DataSourceURL.getPostEndPoint(),
//         data: postModel.toFormData(),
//         options: Options(headers: {
//           "Content-Type": "application/json",
//           'Accept': 'application/json',
//           "Authorization": "Bearer $token"
//         }));
//
//     if (response.statusCode == 201) {
//       return Future.value(unit);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<Unit> deletePost(int? postId) async {
//     final response = await dio.delete(
//       DataSourceURL.getPostEndPoint(postId: postId),
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         "Authorization": "Bearer $token"
//       }),
//     );
//     if (response.statusCode == 204) {
//       return Future.value(unit);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<Unit> updatePost(PostModel postModel) async {
//     final response = await dio.post(
//         "${DataSourceURL.getPostEndPoint(postId: postModel.id)}?_method=PUT",
//         data: postModel.toFormData(),
//         options: Options(headers: {
//           "Content-Type": "application/json",
//           'Accept': 'application/json',
//           "Authorization": "Bearer $token"
//         }));
//     if (response.statusCode == 200) {
//       return Future.value(unit);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<PostModel> addLike(int postId) async {
//     final response = await dio.post(
//       DataSourceURL.getPostLikeEndPoint(postId: postId),
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         "Authorization": "Bearer $token"
//       }),
//     );
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       PostModel postModel = PostModel.fromJson(decodedJsonData);
//       return Future.value(postModel);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<PostModel> removeLike(int postId) async {
//     final response = await dio.delete(
//       DataSourceURL.getPostLikeEndPoint(postId: postId),
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         "Authorization": "Bearer $token"
//       }),
//     );
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       PostModel postModel = PostModel.fromJson(decodedJsonData);
//       return Future.value(postModel);
//     } else {
//       throw ServerException();
//     }
//   }
// }
