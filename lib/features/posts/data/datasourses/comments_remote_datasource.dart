// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:ebn_balady/core/errors/exceptions.dart';
// import 'package:ebn_balady/injection_container.dart' as di;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../core/constants.dart';
// import '../../../../core/network/data_source_url.dart';
// import '../models/comment/comment_model.dart';
//
// String? token = di.sl.get<SharedPreferences>().getString(tokenKey);
//
// abstract class CommentsRemoteDataSource {
//   Future<List<CommentModel>> getComments(int postId, int pageNumber);
//
//   Future<Unit> deleteComment(int commentId, int postId);
//
//   Future<CommentModel> addComment(String comment, int postId);
//
//   Future<Unit> updateComment(CommentModel commentModel, int postId);
//
//   Future<CommentModel> addCommentLike(int commentId, int postId);
//
//   Future<CommentModel> removeCommentLike(int commentId, int postId);
//
//   Future<CommentModel> addCommentDislike(int commentId, int postId);
//
//   Future<CommentModel> removeCommentDislike(int commentId, int postId);
// }
//
// class CommentsRemoteDataSourceImplementationWithDio
//     implements CommentsRemoteDataSource {
//   final Dio dio;
//
//   @override
//   Future<List<CommentModel>> getComments(int postId, int pageNumber) async {
//     final response = await dio.get(
//         DataSourceURL.getCommentEndPoint(
//             postId: postId, pageNumber: pageNumber),
//         options: Options(headers: {
//           "Content-Type": "application/json",
//           'Accept': 'application/json',
//           "Authorization": "Bearer $token"
//         }));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       List decodedJsonData = map['data'];
//       List<CommentModel> comments = decodedJsonData
//           .map<CommentModel>(
//               (jsonRequestModel) => CommentModel.fromJson(jsonRequestModel))
//           .toList();
//       return Future.value(comments);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   CommentsRemoteDataSourceImplementationWithDio({required this.dio});
//
//   @override
//   Future<CommentModel> addComment(String comment, int postId) async {
//     final response =
//         await dio.post(DataSourceURL.getCommentEndPoint(postId: postId),
//             data: {"body": comment},
//             options: Options(headers: {
//               "Content-Type": "application/json",
//               'Accept': 'application/json',
//               "Authorization": "Bearer $token"
//             }));
//
//     if (response.statusCode == 201) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       CommentModel commentModel = CommentModel.fromJson(decodedJsonData);
//       return Future.value(commentModel);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<Unit> deleteComment(int commentId, int postId) async {
//     final response = await dio.delete(
//       DataSourceURL.getCommentEndPoint(commentId: commentId, postId: postId),
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
//   Future<Unit> updateComment(CommentModel commentModel, int postId) async {
//     final response = await dio.post(
//         "${DataSourceURL.getCommentEndPoint(commentId: commentModel.id, postId: postId)}?_method=PUT",
//         data: {"body": commentModel.body},
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
//   Future<CommentModel> addCommentLike(int commentId, int postId) async {
//     final response = await dio.post(
//       DataSourceURL.getCommentLikeEndPoint(
//           commentId: commentId, postId: postId),
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         "Authorization": "Bearer $token"
//       }),
//     );
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       CommentModel commentModel = CommentModel.fromJson(decodedJsonData);
//       return Future.value(commentModel);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<CommentModel> removeCommentLike(int commentId, int postId) async {
//     final response = await dio.delete(
//       DataSourceURL.getCommentLikeEndPoint(
//           commentId: commentId, postId: postId),
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         "Authorization": "Bearer $token"
//       }),
//     );
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       CommentModel commentModel = CommentModel.fromJson(decodedJsonData);
//       return Future.value(commentModel);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<CommentModel> addCommentDislike(int commentId, int postId) async {
//     final response = await dio.post(
//       DataSourceURL.getCommentDislikeEndPoint(
//           commentId: commentId, postId: postId),
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         "Authorization": "Bearer $token"
//       }),
//     );
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       CommentModel commentModel = CommentModel.fromJson(decodedJsonData);
//       return Future.value(commentModel);
//     } else {
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<CommentModel> removeCommentDislike(int commentId, int postId) async {
//     final response = await dio.delete(
//       DataSourceURL.getCommentLikeEndPoint(
//           commentId: commentId, postId: postId),
//       options: Options(headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         "Authorization": "Bearer $token"
//       }),
//     );
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = response.data;
//       final decodedJsonData = map['data'];
//       CommentModel commentModel = CommentModel.fromJson(decodedJsonData);
//       return Future.value(commentModel);
//     } else {
//       throw ServerException();
//     }
//   }
// }
