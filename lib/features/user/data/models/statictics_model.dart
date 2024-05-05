import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class StatisticsModel extends Equatable {
  StatisticsModel({
    this.level,
    this.progress,
    this.nickname,
    this.achievements,
    this.rating,
  });

  int? level;
  double? progress;
  String? nickname;
  List<int>? achievements;
  double? rating;

  @override
  List<Object?> get props => [level, progress, nickname, achievements, rating];

  StatisticsModel.fromJson(dynamic json) {
    level = json['level'];
    rating = json['rating'];
    progress = json['progress'];
    nickname = json['neckname'];
    achievements = [];
    if (json['achivments'] != null) {
      json['achivments'].forEach((v) {
        achievements!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['level'] = level;
    map['progress'] = progress;
    map['neckname'] = nickname;
    if (achievements != null) {
      map['achivments'] = achievements!.map((v) => v).toList();
    }
    map['rating'] = rating;
    return map;
  }

  FormData toFormData() => FormData.fromMap({
        ...toJson(),
      });

  factory StatisticsModel.init() {
    return StatisticsModel(
      level: 0,
      progress: 0.0,
      nickname: "",
      achievements: const [0],
      rating: 0.0,
    );
  }
}
