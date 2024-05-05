import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/common_utils.dart';
import '../../data/models/post/Post.dart';
import '../states manager/posts_bloc/posts_bloc.dart';
import '../widgets/posts_list.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    Key? key,
  }) : super(key: key);
  static int pageNumber = 1;
  static bool refresh = true;
  static bool postsCompleted = false;
  static bool postsLoading = false;
  static bool isLoading = false;
  static late LoadedPostsState lastState;
  static late List<PostModel> postList;
  static ScrollController scrollController = ScrollController();

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    PostsScreen.pageNumber = 1;
    PostsScreen.postsCompleted = false;
    PostsScreen.postList = [];
    PostsScreen.refresh = true;

    super.initState();
  }

  @override
  void dispose() {
    PostsScreen.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<PostsBloc>(context),
      child: BlocConsumer<PostsBloc, PostsState>(
        builder: (context, state) {
          PostsScreen.postsLoading = false;
          if (state is LoadingPostsState ||
              state is LoadingAddDeleteUpdateState) {
            PostsScreen.postsLoading = true;
          } else if (state is LoadedPostsState) {
            PostsScreen.isLoading = false;
            if (!PostsScreen.postsCompleted) {
              if (state.posts.isEmpty) {
                PostsScreen.postsCompleted = true;
              }
              if (PostsScreen.refresh) {
                PostsScreen.postList = state.posts;
              } else {
                PostsScreen.postList.addAll(state.posts);
              }
              PostsScreen.refresh = false;
            }
          }
          return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: PostsListWidget(postsContext: context));
        },
        listener: (context, state) {
          PostsScreen.scrollController.addListener(() {
            if (PostsScreen.scrollController.position.maxScrollExtent ==
                    PostsScreen.scrollController.offset &&
                !PostsScreen.postsCompleted) {
              if (!PostsScreen.isLoading) {
                PostsScreen.pageNumber += 1;
                BlocProvider.of<PostsBloc>(context)
                    .add(GetPostsEvent(pageNumber: PostsScreen.pageNumber));
                PostsScreen.isLoading = true;
              }
            }
          });

          if (state is ErrorAddDeleteUpdateState) {
            showFlushBar(
              state.message,
              context: context,
            );
          } else if (state is ErrorPostsState) {
            showFlushBar(
              state.message,
              context: context,
            );
          } else if (state is MessageAddDeleteUpdateState) {
            _onRefresh(context);
          }
        },
      ),
    );
  }
}

Future<void> _onRefresh(BuildContext context) async   {
  PostsScreen.refresh = true;
  PostsScreen.pageNumber = 1;
  PostsScreen.postsCompleted = false;
  BlocProvider.of<PostsBloc>(context)
      .add(GetPostsEvent(pageNumber: PostsScreen.pageNumber));
}
