import 'package:ebn_balady/features/notifications/data/models/notification_model.dart';
import 'package:ebn_balady/features/notifications/presentation/widgets/achievement_notification_widget.dart';
import 'package:ebn_balady/features/notifications/presentation/widgets/post_notification_widget.dart';
import 'package:ebn_balady/features/notifications/presentation/widgets/review_notification_widget.dart';
import 'package:flutter/material.dart';

import 'friend_request_widget.dart';

class NotificationContainerWidget extends StatefulWidget {
  const NotificationContainerWidget(
      {Key? key, required this.notificationData, required this.index})
      : super(key: key);
  final NotificationModel notificationData;
  final int index;

  @override
  State<NotificationContainerWidget> createState() =>
      _NotificationContainerWidgetState();
}

class _NotificationContainerWidgetState
    extends State<NotificationContainerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.notificationData.type == NotificationType.postOfAFriend ||
        widget.notificationData.type == NotificationType.postResponse ||
        widget.notificationData.type ==
            NotificationType.responseOnPostYouCareFor ||
        widget.notificationData.type == NotificationType.careForYourPost) {
      return PostNotificationWidget(widget: widget);
    } else if (widget.notificationData.type ==
            NotificationType.rankAchievement ||
        widget.notificationData.type == NotificationType.increaseInLevel) {
      return AchievementNotificationWidget(widget: widget);
    } else if (widget.notificationData.type ==
        NotificationType.reviewYourAccount) {
      return ReviewNotificationWidget(widget: widget);
    } else {
      return FriendRequestWidget(widget: widget);
    }
  }
}
