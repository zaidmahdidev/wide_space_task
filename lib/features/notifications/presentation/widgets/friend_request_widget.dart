import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/constants.dart';
import 'notification_container.dart';

class FriendRequestWidget extends StatefulWidget {
  const FriendRequestWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final NotificationContainerWidget widget;

  @override
  State<FriendRequestWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
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
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 24,
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
                                text: AppLocalizations.of(context)!
                                    .sentYouFriendRequest,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Get.isDarkMode
                          ? AppTheme.darkSuccessColor
                          : AppTheme.successColor),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.accept,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.error),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.reject,
                      style: Theme.of(context).textTheme.bodySmall,
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
