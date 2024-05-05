import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants.dart';
import '../../data/models/notification_model.dart';
import 'notification_container.dart';

class AchievementNotificationWidget extends StatefulWidget {
  const AchievementNotificationWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final NotificationContainerWidget widget;

  @override
  State<AchievementNotificationWidget> createState() =>
      _AchievementNotificationWidgetState();
}

class _AchievementNotificationWidgetState
    extends State<AchievementNotificationWidget> {
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
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.celebration_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20,
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
                                text: AppLocalizations.of(context)!
                                    .congratulations,
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
                                        NotificationType.increaseInLevel
                                    ? AppLocalizations.of(context)!.youLeveledUp
                                    : AppLocalizations.of(context)!
                                        .youGotNewAchievement,
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
                              ),
                              TextSpan(
                                text: widget.widget.notificationData.type ==
                                        NotificationType.increaseInLevel
                                    ? " ${widget.widget.notificationData.level.toString()}"
                                    : " ${AppLocalizations.of(context)!.theTop} ${widget.widget.notificationData.rank!['City'].toString()} ${AppLocalizations.of(context)!.inTheCity}",
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
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.widget.notificationData.datetime,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: !widget.widget.notificationData
                                              .hasBeenRead
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                      fontWeight: FontWeight.bold),
                            ),
                            if (!widget.widget.notificationData.hasBeenRead)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              )
                          ],
                        ),
                      ],
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
