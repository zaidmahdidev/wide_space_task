import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/app_theme.dart';
import '../../../core/widgets/cached_network_image.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../pages/message/index_page.dart';

final currentConversation = Provider<Conversation>((ref) {
  throw UnimplementedError();
});

class ConversationTile extends ConsumerWidget {
  const ConversationTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversation = ref.watch(currentConversation);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ConversationMessageIndexPage.routeName,
          arguments: conversation.toMap(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 20,
                  offset: const Offset(0, -2)),
            ]),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 1.5),
              ),
              width: 48.0,
              height: 48.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: cachedNetworkImage(
                  conversation.user?['avatar'] ?? '',
                  provider: true,
                  rounded: true,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.user!['name'],
                    style: AppTheme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.5),
                  ),
                  if (conversation.hasPreviewMessage) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: AppTheme.textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(.6),
                                    height: 1.5),
                                children: [
                                  if (conversation.lastMessage!.type ==
                                      MessageType.image)
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.image,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    )
                                  else if (conversation.lastMessage!.type ==
                                      MessageType.audio) ...[
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.bottom,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.mic_outlined,
                                              size: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .voiceMessage,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ],
                                        )),
                                  ] else if (conversation.lastMessage!.type ==
                                      MessageType.video) ...[
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.bottom,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.videocam_rounded,
                                              size: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .videoMessage,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ],
                                        )),
                                  ] else
                                    TextSpan(
                                      text: conversation.lastMessage!.body,
                                    )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          if (conversation.lastMessage!.isNotSeen)
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              height: 12,
                              width: 12,
                            )
                        ],
                      ),
                    )
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                timeago.format(
                  conversation.lastMessage?.createdAt ??
                      conversation.createdAt!,
                  locale: Get.locale!.languageCode,
                ),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
