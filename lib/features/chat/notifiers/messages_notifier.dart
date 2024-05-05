import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/message.dart';
import '../pages/conversation/index.dart';

/// An object that controls a list of [Message].
class MessagesNotifier extends StateNotifier<PagingController<int, Message>> {
  static const _pageSize = 15;

  final Reader read;
  // ignore: prefer_typing_uninitialized_variables
  final repository;

  MessagesNotifier({required this.read, required this.repository})
      : super(PagingController<int, Message>(firstPageKey: 0)) {
    if (repository != null) {
      _fetchPage(0);
      state.addPageRequestListener(_fetchPage);

      // Mark last conversation message as read
      state.addListener(() {
        read(conversationsProvider.notifier)
            .addOrUpdate(repository.conversation..lastMessage!.isSeen = true);
      });
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    if (!mounted) return;

    try {
      final newItems = await repository!.index({
        'offset': pageKey,
        'limit': _pageSize,
        'page': (pageKey ~/ _pageSize) + 1,
      });

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        state.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + (newItems.length as int);
        state.appendPage(newItems, nextPageKey);
      }
    } catch (error, _) {
      state.error = error;
    }
  }

  void append(Message message) {
    // Notify conversation about new message
    // Add to list

    if (mounted) {
      read(conversationsProvider.notifier).addLastMessage(message);

      state = state
        ..itemList = [
          message,
          ...state.itemList!,
        ];
    }
  }

  void add(Message message) {
    repository!.create(message);
    append(message);
  }
}
