import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebn_balady/core/utils/common_utils.dart';
import 'package:ebn_balady/features/posts/data/models/comment/comment_model.dart';
import 'package:ebn_balady/features/posts/presentation/states%20manager/comment_like_bloc/comment_like_bloc.dart';
import 'package:ebn_balady/features/posts/presentation/widgets/popup_menu.dart';
import 'package:ebn_balady/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/models/current_provider.dart';
import '../../../home/presentation/utils/pop_up_menu_item.dart';
import '../../../home/presentation/utils/pop_up_menu_items.dart';
import '../../../user/presentation/pages/profile/view_profile.dart';

class CommentContainer extends StatefulWidget {
  CommentContainer({
    Key? key,
    required this.comment,
    required this.index,
    required this.postId,
  }) : super(key: key);

  CommentModel comment;
  final int index;
  final int postId;

  @override
  State<CommentContainer> createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl.get<CommentLikeBloc>(),
      child: Material(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ViewProfileScreen(
                        user: widget.comment.user!,
                      ));
                },
                child: Row(
                  children: [
                    Hero(
                      tag:
                          'response avatar ${widget.postId} ${widget.comment.id}',
                      child: CachedNetworkImage(
                        imageUrl: widget.comment.user?.avatar ?? "",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          );
                        },
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.account_circle,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        "${widget.comment.user?.firstName ?? ""} ${widget.comment.user?.middleName ?? ""} ${widget.comment.user?.lastName ?? ""}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    BlocConsumer<CommentLikeBloc, CommentLikeState>(
                        builder: (context, state) {
                      bool likeLoading = false;
                      bool disLikeLoading = false;
                      if (state is LikeAdded) {
                        widget.comment = state.comment;
                      } else if (state is LikeRemoved) {
                        widget.comment = state.comment;
                      } else if (state is LikeLoading) {
                        likeLoading = true;
                      } else if (state is DislikeAdded) {
                        widget.comment = state.comment;
                      } else if (state is DislikeRemoved) {
                        widget.comment = state.comment;
                      } else if (state is DislikeLoading) {
                        disLikeLoading = true;
                      }
                      return Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (widget.comment.isDownVoted ?? false) {
                                  BlocProvider.of<CommentLikeBloc>(context).add(
                                      RemoveDislikeEvent(
                                          commentId: widget.comment.id!,
                                          postId: widget.postId));
                                } else {
                                  BlocProvider.of<CommentLikeBloc>(context).add(
                                      AddDislikeEvent(
                                          commentId: widget.comment.id!,
                                          postId: widget.postId));
                                }
                              },
                              icon: disLikeLoading
                                  ? const CircularProgressIndicator()
                                  : Icon(
                                      widget.comment.isDownVoted ?? false
                                          ? Icons.thumb_down_rounded
                                          : Icons.thumb_down_outlined,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                          Text(
                            (widget.comment.totalDownVotes).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          IconButton(
                              onPressed: () {
                                if (widget.comment.isUpVoted ?? false) {
                                  BlocProvider.of<CommentLikeBloc>(context).add(
                                      RemoveLikeEvent(
                                          commentId: widget.comment.id!,
                                          postId: widget.postId));
                                } else {
                                  BlocProvider.of<CommentLikeBloc>(context).add(
                                      AddLikeEvent(
                                          commentId: widget.comment.id!,
                                          postId: widget.postId));
                                }
                              },
                              icon: likeLoading
                                  ? const CircularProgressIndicator()
                                  : Icon(
                                      widget.comment.isUpVoted ?? false
                                          ? Icons.thumb_up_alt_rounded
                                          : Icons.thumb_up_alt_outlined,
                                      size: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                          Text(
                            (widget.comment.totalUpVotes).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      );
                    }, listener: (context, state) {
                      if (state is ErrorLikeState) {
                        showFlushBar(state.message, context: context);
                      }
                    }),
                    PopupMenuButton<PostAndCommentMenuItem>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onSelected: (item) => onSelected(
                            context: context,
                            item: item,
                            comment: widget.comment,
                            postId: widget.postId,
                            index: widget.index),
                        itemBuilder: (context) => widget.comment.user?.id ==
                                Current.user.id
                            ? [
                                ...PostAndCommentMenuItems.myCommentItemsGroup
                                    .map(buildMenuItem)
                                    .toList()
                              ]
                            : [
                                ...PostAndCommentMenuItems.ignoreItemsGroup
                                    .map(buildMenuItem)
                                    .toList(),
                                const PopupMenuDivider(),
                                ...PostAndCommentMenuItems.extraItemsGroup
                                    .map(buildMenuItem)
                                    .toList(),
                              ])
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ReadMoreText(
                widget.comment.body ?? "",
                trimLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
                colorClickableText: Colors.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: AppLocalizations.of(Get.context!)!.showMore,
                trimExpandedText: AppLocalizations.of(Get.context!)!.showLess,
                moreStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
                lessStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
