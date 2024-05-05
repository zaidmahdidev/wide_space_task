import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/animated_search/animation_search_bar.dart';
import '../../data/models/friend_model.dart';
import '../widgets/friend_container.dart';

class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({Key? key}) : super(key: key);

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {
  TextEditingController searchController = TextEditingController();
  List<FriendModel> friendsList = [
    FriendModel(name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha'),
    FriendModel(name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha'),
    FriendModel(name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha'),
    FriendModel(name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha'),
    FriendModel(name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha'),
    FriendModel(name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            leading: IconButton(
              onPressed: () => openMenu(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            snap: true,
            floating: true,
            actions: [
              AnimationSearchBar(
                horizontalPadding: 24,
                onChanged: (text) => debugPrint(text),
                searchTextEditingController: searchController,
                title: AppLocalizations.of(Get.context!)!.myFriends,
              ),
            ],
          ),
        ],
        body: CupertinoScrollbar(
          thumbVisibility: true,
          thicknessWhileDragging: 8,
          thickness: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return FriendContainerWidget(
                        friendData: friendsList[index],
                        index: index,
                      );
                    },
                    childCount: friendsList.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openMenu() {
    ZoomDrawer.of(context)!.toggle();
  }
}
