// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:equatable/equatable.dart';
//
// import '../models/statictics_model.dart';
//
// class UserModel extends Equatable {
//   UserModel({
//     this.id,
//     this.avatar,
//     this.username,
//     this.token,
//     this.firstName,
//     this.middleName,
//     this.lastName,
//     this.gender,
//     this.totalFriends,
//     this.neighborhood,
//     this.district,
//     this.city,
//     this.country,
//     this.phones,
//     this.email,
//     this.emailVerifiedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.totalPosts,
//     this.totalComments,
//     this.totalReviews,
//     this.statistics,
//   });
//
//   int? id;
//   dynamic avatar;
//   String? username;
//   String? token;
//   String? firstName;
//   String? middleName;
//   String? lastName;
//   String? gender;
//   int? totalFriends;
//   String? country;
//   String? city;
//   String? district;
//   String? neighborhood;
//   List<String>? phones;
//   String? email;
//   String? emailVerifiedAt;
//   String? createdAt;
//   String? updatedAt;
//   int? totalPosts;
//   int? totalComments;
//   int? totalReviews;
//   StatisticsModel? statistics;
//
//   @override
//   List<Object?> get props => [
//         id,
//         avatar,
//         username,
//         token,
//         firstName,
//         middleName,
//         lastName,
//         gender,
//         district,
//         neighborhood,
//         country,
//         city,
//         totalFriends,
//         phones,
//         email,
//         emailVerifiedAt,
//         createdAt,
//         updatedAt,
//         totalPosts,
//         totalComments,
//         totalReviews,
//         statistics
//       ];
//
//   UserModel.fromJson(dynamic json) {
//     id = json['id'];
//     avatar = json['avatar'];
//     username = json['username'];
//     token = json['token'];
//     firstName = json['first_name'];
//     middleName = json['middle_name'];
//     lastName = json['last_name'];
//     gender = json['gender'];
//     if (json['phones'] != null) {
//       phones = [];
//       print(
//           "phones in user model are ${json['phones']} and its type is ${json['phones'].runtimeType}");
//       json['phones'].forEach((v) {
//         phones?.add(v.toString());
//       });
//     }
//     email = json['email'];
//     district = json['district'];
//     totalFriends = json['totalFriends'];
//     city = json['city'];
//     country = json['country'];
//     neighborhood = json['neighborhood'];
//     emailVerifiedAt = json['email_verified_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     totalPosts = json['total_posts'];
//     totalComments = json['total_comments'];
//     totalReviews = json['total_reviews'];
//     statistics = json['statictics'] != null
//         ? StatisticsModel.fromJson(json['statictics'])
//         : null;
//   }
//   UserModel fromJson(dynamic json) {
//     return UserModel.fromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['avatar'] = avatar;
//     map['username'] = username;
//     map['token'] = token;
//     map['first_name'] = firstName;
//     map['middle_name'] = middleName;
//     map['last_name'] = lastName;
//     map['gender'] = gender;
//     map['phones'] = phones;
//     map['email'] = email;
//     map['totalFriends'] = totalFriends;
//     map['district'] = district;
//     map['city'] = city;
//     map['country'] = country;
//     map['neighborhood'] = neighborhood;
//     map['email_verified_at'] = emailVerifiedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['total_posts'] = totalPosts;
//     map['total_comments'] = totalComments;
//     map['total_reviews'] = totalReviews;
//     if (statistics != null) {
//       map['statictics'] = statistics?.toJson();
//     }
//     return map;
//   }
//
//   FormData toFormData() {
//     return FormData.fromMap({
//       ...toJson(),
//       "phones": phones.toString(),
//       'avatar':
//           avatar is File ? MultipartFile.fromFileSync(avatar?.path) : avatar,
//     });
//   }
//
//   factory UserModel.init() {
//     return UserModel(
//       id: 0,
//       avatar: "",
//       username: "",
//       token: "",
//       firstName: "",
//       middleName: "",
//       lastName: "",
//       gender: "Male",
//       totalFriends: 0,
//       neighborhood: "",
//       district: "",
//       city: "",
//       country: "",
//       phones: [],
//       email: "",
//       emailVerifiedAt: "",
//       createdAt: "",
//       updatedAt: "",
//       totalPosts: 0,
//       totalComments: 0,
//       totalReviews: 0,
//       statistics: StatisticsModel.init(),
//     );
//   }
// }
