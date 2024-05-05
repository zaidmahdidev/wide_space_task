import 'package:ebn_balady/features/home/presentation/utils/pop_up_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class PostAndCommentMenuItems {
  static List<PostAndCommentMenuItem> ignoreItemsGroup = [
    itemNotInterested,
    itemReport
  ];

  static List<PostAndCommentMenuItem> extraItemsGroup = [itemDirectMessage];

  static List<PostAndCommentMenuItem> myPostItemsGroup = [
    itemUpdatePost,
    itemDeletePost
  ];

  static List<PostAndCommentMenuItem> myCommentItemsGroup = [
    itemUpdateComment,
    itemDeleteComment
  ];

  static initMenuItems() {
    itemNotInterested.title = AppLocalizations.of(Get.context!)!.notInterested;
    itemReport.title = AppLocalizations.of(Get.context!)!.report;
    itemDirectMessage.title = AppLocalizations.of(Get.context!)!.directMessage;
    itemDeletePost.title = AppLocalizations.of(Get.context!)!.deleteRequest;
    itemUpdatePost.title = AppLocalizations.of(Get.context!)!.editRequest;
    itemDeleteComment.title = AppLocalizations.of(Get.context!)!.deleteResponse;
    itemUpdateComment.title = AppLocalizations.of(Get.context!)!.editResponse;
  }

  static PostAndCommentMenuItem itemNotInterested = PostAndCommentMenuItem(
      title: AppLocalizations.of(Get.context!)!.notInterested,
      icon: Icons.not_interested);
  static PostAndCommentMenuItem itemReport = PostAndCommentMenuItem(
      title: AppLocalizations.of(Get.context!)!.report, icon: Icons.report);
  static PostAndCommentMenuItem itemDirectMessage = PostAndCommentMenuItem(
      title: AppLocalizations.of(Get.context!)!.directMessage,
      icon: Icons.message);
  static PostAndCommentMenuItem itemDeletePost = PostAndCommentMenuItem(
      title: AppLocalizations.of(Get.context!)!.deleteRequest,
      icon: Icons.delete);
  static PostAndCommentMenuItem itemUpdatePost = PostAndCommentMenuItem(
      title: AppLocalizations.of(Get.context!)!.editRequest, icon: Icons.edit);
  static PostAndCommentMenuItem itemDeleteComment = PostAndCommentMenuItem(
      title: AppLocalizations.of(Get.context!)!.deleteResponse,
      icon: Icons.delete);
  static PostAndCommentMenuItem itemUpdateComment = PostAndCommentMenuItem(
      title: AppLocalizations.of(Get.context!)!.editResponse, icon: Icons.edit);
}
