import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../injection_container.dart';
import '../models/conversation.dart';

part '../services/conversation_service.dart';

final conversationsRepositoryProvider = Provider(
  (ref) => _ConversationRepository(
    service: _ConversationService(sl<Dio>()),
  ),
);

class _ConversationRepository {
  const _ConversationRepository({required this.service});

  final _ConversationService service;

  Future<List<Conversation>> index([Map<String, dynamic> query = const {}]) =>
      service
          .index(query)
          .then((response) => Conversation.fromList(response.data));

  Future<Conversation> show(dynamic id) =>
      service.show(id).then((response) => Conversation.fromMap(response.data));

  Future<Conversation> create(Conversation conversation) => service
          .create(conversation)
          .then((response) => Conversation.fromMap(response.data))
          .then((conversation) {
        // conversation.logAdd();

        return conversation;
      });
}
