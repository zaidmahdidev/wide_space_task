import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/widgets/no_data.dart';
import '../../models/conversation.dart';
import '../../notifiers/conversations_notifier.dart';
import '../../repositories/conversation_repository.dart';
import '../../widgets/conversation_tile.dart';

final conversationsProvider = StateNotifierProvider.autoDispose<
    ConversationsNotifier, PagingController<int, Conversation>>(
  (ref) {
    return ConversationsNotifier(ref.read);
  },
  dependencies: [
    conversationsRepositoryProvider,
    unreadMessagesCountProvider.notifier,
    // messagesProvider.notifier,
  ],
);

class ConversationIndex extends ConsumerWidget {
  static const routeName = '/conversations';

  const ConversationIndex({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.chats)),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(conversationsProvider).refresh();
          },
          child: PagedListView<int, Conversation>.separated(
            padding: const EdgeInsets.only(top: 12),
            pagingController: ref.watch(conversationsProvider),
            builderDelegate: PagedChildBuilderDelegate<Conversation>(
              itemBuilder: (context, conversation, index) => ProviderScope(
                overrides: [
                  currentConversation.overrideWithValue(conversation),
                ],
                child:
                    const ConversationTile(), // DONT: use [const] because badge not listen to provider changes
              ),
              noItemsFoundIndicatorBuilder: (context) {
                return NoDataFull(
                    message:
                        AppLocalizations.of(context)!.noConversationsTillNow);
              },
            ),
            separatorBuilder: (_, __) => const Divider(height: 0),
          ),
        ),
      ),
    );
  }
}
