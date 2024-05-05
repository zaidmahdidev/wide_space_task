import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// An object that controls a list of [Conversation].
class PagingNotifier<T> extends StateNotifier<PagingController<int, T>> {
  final int _pageSize;
  final Future<List<T>> Function(Map<String, dynamic> paging) fetch;

  PagingNotifier({
    int pageSize = 15,
    required this.fetch,
  })  : _pageSize = pageSize,
        super(PagingController<int, T>(firstPageKey: 0)) {
    state.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetch({
        'offset': pageKey,
        'limit': _pageSize,
        'page': (pageKey ~/ _pageSize) + 1,
      });

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        state.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        state.appendPage(newItems, nextPageKey);
      }
    } catch (error, _) {
      state.error = error;
    }
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}
