import 'package:ebn_balady/features/posts/data/models/post/Post.dart';
import 'package:ebn_balady/features/user/data/models/review_model.dart';

import '../../../user/data/models/user_model.dart';

enum NotificationType {
  friendShipRequest,
  rankAchievement,
  increaseInLevel,
  postResponse,
  postOfAFriend,
  reviewYourAccount,
  responseOnPostYouCareFor,
  careForYourPost,
}

class NotificationModel {
  NotificationType type;
  int? level;
  bool hasBeenRead;
  ReviewModel? review;
  Map<String, int>? rank;
  String datetime;
  UserModel? user;
  PostModel? post;

  NotificationModel({
    required this.type,
    required this.hasBeenRead,
    this.level,
    this.review,
    required this.datetime,
    this.user,
    this.post,
    this.rank,
  });
}
