part of '../repositories/message_repository.dart';

class _MessageService {
  const _MessageService(this._client);

  final Dio _client;

  Future<Response> index(Conversation conversation, [Map<String, dynamic> query = const {}]) {
    return _client.get(
      '/api/v1/conversations/${conversation.id}/messages',
      queryParameters: query,
    );
  }

  Future<Response> create(Conversation conversation, Message message) {
    logger.d('message.toMap()');
    logger.d(message.toMap());
    logger.d(message.toMap().toString());
    return _client.post(
      '/api/v1/conversations/${conversation.id}/messages',
      data: message.toFormData(),
    );
  }
}
