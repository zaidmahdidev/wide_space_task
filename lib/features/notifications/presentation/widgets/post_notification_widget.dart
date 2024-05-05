import 'dart:math' as math;

import 'package:ebn_balady/features/notifications/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/cached_network_image.dart';
import 'notification_container.dart';

class PostNotificationWidget extends StatefulWidget {
  const PostNotificationWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final NotificationContainerWidget widget;

  @override
  State<PostNotificationWidget> createState() => _PostNotificationWidgetState();
}

class _PostNotificationWidgetState extends State<PostNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.widget.notificationData.hasBeenRead =
                !widget.widget.notificationData.hasBeenRead;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage("${imagesPath}omar.jpg"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            widget.widget.notificationData.type ==
                                    NotificationType.careForYourPost
                                ? Icons.favorite
                                : widget.widget.notificationData.type ==
                                        NotificationType.postOfAFriend
                                    ? Icons.newspaper
                                    : Icons.messenger,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Omar Taha",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: !widget.widget.notificationData
                                                .hasBeenRead
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                        height: 1),
                              ),
                              TextSpan(
                                text: widget.widget.notificationData.type ==
                                        NotificationType.careForYourPost
                                    ? AppLocalizations.of(context)!
                                        .interestedInYourPost
                                    : widget.widget.notificationData.type ==
                                            NotificationType.postOfAFriend
                                        ? AppLocalizations.of(context)!
                                            .hasCreatedNewPost
                                        : widget.widget.notificationData.type ==
                                                NotificationType
                                                    .responseOnPostYouCareFor
                                            ? AppLocalizations.of(context)!
                                                .hasRespondedToPostYouInterestedIn
                                            : AppLocalizations.of(context)!
                                                .hasRespondedToYourPost,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: !widget.widget.notificationData
                                                .hasBeenRead
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                        height: 1),
                              )
                            ],
                          ),
                        ),
                        Text(
                          "(${widget.widget.notificationData.post!.title.substring(0, math.min(16, widget.widget.notificationData.post!.title.length))}...)",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: !widget
                                          .widget.notificationData.hasBeenRead
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.5),
                                  fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.widget.notificationData.datetime,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: !widget
                                          .widget.notificationData.hasBeenRead
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.5),
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: cachedNetworkImage(
                      widget.widget.notificationData.post!.image,
                      height: 64,
                      width: 96,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
