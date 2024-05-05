part of '../repositories/conversation_repository.dart';

class _ConversationService {
  const _ConversationService(this._client);

  final Dio _client;

  Future<Response> index([Map<String, dynamic> query = const {}]) {
    return _client.get('/api/v1/conversations', queryParameters: query);
  }

  Future<Response> create(Conversation conversation) {
    return _client.post('/api/v1/conversations', data: conversation.toMap());
  }

  Future<Response> show(dynamic id) {
    return _client.get('/api/v1/conversations/$id');
  }
}
