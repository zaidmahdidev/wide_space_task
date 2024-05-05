import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:ebn_balady/features/user/presentation/pages/profile/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';

import '../../../../../core/app_theme.dart';
import '../../../../home/presentation/utils/pop_up_menu_item.dart';
import '../../../../home/presentation/utils/pop_up_menu_items.dart';
import '../../../../posts/presentation/widgets/popup_menu.dart';
import '../../../data/models/user_model.dart';

class ReviewsScreen extends StatefulWidget {
  final UserModel user;
  bool other = true;

  ReviewsScreen({
    Key? key,
    required this.user,
    required this.other,
  }) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final data = [
    Item(
        name: "Omar Taha Alfaqeer",
        avatar: const AssetImage('${imagesPath}omar.jpg'),
        body:
            "fkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjs;kl",
        likes: 12,
        dislikes: 4),
    Item(
        name: "Omar Taha Alfaqeer",
        avatar: const AssetImage('${imagesPath}omar.jpg'),
        body:
            "fkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjs;kl",
        likes: 4,
        dislikes: 0),
    Item(
        name: "Omar Taha Alfaqeer",
        avatar: const AssetImage('${imagesPath}omar.jpg'),
        body:
            "fkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjs;kl",
        likes: 8,
        dislikes: 2),
    Item(
        name: "Omar Taha Alfaqeer",
        avatar: const AssetImage('${imagesPath}omar.jpg'),
        body:
            "fkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjs;kl",
        likes: 4,
        dislikes: 15),
    Item(
        name: "Omar Taha Alfaqeer",
        avatar: const AssetImage('${imagesPath}omar.jpg'),
        body:
            "fkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjs;kl",
        likes: 0,
        dislikes: 0),
    Item(
        name: "Omar Taha Alfaqeer",
        avatar: const AssetImage('${imagesPath}omar.jpg'),
        body:
            "fkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjs;kl",
        likes: 45,
        dislikes: 0),
    Item(
        name: "Omar Taha Alfaqeer",
        avatar: const AssetImage('${imagesPath}omar.jpg'),
        body:
            "fkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjsfkjaskfjsiojfsdklfjsiofjsklfjs;kl",
        likes: 12,
        dislikes: 12),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 64,
            pinned: true,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Color(0xaaFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(56))),
                    child: const Icon(Icons.arrow_back_rounded))),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: MySearchDelegate());
                  },
                  icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Color(0xaaFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(56))),
                      child: const Icon(Icons.search_rounded)))
            ],
            expandedHeight: 350,
            backgroundColor: AppTheme.ghostWhite,
            iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.primary, opacity: 0.7),
            flexibleSpace: FlexibleSpaceBar(
                background: Hero(
              tag: 'image ${widget.user.id}',
              child: Stack(
                children: [
                  Image.asset(
                    '${imagesPath}omar.jpg',
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  MakeReviewWidget(
                    initialRating: widget.user.statistics?.rating ?? 0,
                    other: widget.other,
                    user: widget.user,
                  ),
                ],
              ),
            )),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'profile name ${widget.user.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text("Omar Taha Alfaqeer",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Hero(
                    tag: 'requester username ${widget.user.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text("@OmarTaha",
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                  ),
                ),
                const Divider(
                  endIndent: 200,
                  color: Colors.black12,
                ),
                ReviewsRatingWidget(
                  initialRating: widget.user.statistics?.rating ?? 0,
                ),
                const Divider(
                  endIndent: 200,
                  color: Colors.black12,
                ),
                Hero(
                  tag: 'total responses ${widget.user.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '19 Reviews',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        // softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Review(
                    user: widget.user, index: index, review: data[index]);
              },
              childCount: data.length,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewsRatingWidget extends StatelessWidget {
  ReviewsRatingWidget({Key? key, required this.initialRating})
      : super(key: key);
  double initialRating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                initialRating.toString(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 72, fontWeight: FontWeight.bold, height: 1.2),
              ),
              RatingBar.builder(
                initialRating: initialRating,
                minRating: 1,
                allowHalfRating: true,
                direction: Axis.horizontal,
                ignoreGestures: true,
                itemCount: 5,
                itemSize: 16,
                itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppTheme.gold,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "758",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '5',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: 0.75,
                        progressColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        barRadius: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '4',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: 0.1,
                        progressColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        barRadius: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '3',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: 0.15,
                        progressColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        barRadius: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '2',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: 0.05,
                        progressColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        barRadius: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '1',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: 0.05,
                        progressColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        barRadius: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MakeReviewWidget extends StatelessWidget {
  MakeReviewWidget({
    Key? key,
    required this.user,
    required this.initialRating,
    required this.other,
  }) : super(key: key);
  final UserModel user;
  final double initialRating;
  final bool other;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    )),
                child: RatingBar.builder(
                  initialRating: other ? 0 : initialRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  ignoreGestures: other ? false : true,
                  itemCount: 5,
                  allowHalfRating: other ? false : true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: AppTheme.gold,
                  ),
                  onRatingUpdate: (rating) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      width: 350,
                      buttonsBorderRadius: const BorderRadius.all(
                        Radius.circular(2),
                      ),
                      dismissOnTouchOutside: true,
                      dismissOnBackKeyPress: true,
                      headerAnimationLoop: false,
                      body: Column(
                        children: [
                          RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: AppTheme.gold,
                                  ),
                              onRatingUpdate: (rating) {}),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            AppLocalizations.of(context)!.writeADescription,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              autofocus: true,
                            ),
                          ),
                        ],
                      ),
                      animType: AnimType.bottomSlide,
                      btnCancelColor: Theme.of(context).colorScheme.error,
                      btnOkColor: Get.isDarkMode
                          ? AppTheme.darkSuccessColor
                          : AppTheme.successColor,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class Review extends StatefulWidget {
  const Review({
    Key? key,
    required this.user,
    required this.index,
    required this.review,
  }) : super(key: key);

  final UserModel user;
  final int index;
  final Item review;

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  bool liked = false;
  bool disLiked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: AppTheme.ghostWhite,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Get.to(
                  () => ViewProfileScreen(user: widget.user),
                );
              },
              child: Row(
                children: [
                  Hero(
                      tag: 'review avatar ${widget.user.id} ${widget.index}',
                      child: CircleAvatar(
                          backgroundImage: widget.user.avatar ?? "")),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      widget.user.displayName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          disLiked = !disLiked;
                          if (disLiked) {
                            liked = false;
                          }
                        });
                      },
                      icon: Icon(
                        disLiked
                            ? Icons.thumb_down_rounded
                            : Icons.thumb_down_outlined,
                        size: 20,
                      )),
                  Text(
                    disLiked
                        ? (widget.review.dislikes + 1).toString()
                        : "${widget.review.dislikes}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          liked = !liked;
                          if (liked) {
                            disLiked = false;
                          }
                        });
                      },
                      icon: Icon(
                        liked
                            ? Icons.thumb_up_alt_rounded
                            : Icons.thumb_up_alt_outlined,
                        size: 20,
                      )),
                  Text(
                    liked
                        ? (widget.review.likes + 1).toString()
                        : "${widget.review.likes}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  PopupMenuButton<PostAndCommentMenuItem>(
                    onSelected: (item) => null,
                    itemBuilder: (context) => [
                      ...PostAndCommentMenuItems.ignoreItemsGroup
                          .map(buildMenuItem)
                          .toList(),
                      const PopupMenuDivider(),
                      ...PostAndCommentMenuItems.extraItemsGroup
                          .map(buildMenuItem)
                          .toList(),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ReadMoreText(
              widget.review.body,
              trimLines: 2,
              style: Theme.of(context).textTheme.labelLarge,
              colorClickableText: Colors.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'SHOW MORE',
              trimExpandedText: 'SHOW LESS',
              moreStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
              lessStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final ImageProvider avatar;
  final String body;
  final int likes;
  final int dislikes;

  Item(
      {required this.body,
      required this.name,
      required this.avatar,
      required this.dislikes,
      required this.likes});
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}
