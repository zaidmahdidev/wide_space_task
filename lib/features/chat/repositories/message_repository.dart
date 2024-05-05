import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../injection_container.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../widgets/conversation_tile.dart';
import 'conversation_repository.dart';

part '../services/message_service.dart';

final messagesRepositoryProvider = FutureProvider<_MessageRepository>(
  (ref) async {
    return Future.sync(() async {
      final conversation = ref.watch(currentConversation);

      if (conversation.id == null) {
        return await ref
            .read(conversationsRepositoryProvider)
            .create(conversation);
      } else if (conversation.data == null) {
        return await ref
            .read(conversationsRepositoryProvider)
            .show(conversation.id!);
      }

      return conversation;
    }).then((conversation) {
      // Update conversation
      // ref.watch(conversationsProvider.notifier).addOrUpdate(conversation);
      // Update to notify messages page
      // TODO: check if nessesory
      currentConversation.overrideWithValue(conversation);
      return conversation;
    }).then(
      (conversation) => _MessageRepository(
        conversation,
        service: _MessageService(sl<Dio>()),
      ),
    );
  },
  dependencies: [
    currentConversation, // Use to watch currentConversation
    conversationsRepositoryProvider, // use to access conversaiton reposotory provider
  ],
);

class _MessageRepository {
  const _MessageRepository(this.conversation, {required this.service});

  final _MessageService service;
  final Conversation conversation;

  Future<List<Message>> index([Map<String, dynamic> query = const {}]) =>
      service
          .index(conversation, query)
          .then((response) => Message.fromList(response.data));

  Future<Message> create(Message message) => service
          .create(conversation, message)
          .then((response) => Message.fromMap(response.data))
          .then((message) {
        // message.logAdd();

        return message;
      });
}
