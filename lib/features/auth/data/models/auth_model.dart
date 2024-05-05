// import 'package:dio/dio.dart';
// import 'package:equatable/equatable.dart';
//
// class AuthModel extends Equatable {
//   AuthModel({
//     this.firstName,
//     this.middleName,
//     this.lastName,
//     this.username,
//     this.password,
//     this.gender,
//     this.phones,
//     this.email,
//     this.neighborhood,
//     this.district,
//     this.city,
//     this.country,
//   });
//
//   String? username;
//   String? password;
//   String? firstName;
//   String? middleName;
//   String? lastName;
//   String? gender;
//   String? country;
//   String? city;
//   String? district;
//   String? neighborhood;
//   List<String>? phones;
//   String? email;
//
//   @override
//   List<Object?> get props => [
//         username,
//         firstName,
//         middleName,
//         lastName,
//         gender,
//         district,
//         neighborhood,
//         country,
//         city,
//         phones,
//         email,
//       ];
//
//   AuthModel.fromJson(dynamic json) {
//     username = json['username'];
//     password = json['password'];
//     firstName = json['first_name'];
//     middleName = json['middle_name'];
//     lastName = json['last_name'];
//     gender = json['gender'];
//     if (json['phones'] != null) {
//       phones = [];
//       json['phones'].forEach((v) {
//         phones?.add(v.toString());
//       });
//     }
//     email = json['email'];
//     district = json['district'];
//     city = json['city'];
//     country = json['country'];
//     neighborhood = json['neighborhood'];
//   }
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['username'] = username;
//     map['password'] = password;
//     map['first_name'] = firstName;
//     map['middle_name'] = middleName;
//     map['last_name'] = lastName;
//     map['gender'] = gender;
//     map['phones'] = phones;
//     map['email'] = email;
//     map['district'] = district;
//     map['city'] = city;
//     map['country'] = country;
//     map['neighborhood'] = neighborhood;
//     return map;
//   }
//
//   FormData toFormData() {
//     return FormData.fromMap({
//       ...toJson(),
//       "phones": phones.toString(),
//     });
//   }
// }
