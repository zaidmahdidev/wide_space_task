import 'package:ebn_balady/features/home/presentation/pages/about_app.dart';
import 'package:ebn_balady/features/home/presentation/pages/about_developer.dart';
import 'package:ebn_balady/features/home/presentation/pages/home_screen.dart';
import 'package:ebn_balady/features/home/presentation/pages/settings.dart';
import 'package:ebn_balady/features/my_friends/presentation/pages/my_friends.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../champions/presentation/pages/champions.dart';
import '../../../map/presentation/states manager/map_bloc.dart';
import '../utils/menu_item.dart';
import '../utils/menu_items.dart';
import 'drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static late AnimationController animationController;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final _drawerController = ZoomDrawerController();
  DrawerMenuItem currentItem = DrawerMenuItems.requests;
  int selectedIndex = 0;
  bool isPlaying = false;
  IconData floatingIcon = Icons.add;

  @override
  void initState() {
    MainScreen.animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();
  }

  @override
  void dispose() {
    MainScreen.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: BlocProvider.of<MapBloc>(context),
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (_drawerController.isOpen!()) {
                _drawerController.close!();
              } else {
                if (currentItem == DrawerMenuItems.requests) {
                  if (selectedIndex == 0) {
                    Dialogs.bottomMaterialDialog(
                        msg: AppLocalizations.of(Get.context!)!
                            .sureYouWantToQuit,
                        msgStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                        title: AppLocalizations.of(Get.context!)!.isQuit,
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                        color: Theme.of(context).colorScheme.surface,
                        context: context,
                        customView: Icon(
                          Icons.drag_handle,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4),
                        ),
                        onClose: (value) => print("returned value is '$value'"),
                        actions: [
                          IconsOutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            text: AppLocalizations.of(Get.context!)!.cancel,
                            iconData: Icons.cancel_outlined,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                            iconColor: Theme.of(context).colorScheme.onSurface,
                          ),
                          IconsButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            text: AppLocalizations.of(Get.context!)!.quit,
                            iconData: Icons.logout,
                            color: Theme.of(context).colorScheme.error,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ]);
                  }
                  if (selectedIndex == 3 && state is MapView) {
                    BlocProvider.of<MapBloc>(context).add(const ToListView());
                  } else {
                    setState(() {
                      selectedIndex = 0;
                      isPlaying = false;
                      floatingIcon = Icons.add;
                      MainScreen.animationController.reverse();
                    });
                  }
                } else {
                  _drawerController.open!();
                }
              }
              return false;
            },
            child: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
              return ZoomDrawer(
                disableDragGesture: state is MapView,
                mainScreen: getScreen(),
                menuScreen: Builder(builder: (context) {
                  return DrawMenu(
                    currentItem: currentItem,
                    onSelectedItem: (item) {
                      setState(() {
                        currentItem = item;
                      });
                      ZoomDrawer.of(context)!.close();
                    },
                  );
                }),
                controller: _drawerController,
                duration: const Duration(milliseconds: 400),
                style: DrawerStyle.defaultStyle,
                androidCloseOnBackTap: true,
                mainScreenTapClose: true,
                isRtl: Localizations.localeOf(context) == const Locale('ar'),
                moveMenuScreen: true,
                borderRadius: 32,
                slideWidth: size.width * 0.8,
                showShadow: true,
                angle: -10.0,
                drawerShadowsBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
              );
            }),
          );
        },
      ),
    );
  }

  Widget getScreen() {
    if (currentItem == DrawerMenuItems.requests) {
      return HomeScreen(
        isPlaying: isPlaying,
        selectedIndex: selectedIndex,
        floatingIcon: floatingIcon,
        onSelectedIndex: (value) {
          selectedIndex = value;
        },
      );
    } else if (currentItem == DrawerMenuItems.myFriends) {
      return const MyFriendsScreen();
    } else if (currentItem == DrawerMenuItems.champions) {
      return const ChampionsScreen();
    } else if (currentItem == DrawerMenuItems.aboutApp) {
      return const AboutApp();
    } else if (currentItem == DrawerMenuItems.aboutDeveloper) {
      return const AboutDeveloper();
    } else {
      return FeatureDiscovery(child: const SettingsScreen());
    }
  }
}
