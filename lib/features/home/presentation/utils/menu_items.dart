import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../../core/constants.dart';
import '../utils/menu_item.dart';

class DrawerMenuItems {
  static initMenuItems() {
    requests.title = AppLocalizations.of(Get.context!)!.requests;
    myFriends.title = AppLocalizations.of(Get.context!)!.myFriends;
    champions.title = AppLocalizations.of(Get.context!)!.champions;
    aboutDeveloper.title = AppLocalizations.of(Get.context!)!.aboutDeveloper;
    aboutApp.title = AppLocalizations.of(Get.context!)!.aboutEbnBalady;
    settings.title = AppLocalizations.of(Get.context!)!.settings;
  }

  static DrawerMenuItem requests = DrawerMenuItem(
      title: AppLocalizations.of(Get.context!)!.requests, icon: Icons.home);
  static DrawerMenuItem myFriends = DrawerMenuItem(
      title: AppLocalizations.of(Get.context!)!.myFriends, icon: Icons.people);
  static DrawerMenuItem champions = DrawerMenuItem(
      title: AppLocalizations.of(Get.context!)!.champions,
      assetIcon: '${iconsPath}champ.svg');
  static DrawerMenuItem aboutDeveloper = DrawerMenuItem(
      title: AppLocalizations.of(Get.context!)!.aboutDeveloper,
      icon: Icons.alternate_email_rounded);
  static DrawerMenuItem aboutApp = DrawerMenuItem(
      title: AppLocalizations.of(Get.context!)!.aboutEbnBalady,
      assetIcon: '${iconsPath}logo_white.svg');
  static DrawerMenuItem settings = DrawerMenuItem(
      title: AppLocalizations.of(Get.context!)!.settings, icon: Icons.settings);
}
