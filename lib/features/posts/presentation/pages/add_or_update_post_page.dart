import 'package:ebn_balady/core/utils/common_utils.dart';
import 'package:ebn_balady/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../data/models/post/Post.dart';
import '../states manager/posts_bloc/posts_bloc.dart';
import '../widgets/form_widget.dart';

class AddOrUpdatePostPage extends StatefulWidget {
  const AddOrUpdatePostPage({Key? key, this.post}) : super(key: key);
  final PostModel? post;

  @override
  State<AddOrUpdatePostPage> createState() => _AddOrUpdatePostPageState();
}

class _AddOrUpdatePostPageState extends State<AddOrUpdatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.post != null
              ? AppLocalizations.of(context)!.editRequest
              : AppLocalizations.of(context)!.addRequest),
        ),
        body: BlocProvider.value(
          value: BlocProvider.of<PostsBloc>(context),
          child:
              BlocConsumer<PostsBloc, PostsState>(listener: (context, state) {
            if (state is MessageAddDeleteUpdateState) {
              BlocProvider.of<PostsBloc>(context)
                  .add(const GetPostsEvent(pageNumber: 1));
              Get.back();
              Future.delayed(const Duration(seconds: 1));
              showSuccessFlushBar(message: state.message, context: context);
            } else if (state is ErrorAddDeleteUpdateState) {
              showFlushBar(
                state.message,
                context: context,
              );
            }
          }, builder: (context, state) {
            if (state is LoadingAddDeleteUpdateState) {
              return const LoadingWidget();
            }
            return FormWidget(
              post: widget.post,
            );
          }),
        ));
  }
}
