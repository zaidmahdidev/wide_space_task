import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebn_balady/features/user/presentation/manager/user_bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../injection_container.dart';
import '../utils/menu_item.dart';
import '../utils/menu_items.dart';

class DrawMenu extends StatelessWidget {
  final DrawerMenuItem currentItem;
  final ValueChanged<DrawerMenuItem> onSelectedItem;

  const DrawMenu(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  final Color drawerColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<DrawerMenuItem> items = <DrawerMenuItem>[
      DrawerMenuItems.requests,
      DrawerMenuItems.myFriends,
      DrawerMenuItems.champions,
      DrawerMenuItems.aboutDeveloper,
      DrawerMenuItems.aboutApp,
      DrawerMenuItems.settings,
    ];

    return BlocProvider.value(
      value: BlocProvider.of<UserBloc>(context),
      child: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
        if (kDebugMode) {
          log("state in drawer is $state");
        }
        if (state is UserError) {
          showFlushBar(
            state.message,
            context: context,
          );
        }
      }, builder: (context, state) {
        return Scaffold(
          backgroundColor: drawerColor,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: -180,
                  left: Get.locale != const Locale('ar', 'YE') ? -40 : null,
                  right: Get.locale == const Locale('ar', 'YE') ? -40 : null,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scaleX: Get.locale == const Locale('ar', 'YE') ? -1 : 1,
                    child: SvgPicture.asset(
                      "${iconsPath}main_shape.svg",
                      width: 250,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: -180,
                  left: Get.locale != const Locale('ar', 'YE') ? -40 : null,
                  right: Get.locale == const Locale('ar', 'YE') ? -40 : null,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scaleX: Get.locale == const Locale('ar', 'YE') ? -1 : 1,
                    child: SvgPicture.asset(
                      "${iconsPath}main_shape.svg",
                      height: 400,
                      width: 400,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 40.0,
                        left: Get.locale != const Locale('ar', 'YE') ? 16 : 0,
                        right: Get.locale == const Locale('ar', 'YE') ? 16 : 0,
                      ),
                      child: Column(
                        children: [
                          if (state is UserLoaded || state is LoginLoaded)
                            ProfileImage(state: state),
                          if (state is UserLoaded || state is LoginLoaded)
                            ProfileName(state: state),
                          if (state is UserLoaded || state is LoginLoaded)
                            ProfileUsername(state: state),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.16,
                    ),
                    ...items.map(buildMenuItem).toList(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Dialogs.bottomMaterialDialog(
                              color: Theme.of(context).colorScheme.surface,
                              context: context,
                              customView: Column(
                                children: [
                                  Icon(
                                    Icons.drag_handle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.4),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.isLogout,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.sureToLogout,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                ],
                              ),
                              onClose: (value) =>
                                  print("returned value is '$value'"),
                              actions: [
                                IconsOutlineButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: AppLocalizations.of(context)!.cancel,
                                  iconData: Icons.cancel_outlined,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                  iconColor:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                IconsButton(
                                  onPressed: () async {
                                    await logout(
                                        redirect: true, clearCache: false);
                                    Navigator.of(context).pop();
                                  },
                                  text: AppLocalizations.of(context)!.logout,
                                  iconData: Icons.logout,
                                  color: Theme.of(context).colorScheme.error,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                              ]);
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.logout,
                          style: AppTheme.textTheme.bodyMedium!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            launchURL(sl<FirebaseRemoteConfig>()
                                .getString('supportLink'));
                          },
                          icon: const Icon(
                            Icons.help,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              shareApp(context);
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildMenuItem(DrawerMenuItem item) => ListTileTheme(
        selectedColor: Colors.white,
        child: ListTile(
          selectedTileColor: Colors.white12,
          selected: currentItem == item,
          minLeadingWidth: 16,
          leading: item.icon != null
              ? Icon(
                  item.icon,
                  color: Colors.white,
                  size: 20,
                )
              : SvgPicture.asset(
                  item.assetIcon ?? "",
                  width: 20,
                  color: Colors.white,
                ),
          title: Text(
            item.title,
            style: AppTheme.textTheme.bodyMedium,
          ),
          onTap: () => onSelectedItem(item),
        ),
      );
}

class ProfileUsername extends StatelessWidget {
  const ProfileUsername({Key? key, required this.state}) : super(key: key);
  final state;

  @override
  Widget build(BuildContext context) {
    return Text(
      state.user.username ?? "",
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Colors.white70),
    );
  }
}

class ProfileName extends StatelessWidget {
  ProfileName({Key? key, required this.state}) : super(key: key);
  final state;

  @override
  Widget build(BuildContext context) {
    return Text(
      state.user.displayName,
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
    );
  }
}

class ProfileImage extends StatelessWidget {
  ProfileImage({Key? key, required this.state}) : super(key: key);
  final state;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: state.user.avatar ?? "",
      errorWidget: (context, url, error) => Icon(
        Icons.account_circle,
        size: 120,
        color: Theme.of(context).colorScheme.primary,
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
