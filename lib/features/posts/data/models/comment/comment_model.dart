import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../user/data/models/user_model.dart';

CommentModel commentFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentToJson(CommentModel data) => json.encode(data.toJson());

FormData commentToFormData(CommentModel data) => data.toFormData();

class CommentModel extends Equatable {
  CommentModel({
    this.id,
    this.body,
    this.isUpVoted,
    this.isDownVoted,
    this.totalUpVotes,
    this.totalDownVotes,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? body;
  bool? isUpVoted;
  bool? isDownVoted;
  int? totalUpVotes;
  int? totalDownVotes;
  UserModel? user;
  String? createdAt;
  String? updatedAt;

  @override
  List<Object?> get props => [
        id,
        body,
        isUpVoted,
        isDownVoted,
        totalUpVotes,
        totalDownVotes,
        user,
        createdAt,
        updatedAt
      ];

  CommentModel.fromJson(dynamic json) {
    id = json["id"];
    body = json['body'];
    isUpVoted = json['is_upvoted'];
    isDownVoted = json['is_downvoted'];
    totalUpVotes = json['total_upvotes'];
    totalDownVotes = json['total_downvotes'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  CommentModel fromJson(dynamic json) {
    return CommentModel.fromJson(json);
  }

  List<CommentModel> fromJsonList(dynamic data) {
    List<CommentModel> dataList = data
        .map<CommentModel>(
            (jsonPostModel) => CommentModel.fromJson(jsonPostModel))
        .toList();
    return dataList;
  }

  CommentModel copyWith({
    int? id,
    String? body,
    bool? isUpVoted,
    bool? isDownVoted,
    int? totalUpVotes,
    int? totalDownVotes,
    UserModel? user,
    String? createdAt,
    String? updatedAt,
  }) =>
      CommentModel(
        id: id ?? this.id,
        body: body ?? this.body,
        isUpVoted: isUpVoted ?? this.isUpVoted,
        isDownVoted: isDownVoted ?? this.isDownVoted,
        totalUpVotes: totalUpVotes ?? this.totalUpVotes,
        totalDownVotes: totalDownVotes ?? this.totalDownVotes,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['body'] = body;
    map['is_upvoted'] = isUpVoted;
    map['is_downvoted'] = isDownVoted;
    map['total_upvotes'] = totalUpVotes;
    map['total_downvotes'] = totalDownVotes;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

  FormData toFormData() => FormData.fromMap({
        ...toJson(),
      });

  factory CommentModel.init() {
    return CommentModel(
        body: "",
        id: 0,
        createdAt: "",
        updatedAt: "",
        isDownVoted: false,
        isUpVoted: false,
        totalDownVotes: 0,
        totalUpVotes: 0,
        user: UserModel.init());
  }
}
