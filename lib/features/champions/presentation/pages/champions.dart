import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/animated_search/animation_search_bar.dart';
import '../../data/models/friend_model.dart';
import '../widgets/champion_container.dart';

class ChampionsScreen extends StatefulWidget {
  const ChampionsScreen({Key? key}) : super(key: key);

  @override
  State<ChampionsScreen> createState() => _ChampionsScreenState();
}

class _ChampionsScreenState extends State<ChampionsScreen> {
  TextEditingController searchController = TextEditingController();
  List<ChampionsModel> championsList = [
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 1),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 2),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 3),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 4),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 5),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 6),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 7),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 8),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 9),
    ChampionsModel(
        name: 'Omar Taha Mohammed Alfaqeer', username: '@OmarTaha', rank: 10),
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
                title: AppLocalizations.of(Get.context!)!.champions,
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
                      return ChampionContainerWidget(
                        championData: championsList[index],
                        index: index,
                      );
                    },
                    childCount: championsList.length,
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
