import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:ebn_balady/core/utils/common_utils.dart';
import 'package:ebn_balady/features/home/presentation/utils/pop_up_menu_item.dart';
import 'package:ebn_balady/features/home/presentation/utils/pop_up_menu_items.dart';
import 'package:ebn_balady/features/posts/presentation/widgets/popup_menu.dart';
import 'package:ebn_balady/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/models/current_provider.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../user/presentation/manager/user_bloc.dart';
import '../../../user/presentation/pages/profile/view_profile.dart';
import '../../data/models/post/Post.dart';
import '../pages/post_details.dart';
import '../pages/posts.dart';
import '../states manager/comments_bloc/comments_bloc.dart';
import '../states manager/like_bloc/like_bloc.dart';
import '../states manager/post_ bloc/post_bloc.dart';
import '../states manager/posts_bloc/posts_bloc.dart';

class PostContainerWidget extends StatefulWidget {
  const PostContainerWidget({required this.post, Key? key, required this.index})
      : super(key: key);
  final PostModel post;
  final int index;

  @override
  State<PostContainerWidget> createState() => _PostContainerWidgetState();
}

class _PostContainerWidgetState extends State<PostContainerWidget> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _avatars = widget.post.recentlyComments != null
        ? widget.post.recentlyComments!.map((e) => e.user?.avatar).toList()
        : [];
    List<Widget> avatarWidgetList = fillAvatars(_avatars);

    return BlocConsumer<PostsBloc, PostsState>(
      listener: (context, state) {
        if (state is ErrorPostsState) {
          showFlushBar(
            state.message,
            context: context,
          );
        }
      },
      builder: (context, state) {
        if (state is LoadedPostsState) {
          return PostContainerBody(
              post: PostsScreen.postList[widget.index],
              index: widget.index,
              avatars: avatarWidgetList);
        } else {
          return PostContainerBody(
              post: widget.post,
              index: widget.index,
              avatars: avatarWidgetList);
        }
      },
    );
  }
}

class PostContainerBody extends StatefulWidget {
  PostContainerBody(
      {Key? key,
      required this.post,
      required this.index,
      required this.avatars})
      : super(key: key);
  PostModel post;
  final int index;
  List<Widget> avatars;
  bool postLoading = false;
  final TextEditingController commentController = TextEditingController();

  @override
  State<PostContainerBody> createState() => _PostContainerBodyState();
}

class _PostContainerBodyState extends State<PostContainerBody> {
  final double imageSize = 12;
  final double shift = 12;
  bool fit = true;

  final DateFormat formatter = DateFormat('yyyy-MM-dd. HH:mm');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return di.sl.get<PostBloc>();
          },
        ),
        BlocProvider(
          create: (_) {
            return di.sl.get<LikeBloc>();
          },
        ),
        BlocProvider(
          create: (_) {
            return di.sl.get<CommentsBloc>();
          },
        )
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state is ErrorPostState) {
                showFlushBar(
                  state.message,
                  context: context,
                );
              }
            },
          ),
          BlocListener<LikeBloc, LikeState>(
            listener: (context, state) {
              if (state is ErrorLikeState) {
                showFlushBar(
                  state.message,
                  context: context,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<PostBloc, PostState>(
          builder: (postContext, state) {
            widget.postLoading = false;
            if (state is LoadedPostState) {
              widget.post = state.post;
              fillAvatarList();
              widget.commentController.clear();
            } else if (state is LoadingPostState) {
              widget.postLoading = true;
            }
            return buildPostState(postContext);
          },
        ),
      ),
    );
  }

  void fillAvatarList() {
    List<dynamic> avatarList = widget.post.recentlyComments != null
        ? widget.post.recentlyComments!.map((e) => e.user?.avatar).toList()
        : [];
    widget.avatars = fillAvatars(avatarList);
  }

  Container buildPostState(BuildContext postContext) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(postContext).colorScheme.surface,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      if (Current.user.id != widget.post.user!.id!) {
                        BlocProvider.of<UserBloc>(postContext)
                            .add(GetUserRequest(userId: widget.post.user!.id!));
                        Get.to(
                            () => ViewProfileScreen(user: widget.post.user!));
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                AppLocalizations.of(context)!.thisIsYourAccount,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            textColor: Theme.of(context).colorScheme.primary,
                            fontSize: 16.0);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: Get.locale == const Locale('ar', 'YE') ? 0 : 16,
                          right:
                              Get.locale == const Locale('ar', 'YE') ? 16 : 0),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'poster avatar ${widget.index}',
                            child: CachedNetworkImage(
                              imageUrl: widget.post.user?.avatar ?? "",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Hero(
                                      tag: 'poster name ${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                            "${widget.post.user?.firstName ?? ""} ${widget.post.user?.middleName ?? ""} ${widget.post.user?.lastName ?? ""}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary)),
                                      ),
                                    )),
                                    Hero(
                                      tag: 'poster datetime ${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          formatter
                                              .format(DateTime.parse(
                                                  widget.post.createdAt!))
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Hero(
                                  tag: 'poster username ${widget.index}',
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                        widget.post.user?.username ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuButton<PostAndCommentMenuItem>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onSelected: (item) {
                  return onSelected(
                      context: postContext, item: item, post: widget.post);
                },
                itemBuilder: (context) {
                  return widget.post.user!.id == Current.user.id
                      ? [
                          ...PostAndCommentMenuItems.myPostItemsGroup
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
                        ];
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Hero(
              tag: 'title ${widget.index}',
              child: Material(
                  type: MaterialType.transparency,
                  child: Text(widget.post.title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary))),
            ),
          ),
          Stack(
            children: [
              widget.post.image != null
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          fit = !fit;
                        });
                      },
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Hero(
                          tag: 'image ${widget.index}',
                          child: CachedNetworkImage(
                            imageUrl: widget.post.image,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image),
                            fit: fit ? BoxFit.fitWidth : BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    )
                  : const Divider(
                      color: Colors.black12,
                      indent: 120,
                    ),
              if (widget.postLoading == true)
                const Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(child: CircularProgressIndicator())),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Hero(
              tag: 'body ${widget.index}',
              child: Material(
                type: MaterialType.transparency,
                child: ReadMoreText(
                  widget.post.body,
                  trimLines: 2,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary),
                  colorClickableText: Theme.of(context).colorScheme.primary,
                  trimMode: TrimMode.Line,
                  trimCollapsedText:
                      AppLocalizations.of(Get.context!)!.showMore,
                  trimExpandedText: AppLocalizations.of(Get.context!)!.showLess,
                  moreStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                  lessStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Divider(
            height: 2,
            color: Colors.black12,
          ),
          BlocConsumer<CommentsBloc, CommentsState>(
              listener: (commentContext, state) {
            if (state is CommentAddState) {
              // BlocProvider.of<PostBloc>(postContext)
              //     .add(GetPostEvent(postId: widget.post.id!));
              widget.post.recentlyComments!.insert(0, state.comment);
              fillAvatarList();
              widget.commentController.clear();
              if (widget.post.totalComments != null) {
                widget.post.totalComments = widget.post.totalComments! + 1;
              }
            }
            if (state is ErrorCommentsState) {
              showFlushBar(state.message, context: context);
            }
          }, builder: (commentsContext, state) {
            bool commentsLoading = false;
            if (state is LoadingCommentsAddState) {
              commentsLoading = true;
            }

            return Column(children: [
              Hero(
                tag: 'textField ${widget.index}',
                child: Material(
                  type: MaterialType.transparency,
                  child: AppTextFormField(
                    onChanged: (val) {
                      setState(() {});
                    },
                    context: context,
                    margin: EdgeInsets.zero,
                    radius: 0,
                    controller: widget.commentController,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    validator: (val) => validateEditTextField(val, responseKey),
                    autoFocus: false,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                    hintText: AppLocalizations.of(Get.context!)!.writeAResponse,
                    hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8)),
                    suffixIcon: commentsLoading
                        ? Container(
                            margin: const EdgeInsets.all(8),
                            child: const CircularProgressIndicator())
                        : IconButton(
                            onPressed: () => validateSendResponse(
                                commentsContext,
                                widget.commentController.text.trim()),
                            icon: Icon(
                              Icons.send_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  ),
                ),
              ),
              Material(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                child: BlocBuilder<LikeBloc, LikeState>(
                    builder: (likeContext, state) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        PostDetails(
                            postContext: postContext,
                            likeContext: likeContext,
                            commentsContext: commentsContext,
                            formatter: formatter,
                            post: widget.post,
                            index: widget.index,
                            commentController: widget.commentController),
                        duration: const Duration(milliseconds: 800),
                        transition: Transition.native,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.avatars.isNotEmpty)
                                    SizedBox(
                                      child: Stack(
                                        children: widget.avatars
                                            .asMap()
                                            .map((index, item) {
                                              double circleShift =
                                                  imageSize + shift;
                                              final value = Hero(
                                                  tag:
                                                      'response avatar ${widget.post.id} ${widget.post.recentlyComments?[index].id}',
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          width: 2.0,
                                                          style: BorderStyle
                                                              .solid),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      left: Get.locale ==
                                                              const Locale(
                                                                  'ar', 'YE')
                                                          ? 0
                                                          : circleShift * index,
                                                      right: Get.locale ==
                                                              const Locale(
                                                                  'ar', 'YE')
                                                          ? circleShift * index
                                                          : 0,
                                                    ),
                                                    child: item,
                                                  ));
                                              return MapEntry(index, value);
                                            })
                                            .values
                                            .toList()
                                            .reversed
                                            .toList(),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Hero(
                                              tag:
                                                  'total responses ${widget.index}',
                                              child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Text(
                                                    "${widget.post.totalComments} ${AppLocalizations.of(Get.context!)!.responses}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            height: 1.2,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary),
                                                  ))),
                                        ),
                                        Icon(
                                          Get.locale == const Locale('ar', 'YE')
                                              ? Icons.keyboard_arrow_left
                                              : Icons.keyboard_arrow_right,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.black12,
                              indent: 8,
                              endIndent: 8,
                            ),
                            BlocBuilder<LikeBloc, LikeState>(
                              builder: (likeContext, state) {
                                bool likeLoading = false;
                                if (state is LikeAdded) {
                                  widget.post = state.post;
                                } else if (state is LikeRemoved) {
                                  widget.post = state.post;
                                } else if (state is LikeLoading) {
                                  likeLoading = true;
                                }
                                return Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (widget.post.isLiked ?? false) {
                                            BlocProvider.of<LikeBloc>(
                                                    likeContext)
                                                .add(RemoveLikeEvent(
                                                    postId: widget.post.id!));
                                          } else {
                                            BlocProvider.of<LikeBloc>(
                                                    likeContext)
                                                .add(AddLikeEvent(
                                                    postId: widget.post.id!));
                                          }
                                        },
                                        icon: Hero(
                                          tag: 'liked ${widget.index}',
                                          child: likeLoading
                                              ? const CircularProgressIndicator()
                                              : Icon(
                                                  widget.post.isLiked ?? false
                                                      ? Icons.favorite
                                                      : Icons
                                                          .favorite_border_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  size: 24,
                                                ),
                                        )),
                                    Hero(
                                      tag: 'likes count ${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          (widget.post.totalLikes).toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ]);
          }),
        ],
      ),
    );
  }

  void validateSendResponse(BuildContext commentsContext, String comment) {
    if (comment.isNotEmpty) {
      BlocProvider.of<CommentsBloc>(commentsContext).add(AddCommentEvent(
          body: widget.commentController.text, postId: widget.post.id!));
    } else {
      showFlushBar(AppLocalizations.of(Get.context!)!.responseCantBeEmpty,
          context: context);
    }
  }
}

List<Widget> fillAvatars(avatarList) {
  List<Widget> avatars = [];
  if (avatarList.isNotEmpty) {
    List threeAvatars = [];
    threeAvatars.add(avatarList[0]);
    if (avatarList.length > 1) {
      threeAvatars.add(avatarList[1]);
    }
    if (avatarList.length > 2) {
      threeAvatars.add(avatarList[2]);
    }
    avatars = threeAvatars
        .asMap()
        .map((index, image) {
          return MapEntry(
            index,
            CachedNetworkImage(
              width: 32,
              height: 32,
              imageUrl: image ?? "",
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                );
              },
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(
                Icons.account_circle,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        })
        .values
        .toList();
  }
  return avatars;
}
