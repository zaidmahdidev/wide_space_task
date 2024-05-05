import 'package:ebn_balady/core/app_theme.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/current_provider.dart';
import '../../../user/presentation/pages/profile/view_profile.dart';
import '../../data/models/message_model.dart';

class MessageContainerWidget extends StatefulWidget {
  const MessageContainerWidget(
      {Key? key, required this.messageData, required this.index})
      : super(key: key);
  final MessageModel messageData;
  final int index;

  @override
  State<MessageContainerWidget> createState() => _MessageContainerWidgetState();
}

class _MessageContainerWidgetState extends State<MessageContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Material(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => ViewProfileScreen(user: Current.user),
                  );
                },
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("${imagesPath}omar.jpg"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.circle_rounded,
                        color: Get.isDarkMode
                            ? AppTheme.darkSuccessColor
                            : AppTheme.successColor,
                        size: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.messageData.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                    Text(widget.messageData.message,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
