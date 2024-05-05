import 'package:ebn_balady/core/app_theme.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:ebn_balady/features/champions/data/models/friend_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChampionContainerWidget extends StatefulWidget {
  const ChampionContainerWidget(
      {Key? key, required this.championData, required this.index})
      : super(key: key);
  final ChampionsModel championData;
  final int index;

  @override
  State<ChampionContainerWidget> createState() =>
      _ChampionContainerWidgetState();
}

class _ChampionContainerWidgetState extends State<ChampionContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "This feature is not completed yet",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      textColor: Theme.of(context).colorScheme.primary,
                      fontSize: 16.0);
                  // Get.to(() => ViewProfileScreen(user: Current.user));
                },
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage("${imagesPath}omar.jpg"),
                    ),
                    Positioned(
                        bottom: -4,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: widget.championData.rank == 1
                                  ? AppTheme.gold
                                  : widget.championData.rank == 2
                                      ? AppTheme.silver
                                      : widget.championData.rank == 3
                                          ? AppTheme.bronze
                                          : AppTheme.darkGrey,
                              shape: BoxShape.circle),
                          child: Text(
                            widget.championData.rank.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.white),
                          ),
                        )),
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
                    Text(widget.championData.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Text(
                            "الكريم",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                " 4.8",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Center(
                      child: Text(
                    "Albaida'a",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  )),
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
          ],
        ),
      ),
    );
  }
}
