import 'dart:math' as math;

import 'package:ebn_balady/features/notifications/presentation/states%20manager/notification_bloc.dart';
import 'package:ebn_balady/features/posts/data/models/post/Post.dart';
import 'package:ebn_balady/features/user/data/models/review_model.dart';
import 'package:ebn_balady/features/user/data/models/statictics_model.dart';
import 'package:ebn_balady/features/user/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/current_provider.dart';
import '../../../../injection_container.dart';
import '../../../posts/data/models/data_temp/choice_chips.dart';
import '../../data/models/notification_model.dart';
import '../widgets/notification_container.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  TextEditingController searchController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd. HH:mm');
  late List<NotificationModel> notificationsList;
  final double spacing = 8;
  final PostModel testPost = PostModel(
      title: "خطر يرجى الحذر",
      body: "من يصادف هذا المخلوق عليه الفرار بجلده 🤣🤣",
      image:
          "https://ebnbalady.widespace.tech/storage/posts/32/faMlAI6EtPk6299kiFONW7k5jPSyHyslZW766PUh.jpg",
      user: UserModel(
        id: 1,
        avatar:
            "https://ebnbalady.widespace.tech/storage/users/1/bUdit7w2q7sc5paV8s4ZIkP5TjAP18L6hOTqrDnK.jpg",
        username: "@OmarTaha",
        firstName: "Omar",
        middleName: "Taha",
        lastName: "Alfaqeer",
        gender: "Male",
        phones: const ["733630142"],
        email: "a.777118407@gmail.com",
        emailVerifiedAt: null,
        createdAt: "2022-09-19T11:04:06.000000Z",
        updatedAt: "2022-10-26T09:10:40.000000Z",
        totalPosts: 22,
        totalComments: 49,
        totalReviews: 0,
        statistics: StatisticsModel(
            progress: 0.5, nickname: "Foo", achievements: [], level: 1),
      ));

  bool isAll = true;

  @override
  void initState() {
    notificationsList = [
      NotificationModel(
        type: NotificationType.careForYourPost,
        hasBeenRead: false,
        user: Current.user,
        post: testPost,
        datetime: formatter.format(DateTime.now()).toString(),
      ),
      NotificationModel(
        type: NotificationType.postOfAFriend,
        hasBeenRead: false,
        post: testPost,
        user: Current.user,
        datetime: formatter.format(DateTime.now()).toString(),
      ),
      NotificationModel(
        type: NotificationType.friendShipRequest,
        hasBeenRead: false,
        user: Current.user,
        datetime: formatter.format(DateTime.now()).toString(),
      ),
      NotificationModel(
        type: NotificationType.postResponse,
        hasBeenRead: false,
        post: testPost,
        datetime: formatter.format(DateTime.now()).toString(),
      ),
      NotificationModel(
        type: NotificationType.increaseInLevel,
        hasBeenRead: false,
        level: 4,
        datetime: formatter.format(DateTime.now()).toString(),
      ),
      NotificationModel(
        type: NotificationType.rankAchievement,
        hasBeenRead: false,
        rank: <String, int>{"World": 24, "Country": 5, "City": 1},
        datetime: formatter.format(DateTime.now()).toString(),
      ),
      NotificationModel(
        type: NotificationType.responseOnPostYouCareFor,
        hasBeenRead: false,
        post: testPost,
        datetime: formatter.format(DateTime.now()).toString(),
      ),
      NotificationModel(
        type: NotificationType.reviewYourAccount,
        hasBeenRead: false,
        review: ReviewModel(user: Current.user, rate: 3.5),
        datetime: formatter.format(DateTime.now()).toString(),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<NotificationBloc>(),
      child: Scaffold(
        body: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              snap: true,
              title: Text(AppLocalizations.of(Get.context!)!.notifications),
              floating: true,
              centerTitle: false,
            ),
          ],
          body: CupertinoScrollbar(
            thumbVisibility: true,
            thicknessWhileDragging: 8,
            thickness: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is AllNotifications ||
                      state is UnreadNotifications) {
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Center(child: buildChoiceChips(context)),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final int itemIndex = index ~/ 2;
                              if (index.isEven) {
                                return NotificationContainerWidget(
                                  notificationData:
                                      notificationsList[itemIndex],
                                  index: itemIndex,
                                );
                              }
                              return const Divider(height: 1);
                            },
                            childCount:
                                math.max(0, notificationsList.length * 2 - 1),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChoiceChips(
    BuildContext notificationContext,
  ) =>
      Wrap(
        runSpacing: spacing,
        spacing: spacing,
        children: ChoiceChips.getNotificationList(
                BlocProvider.of<NotificationBloc>(notificationContext).state
                    is AllNotifications)
            .map((choiceChip) => ChoiceChip(
                  label: Text(choiceChip.label),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                  onSelected: (isSelected) => setState(() {
                    ChoiceChips.getNotificationList(isAll).map((otherChip) {
                      if (choiceChip.label ==
                          AppLocalizations.of(Get.context!)!.unread) {
                        BlocProvider.of<NotificationBloc>(notificationContext)
                            .add(ToUnreadNotifications());
                      } else if (choiceChip.label ==
                          AppLocalizations.of(Get.context!)!.all) {
                        BlocProvider.of<NotificationBloc>(notificationContext)
                            .add(ToAllNotifications());
                      }
                      return otherChip.copy(
                          label: choiceChip.label,
                          isSelected: isSelected,
                          textColor: choiceChip.textColor,
                          selectedColor: choiceChip.selectedColor);
                    }).toList();
                  }),
                  selected: choiceChip.isSelected,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ))
            .toList(),
      );
}
