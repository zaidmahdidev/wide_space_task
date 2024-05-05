import 'package:ebn_balady/features/posts/data/models/comment/comment_model.dart';
import 'package:ebn_balady/features/posts/presentation/states%20manager/comments_bloc/comments_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../home/presentation/utils/pop_up_menu_item.dart';
import '../../../home/presentation/utils/pop_up_menu_items.dart';
import '../../data/models/post/Post.dart';
import '../pages/add_or_update_post_page.dart';
import '../states manager/post_ bloc/post_bloc.dart';
import '../states manager/posts_bloc/posts_bloc.dart';

PopupMenuItem<PostAndCommentMenuItem> buildMenuItem(
        PostAndCommentMenuItem item) =>
    PopupMenuItem<PostAndCommentMenuItem>(
        value: item,
        child: ListTile(
          iconColor: Theme.of(Get.context!).colorScheme.primary,
          title: Text(
            item.title,
            style: AppTheme.textTheme.labelLarge!
                .copyWith(color: Theme.of(Get.context!).colorScheme.primary),
          ),
          leading: Icon(
            size: 24,
            item.icon,
          ),
        ));

void onSelected(
    {required BuildContext context,
    required PostAndCommentMenuItem item,
    PostModel? post,
    CommentModel? comment,
    int? postId,
    int? index}) {
  if (item == PostAndCommentMenuItems.itemReport) {
    workingOnThisFeature(context);
  } else if (item == PostAndCommentMenuItems.itemNotInterested) {
    workingOnThisFeature(context);
  } else if (item == PostAndCommentMenuItems.itemDirectMessage) {
    workingOnThisFeature(context);
  } else if (item == PostAndCommentMenuItems.itemUpdatePost) {
    Get.to(() => AddOrUpdatePostPage(
          post: post,
        ));
  } else if (item == PostAndCommentMenuItems.itemDeletePost) {
    deletePost(context: context, post: post!);
  } else if (item == PostAndCommentMenuItems.itemUpdateComment) {
    final TextEditingController commentController = TextEditingController();
    commentController.text = comment!.body!;
    updateComment(
        context: context,
        comment: comment,
        commentController: commentController,
        postId: postId!,
        index: index!,);
  } else if (item == PostAndCommentMenuItems.itemDeleteComment) {
    deleteComment(
        comment: comment!, context: context, postId: postId!, index: index!);
  }
}

void workingOnThisFeature(context) {
  Fluttertoast.showToast(
    msg: AppLocalizations.of(Get.context!)!.featureWorking,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    textColor: Theme.of(context).colorScheme.primary,
    fontSize: 16.0,
  );
}

void deletePost({required BuildContext context, required PostModel post}) {
  Dialogs.materialDialog(
      msg: AppLocalizations.of(Get.context!)!.sureToDelete,
      msgStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      title: AppLocalizations.of(Get.context!)!.isDeleteRequest,
      titleStyle: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      color: Theme.of(context).colorScheme.surface,
      context: context,
      dialogWidth: kIsWeb ? 0.3 : null,
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
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
          iconColor: Theme.of(context).colorScheme.onSurface,
        ),
        IconsButton(
          onPressed: () {
            BlocProvider.of<PostsBloc>(context)
                .add(DeletePostEvent(postId: post.id ?? 0));
            Navigator.of(context).pop();
          },
          text: AppLocalizations.of(Get.context!)!.delete,
          iconData: Icons.delete,
          color: Theme.of(context).colorScheme.error,
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
          iconColor: Colors.white,
        ),
      ]);
}

void updateComment({
  required BuildContext context,
  required CommentModel comment,
  required int postId,
  required TextEditingController commentController,
  required int index,
}) {
  Dialogs.materialDialog(
      color: Theme.of(context).colorScheme.surface,
      context: context,
      customView:   UpdateCommentDialog(commentController: commentController,),
      dialogWidth: kIsWeb ? 0.3 : null,
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
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
          iconColor: Theme.of(context).colorScheme.onSurface,
        ),
        IconsButton(
          onPressed: () {
            CommentModel newComment =
                comment.copyWith(body: commentController.text.trim());
            BlocProvider.of<CommentsBloc>(context).add(UpdateCommentEvent(
                postId: postId, newComment: newComment, index: index));
            BlocProvider.of<PostBloc>(context)
                .add(GetPostEvent(postId: postId));
            Navigator.of(context).pop();
          },
          text: AppLocalizations.of(Get.context!)!.update,
          iconData: Icons.edit,
          color: Theme.of(context).colorScheme.primary,
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          iconColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ]);
}

class UpdateCommentDialog extends StatefulWidget {
  UpdateCommentDialog({
    Key? key,
    required this.commentController,
  }) : super(key: key);
  TextEditingController commentController;
  @override
  State<UpdateCommentDialog> createState() => _UpdateCommentDialogState();
}

class _UpdateCommentDialogState extends State<UpdateCommentDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(Get.context!)!.writeAResponse,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          AppTextFormField(
            context: context,
            onChanged: (val){
              setState(() {
              });
            },
            controller: widget.commentController,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            autoFocus: false,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
    );
  }
}

void deleteComment(
    {required context,
    required int postId,
    required CommentModel comment,
    required int index}) {
  Dialogs.materialDialog(
      msg: AppLocalizations.of(Get.context!)!.sureToDelete,
      title: AppLocalizations.of(Get.context!)!.isDeleteResponse,
      msgStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      titleStyle: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      color: Theme.of(context).colorScheme.surface,
      context: context,
      dialogWidth: kIsWeb ? 0.3 : null,
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
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
          iconColor: Theme.of(context).colorScheme.onSurface,
        ),
        IconsButton(
          onPressed: () {
            BlocProvider.of<CommentsBloc>(context).add(DeleteCommentEvent(
                postId: postId, commentId: comment.id!, index: index));
            BlocProvider.of<PostBloc>(context)
                .add(GetPostEvent(postId: postId));
            Navigator.of(context).pop();
          },
          text: AppLocalizations.of(Get.context!)!.delete,
          iconData: Icons.delete,
          color: Theme.of(context).colorScheme.error,
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
          iconColor: Colors.white,
        ),
      ]);
}
