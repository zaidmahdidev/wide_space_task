import 'package:ebn_balady/core/app_theme.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:ebn_balady/features/map/data/models/map_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MapContainerWidget extends StatefulWidget {
  const MapContainerWidget(
      {Key? key, required this.mapData, required this.index})
      : super(key: key);
  final MapModel mapData;
  final int index;

  @override
  State<MapContainerWidget> createState() => _MapContainerWidgetState();
}

class _MapContainerWidgetState extends State<MapContainerWidget> {
  bool isFriend = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
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
                        Text(widget.mapData.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                        Text(widget.mapData.distance,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
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
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      )),
                    )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    type: MaterialType.transparency,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isFriend = !isFriend;
                        });
                      },
                      child: isFriend
                          ? Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : Icon(
                              Icons.person_add,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    type: MaterialType.transparency,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.place,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
