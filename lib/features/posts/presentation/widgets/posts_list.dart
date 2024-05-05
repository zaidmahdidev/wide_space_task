import 'package:ebn_balady/features/posts/presentation/widgets/post_container.dart';
import 'package:ebn_balady/features/posts/presentation/widgets/posts_shimmer.dart';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/posts.dart';
import 'filter_widget.dart';

class PostsListWidget extends StatefulWidget {
  PostsListWidget({
    required this.postsContext,
    Key? key,
  }) : super(key: key);

  final BuildContext postsContext;
  bool searchFocus = false;

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  TextEditingController searchController = TextEditingController();
  late List<Widget> avatars;
  final double imageSize = 16;
  final double shift = 4;

  @override
  void initState() {
    avatars = [
      const Icon(
        Icons.account_circle,
        size: 32,
      ),
      const Icon(
        Icons.account_circle,
        size: 32,
      ),
      const Icon(
        Icons.account_circle,
        size: 32,
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (PostsScreen.postsLoading && PostsScreen.postList.isNotEmpty) {
      return PostsShimmer(avatars: avatars, imageSize: imageSize, shift: shift);
    } else {
      return CupertinoScrollbar(
        thumbVisibility: true,
        thicknessWhileDragging: 8,
        thickness: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                // physics: const AlwaysScrollableScrollPhysics(),
                controller: PostsScreen.scrollController,
                slivers: [
                  const SliverToBoxAdapter(
                    child: FilterWidget(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return PostContainerWidget(
                          post: PostsScreen.postList[index],
                          index: index,
                        );
                      },
                      childCount: PostsScreen.postList.length,
                    ),
                  ),
                  if (PostsScreen.postsCompleted)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.noMoreRequests,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.black38)),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 72,
                    ),
                  )
                ],
              ),
              if (PostsScreen.postsLoading)
                PostsShimmer(
                    avatars: avatars, imageSize: imageSize, shift: shift),
            ],
          ),
        ),
      );
    }
  }
}
