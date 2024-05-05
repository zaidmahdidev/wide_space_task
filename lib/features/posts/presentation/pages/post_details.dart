import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebn_balady/core/utils/common_utils.dart';
import 'package:ebn_balady/features/posts/data/models/post/Post.dart';
import 'package:ebn_balady/features/posts/presentation/states%20manager/comments_bloc/comments_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/primary_text_field.dart';
import '../../../user/presentation/pages/profile/reviews_screen.dart';
import '../../../user/presentation/pages/profile/view_profile.dart';
import '../../data/models/comment/comment_model.dart';
import '../states manager/like_bloc/like_bloc.dart';
import '../states manager/post_ bloc/post_bloc.dart';
import '../widgets/comment_container.dart';

class PostDetails extends StatefulWidget {
  PostModel post;
  BuildContext postContext, commentsContext, likeContext;
  final int index;
  final DateFormat formatter;
  final TextEditingController commentController;

  PostDetails({
    required this.postContext,
    required this.commentsContext,
    required this.likeContext,
    required this.post,
    required this.formatter,
    required this.commentController,
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<CommentsBloc>(widget.commentsContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<PostBloc>(widget.postContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<LikeBloc>(widget.likeContext),
        ),
      ],
      child: MultiBlocListener(
          listeners: [
            BlocListener<PostBloc, PostState>(
              listener: (context, state) {
                if (state is ErrorPostState) {
                  showFlushBar(state.message, context: context);
                }
              },
            ),
            BlocListener<LikeBloc, LikeState>(
              listener: (context, state) {
                if (state is ErrorLikeState) {
                  showFlushBar(state.message, context: context);
                }
              },
            ),
          ],
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is LoadingPostState) {
                return BuildScaffold(
                  postContext: widget.postContext,
                  commentsContext: widget.commentsContext,
                  likeContext: widget.likeContext,
                  postLoading: true,
                  formatter: widget.formatter,
                  index: widget.index,
                  post: widget.post,
                  commentController: widget.commentController,
                );
              } else if (state is LoadedPostState) {
                widget.post = state.post;
                widget.commentController.clear();
                return BuildScaffold(
                  postContext: widget.postContext,
                  commentsContext: widget.commentsContext,
                  likeContext: widget.likeContext,
                  formatter: widget.formatter,
                  postLoading: false,
                  index: widget.index,
                  post: state.post,
                  commentController: widget.commentController,
                );
              }
              return BuildScaffold(
                postContext: widget.postContext,
                commentsContext: widget.commentsContext,
                likeContext: widget.likeContext,
                post: widget.post,
                postLoading: false,
                index: widget.index,
                formatter: widget.formatter,
                commentController: widget.commentController,
              );
            },
          )),
    );
  }
}

class BuildScaffold extends StatefulWidget {
  BuildScaffold({
    Key? key,
    required this.postLoading,
    required this.postContext,
    required this.commentsContext,
    required this.likeContext,
    required this.post,
    required this.index,
    required this.formatter,
    required this.commentController,
  }) : super(key: key);

  final TextEditingController commentController;
  final bool postLoading;
  final int index;
  final DateFormat formatter;
  PostModel post;

  BuildContext postContext, commentsContext, likeContext;

  @override
  State<BuildScaffold> createState() => _BuildScaffoldState();
}

class _BuildScaffoldState extends State<BuildScaffold> {
  bool fit = true;
  bool firstTime = true;
  bool commentsCompleted = false;
  int pageNumber = 1;
  late ScrollController scrollController;
  late List<CommentModel> commentList;

  @override
  void initState() {
    commentList = widget.post.recentlyComments != null
        ? widget.post.recentlyComments!
        : [];
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        BlocProvider.of<CommentsBloc>(widget.commentsContext).add(
            GetCommentsEvent(postId: widget.post.id!, pageNumber: pageNumber));
        pageNumber += 1;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    firstTime = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool commentsAddLoading = false;

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
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
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(56))),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          showSearch(
                              context: context, delegate: MySearchDelegate());
                        },
                        icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(56))),
                            child: const Icon(Icons.search_rounded)))
                  ],
                  expandedHeight: widget.post.image != null ? 350 : null,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.primary,
                      opacity: 0.7),
                  flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                    tag: 'image ${widget.index}',
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          fit = !fit;
                        });
                      },
                      child: widget.post.image != null
                          ? CachedNetworkImage(
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
                            )
                          : const SizedBox(),
                    ),
                  )),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => ViewProfileScreen(
                                      user: widget.post.user!));
                                },
                                child: Hero(
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
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.account_circle,
                                      size: 48,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => ViewProfileScreen(
                                      user: widget.post.user!));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
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
                              const Spacer(),
                              Column(
                                children: [
                                  Hero(
                                    tag: 'poster datetime ${widget.index}',
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        widget.formatter
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
                                                  .primary,
                                            ),
                                      ),
                                    ),
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
                                          GestureDetector(
                                              onTap: () {
                                                if (widget.post.isLiked ??
                                                    false) {
                                                  BlocProvider.of<LikeBloc>(
                                                          likeContext)
                                                      .add(RemoveLikeEvent(
                                                          postId:
                                                              widget.post.id!));
                                                } else {
                                                  BlocProvider.of<LikeBloc>(
                                                          widget.likeContext)
                                                      .add(AddLikeEvent(
                                                          postId:
                                                              widget.post.id!));
                                                }
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Hero(
                                                  tag: 'liked ${widget.index}',
                                                  child: likeLoading
                                                      ? const CircularProgressIndicator()
                                                      : Icon(
                                                          widget.post.isLiked ??
                                                                  false
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border_rounded,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          size: 24,
                                                        ),
                                                ),
                                              )),
                                          Hero(
                                            tag: 'likes count ${widget.index}',
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: Text(
                                                (widget.post.totalLikes)
                                                    .toString(),
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
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 2,
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Hero(
                          tag: 'title ${widget.index}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(widget.post.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                          ),
                        ),
                      ),
                      const Divider(
                        indent: 120,
                        color: Colors.black12,
                      ),
                      Hero(
                        tag: 'body ${widget.index}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Text(
                              widget.post.body,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                              // softWrap: true,
                            ),
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'total responses ${widget.index}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "${widget.post.totalComments} ${AppLocalizations.of(Get.context!)!.responses}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ),
                        ),
                      ),
                      BlocConsumer<CommentsBloc, CommentsState>(
                          listener: (commentContext, state) {
                        if (state is MessageCommentDeleteState ||
                            state is MessageCommentUpdateState ||
                            state is CommentAddState) {
                          if (state is CommentAddState) {
                            print("Comment is ${state.comment}");
                            commentList.insert(0, state.comment);
                          }
                          if (state is MessageCommentDeleteState) {
                            commentList.removeAt(state.index);
                          }
                          if (state is MessageCommentUpdateState) {
                            commentList[state.index].body = state.newBody;
                          }
                          BlocProvider.of<PostBloc>(widget.postContext)
                              .add(GetPostEvent(postId: widget.post.id!));
                        }
                        if (state is LoadedCommentsState) {
                          if (!commentsCompleted) {
                            if (state.comments.isEmpty) {
                              commentsCompleted = true;
                            }

                            if (firstTime) {
                              commentList = state.comments;
                              firstTime = false;
                            } else {
                              commentList.addAll(state.comments);
                            }
                            BlocProvider.of<PostBloc>(widget.postContext)
                                .add(GetPostEvent(postId: widget.post.id!));
                          }
                        }
                        if (state is ErrorCommentsState) {
                          showFlushBar(
                            state.message,
                            context: context,
                          );
                        }
                      }, builder: (context, state) {
                        commentsAddLoading = false;
                        if (state is LoadingCommentsAddState) {
                          commentsAddLoading = true;
                        }

                        return Hero(
                          tag: 'textField ${widget.index}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: AppTextFormField(
                              onChanged: (val) {
                                setState(() {});
                              },
                              context: context,
                              controller: widget.commentController,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              autoFocus: false,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                              hintText: AppLocalizations.of(Get.context!)!
                                  .writeAResponse,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.8)),
                              suffixIcon: commentsAddLoading
                                  ? Container(
                                      margin: const EdgeInsets.all(8),
                                      child: const CircularProgressIndicator())
                                  : IconButton(
                                      onPressed: () => validateSendResponse(
                                          widget.commentsContext,
                                          widget.commentController.text.trim()),
                                      icon: Icon(
                                        Icons.send_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return CommentContainer(
                          comment: commentList[index],
                          index: index,
                          postId: widget.post.id!);
                    },
                    childCount: commentList.length,
                  ),
                ),
                if (widget.postLoading)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.all(8),
                          child: const CircularProgressIndicator()),
                    ),
                  ),
                if (commentsCompleted)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                            AppLocalizations.of(Get.context!)!.noMoreResponses,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.postLoading)
            Center(
              child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 24,
                  height: 24,
                  child: const CircularProgressIndicator()),
            ),
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

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<PostBloc>(context)
        .add(GetPostEvent(postId: widget.post.id!));
  }
}
