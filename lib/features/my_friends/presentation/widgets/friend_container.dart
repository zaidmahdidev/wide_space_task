import 'package:ebn_balady/core/app_theme.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:ebn_balady/features/my_friends/data/models/friend_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FriendContainerWidget extends StatefulWidget {
  const FriendContainerWidget(
      {Key? key, required this.friendData, required this.index})
      : super(key: key);
  final FriendModel friendData;
  final int index;

  @override
  State<FriendContainerWidget> createState() => _FriendContainerWidgetState();
}

class _FriendContainerWidgetState extends State<FriendContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Get.to(
          //   () => ViewProfileScreen(user: Current.user),
          // );
          Fluttertoast.showToast(
              msg: "This feature is not completed yet",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              textColor: Theme.of(context).colorScheme.primary,
              fontSize: 16.0);
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
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
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.friendData.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                        Text(widget.friendData.username,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.message,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {},
                    )),
                Expanded(
                    flex: 1,
                    child: Material(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.place,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
