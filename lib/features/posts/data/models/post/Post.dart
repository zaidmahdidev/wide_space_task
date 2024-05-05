import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../user/data/models/user_model.dart';
import '../comment/comment_model.dart';

class PostModel extends Equatable {
  PostModel({
    this.id,
    required this.title,
    required this.body,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
    this.totalLikes,
    this.totalComments,
    this.recentlyComments,
    this.user,
  });

  int? id;
  late String title;
  late String body;
  dynamic image;
  String? createdAt;
  String? updatedAt;
  bool? isLiked;
  int? totalLikes;
  int? totalComments;
  List<CommentModel>? recentlyComments;
  UserModel? user;

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        image,
        createdAt,
        updatedAt,
        isLiked,
        totalLikes,
        totalComments,
        recentlyComments,
        user
      ];

  PostModel.fromJson(dynamic jsonData) {
    id = jsonData['id'];
    title = jsonData['title'];
    body = jsonData['body'];
    image = jsonData['image'];
    createdAt = jsonData['created_at'];
    updatedAt = jsonData['updated_at'];
    isLiked = jsonData['is_liked'];
    totalLikes = jsonData['total_likes'];
    totalComments = jsonData['total_comments'];
    user =
        jsonData['user'] != null ? UserModel.fromJson(jsonData['user']) : null;
    recentlyComments = jsonData["recently_comments"] == null
        ? null
        : jsonData["recently_comments"] == []
            ? []
            : List<CommentModel>.from(jsonData["recently_comments"].map((x) {
                print("x is $x");
                return CommentModel.fromJson(x);
              }));
  }

  PostModel fromJson(dynamic jsonData) {
    return PostModel.fromJson(jsonData);
  }

  List<PostModel> fromJsonList(dynamic data) {
    List<PostModel> dataList = data
        .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
        .toList();
    return dataList;
  }

  PostModel copyWith({
    int? id,
    required String title,
    required String body,
    dynamic image,
    String? createdAt,
    String? updatedAt,
    bool? isLiked,
    int? totalLikes,
    int? totalComments,
    List<CommentModel>? recentlyComments,
    UserModel? user,
  }) =>
      PostModel(
        id: id ?? this.id,
        title: title,
        body: body,
        image: image ?? this.image,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isLiked: isLiked ?? this.isLiked,
        totalLikes: totalLikes ?? this.totalLikes,
        totalComments: totalComments ?? this.totalComments,
        recentlyComments: recentlyComments ?? this.recentlyComments,
        user: user ?? this.user,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['image'] = image;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_liked'] = isLiked;
    map['total_likes'] = totalLikes;
    map['total_comments'] = totalComments;
    map['recently_comments'] = recentlyComments?.map((v) {
      return commentToJson(v as CommentModel);
    }).toList();
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

  FormData toFormData() => FormData.fromMap({
        ...toJson(),
        'image':
            image is File ? MultipartFile.fromFileSync(image?.path) : image,
      });

  factory PostModel.init() {
    return PostModel(
        id: 0,
        title: "",
        body: "",
        image: "",
        createdAt: "",
        updatedAt: "",
        isLiked: false,
        totalLikes: 0,
        totalComments: 0,
        recentlyComments: const [],
        user: UserModel.init());
  }
}
