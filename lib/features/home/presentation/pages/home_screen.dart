import 'package:ebn_balady/features/home/presentation/pages/main_screen.dart';
import 'package:ebn_balady/features/user/presentation/manager/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../../../core/models/current_provider.dart';
import '../../../../core/widgets/animated_search/animation_search_bar.dart';
import '../../../chat/pages/conversation/index.dart';
import '../../../map/presentation/pages/map.dart';
import '../../../map/presentation/states manager/map_bloc.dart';
import '../../../messages/presentation/pages/messages.dart';
import '../../../notifications/presentation/pages/notification.dart';
import '../../../posts/presentation/pages/add_or_update_post_page.dart';
import '../../../posts/presentation/pages/posts.dart';
import '../../../posts/presentation/states manager/posts_bloc/posts_bloc.dart';
import '../../../user/presentation/pages/profile/edit_profile.dart';
import '../../../user/presentation/pages/profile/view_profile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
    required this.onSelectedIndex,
    required this.selectedIndex,
    required this.isPlaying,
    required this.floatingIcon,
  }) : super(key: key);
  late String title;
  final ValueChanged<int> onSelectedIndex;
  int selectedIndex;
  bool isPlaying;
  IconData floatingIcon;
  static bool isAppBarHidden = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  dynamic failureOrUser;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTitle();
    getIcon();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screens = [
      const PostsScreen(),
      const MessagesScreen(),
      const SizedBox(),
      const MapScreen(),
      ViewProfileScreen(other: false, user: Current.user)
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<PostsBloc>(context),
        ),
        BlocProvider.value(
          value: BlocProvider.of<UserBloc>(context),
        ),
        BlocProvider.value(
          value: BlocProvider.of<MapBloc>(context),
        ),
      ],
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return Scaffold(
            appBar: state is MapListView
                ? AppBar(
                    title: widget.selectedIndex == 4 ? Text(getTitle()) : null,
                    leading: IconButton(
                      onPressed: () => toggle(),
                      icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_arrow,
                          progress: MainScreen.animationController),
                    ),
                    actions: [
                      if (widget.selectedIndex != 4)
                        AnimationSearchBar(
                            onChanged: (text) => setState(() {}),
                            searchTextEditingController: searchController,
                            title: getTitle(),
                            searchBarWidth:
                                MediaQuery.of(context).size.width - 96),
                      IconButton(
                          onPressed: () {
                            Get.to(() => const NotificationsScreen());
                          },
                          icon: const Icon(Icons.notifications)),
                    ],
                  )
                : null,
            body: Stack(
              children: [
                SizedBox(
                  child: IndexedStack(
                    index: widget.selectedIndex,
                    children: screens,
                  ),
                ),
                // NestedScrollView(
                //   // controller: PostsScreen.scrollController,
                //   physics: const AlwaysScrollableScrollPhysics(),
                //   floatHeaderSlivers: true,
                //   headerSliverBuilder: (context, innerBoxIsScrolled) => [
                //     SliverAppBar(
                //       leading: IconButton(
                //         onPressed: () => toggle(),
                //         icon: AnimatedIcon(
                //             icon: AnimatedIcons.menu_arrow,
                //             progress: MainScreen.animationController),
                //       ),
                //       backgroundColor: Colors.transparent,
                //       elevation: 0,
                //       snap: true,
                //       title: Text(getTitle()),
                //       floating: true,
                //       centerTitle: false,
                //       actions: widget.selectedIndex == 0
                //           ? [
                //               IconButton(
                //                   onPressed: () {
                //                     Get.to(() => const NotificationsScreen());
                //                   },
                //                   icon: const Icon(Icons.notifications)),
                //             ]
                //           : null,
                //     ),
                //   ],
                //   body: SizedBox(
                //     child: IndexedStack(
                //       index: widget.selectedIndex,
                //       children: screens,
                //     ),
                //   ),
                // ),
                if (state is MapListView)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: size.width,
                      height: 80,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size(size.width, 80),
                            painter: BottomNavigationCustomPainter(
                                color: Theme.of(context).colorScheme.surface),
                          ),
                          SizedBox(
                            width: size.width,
                            height: 80,
                            child: NavigationBarTheme(
                              data: NavigationBarThemeData(
                                indicatorColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                indicatorShape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                              ),
                              child: NavigationBar(
                                height: 80,
                                labelBehavior:
                                    NavigationDestinationLabelBehavior
                                        .onlyShowSelected,
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                selectedIndex: widget.selectedIndex,
                                onDestinationSelected: (selectedIndex) {
                                  AnimationSearchBar.focusNode.unfocus();
                                  AnimationSearchBar.controller.isSearching =
                                      false;
                                  widget.selectedIndex = selectedIndex;
                                  widget.onSelectedIndex(selectedIndex);
                                  setState(() {
                                    widget.isPlaying = widget.selectedIndex == 0
                                        ? false
                                        : true;
                                    _handleOnPressed(widget.isPlaying);
                                    getIcon();
                                    getTitle();
                                  });
                                },
                                backgroundColor: Colors.transparent,
                                destinations: [
                                  NavigationDestination(
                                    icon: Icon(
                                      Icons.home,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    ),
                                    selectedIcon: Icon(
                                      Icons.home,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    label: '',
                                  ),
                                  NavigationDestination(
                                    icon: Icon(
                                      Icons.message,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    ),
                                    selectedIcon: Icon(
                                      Icons.message,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    label: '',
                                  ),
                                  const Icon(
                                    Icons.add,
                                    color: Colors.transparent,
                                  ),
                                  NavigationDestination(
                                    icon: Icon(
                                      Icons.map,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    ),
                                    selectedIcon: Icon(
                                      Icons.map,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    label: '',
                                  ),
                                  NavigationDestination(
                                    icon: Icon(
                                      Icons.person,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    ),
                                    selectedIcon: Icon(
                                      Icons.person,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    label: '',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            heightFactor: 0.3,
                            child: FloatingActionButton(
                              heroTag: 'button',
                              onPressed: () async {
                                if (widget.selectedIndex == 0) {
                                  Get.to(() => const AddOrUpdatePostPage());
                                } else if (widget.selectedIndex == 1) {
                                  Navigator.of(context)
                                      .pushNamed(ConversationIndex.routeName);
                                } else if (widget.selectedIndex == 4) {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(SwitchToEditProfile());
                                  Get.to(() => const EditProfileScreen());
                                }
                              },
                              child: Icon(getIcon(),
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // GestureDetector(onTap: toggle, child: const CustomAppBar()),
              ],
            ),
          );
        },
      ),
    );
  }

  void toggle() {
    if (!widget.isPlaying) {
      ZoomDrawer.of(context)!.toggle();
    } else {
      setState(() {
        widget.selectedIndex = 0;
        widget.onSelectedIndex(widget.selectedIndex);
        _handleOnPressed(false);
      });
    }
  }

  void _handleOnPressed(isPlaying) {
    widget.isPlaying = isPlaying;
    if (widget.isPlaying) {
      MainScreen.animationController.forward();
    } else {
      widget.floatingIcon = Icons.add;
      MainScreen.animationController.reverse();
    }
  }

  String getTitle() {
    print("selected index in getTitle is ${widget.selectedIndex}");
    return widget.title = widget.selectedIndex == 0
        ? AppLocalizations.of(Get.context!)!.requests
        : widget.selectedIndex == 1
            ? AppLocalizations.of(Get.context!)!.messages
            : widget.selectedIndex == 3
                ? AppLocalizations.of(Get.context!)!.map
                : AppLocalizations.of(Get.context!)!.profile;
  }

  IconData getIcon() {
    return widget.floatingIcon = widget.selectedIndex == 0
        ? Icons.add
        : widget.selectedIndex == 1
            ? Icons.send_rounded
            : widget.selectedIndex == 3
                ? Icons.place
                : Icons.edit;
  }
}

class BottomNavigationCustomPainter extends CustomPainter {
  BottomNavigationCustomPainter({required this.color});

  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 0);

    path.quadraticBezierTo(size.width * 0.20, 10, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 5);
    path.arcToPoint(Offset(size.width * 0.60, 5),
        radius: const Radius.circular(10), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 10, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomAppBar extends StatefulWidget {
  String title;

  CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(
            Icons.menu_rounded,
            size: 32,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
