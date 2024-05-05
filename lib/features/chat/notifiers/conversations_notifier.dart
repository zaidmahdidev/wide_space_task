import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../models/conversation.dart';
import '../models/message.dart';
import '../paging_notifier.dart';
import '../repositories/conversation_repository.dart';

final unreadMessagesCountProvider = StateProvider.autoDispose<int>(
  (ref) {
    return 0;
  },
);

/// An object that controls a list of [Conversation].
class ConversationsNotifier extends PagingNotifier<Conversation> {
  final Reader read;

  ConversationsNotifier(this.read)
      : super(
          fetch: (Map<String, dynamic> paging) {
            return read(conversationsRepositoryProvider).index({
              ...paging,
              'with': 'last_message',
            });
          },
        ) {
    state.addListener(() {
      read(unreadMessagesCountProvider.notifier).state = (state.itemList ?? [])
          .where((conversation) => conversation.lastMessage!.isNotSeen)
          .length;
    });

    Future.wait([
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      ),
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      ),
    ]);
  }

  // TODO: use [currentConversaiton] instead
  void addOrUpdate(Conversation conversation) {
    final isExits = state.itemList?.firstWhereOrNull(
            (_conversation) => _conversation.id == conversation.id) !=
        null;

    if (isExits) {
      state = state
        ..itemList = [
          for (final _conversation in state.itemList!)

            /// If same id then update the value by the given one
            if (_conversation.id == conversation.id)
              conversation
            else
              _conversation
        ];
    } else {
      state = state
        ..itemList = [
          conversation,
          if (state.itemList != null) ...[
            ...state.itemList!,
          ]
        ];
    }
  }

  void addLastMessage(Message message) {
    final conversation = state.itemList?.firstWhereOrNull(
      (conversation) => conversation.id == message.conversationId,
    );

    // Make sure conversation is exists because new conversation throws error
    if (conversation != null) {
      state = state
        ..itemList = [
          conversation..lastMessage = message,
          for (final conversation in state.itemList!)
            if (conversation.id != message.conversationId) conversation
        ];
    }
  }
}
