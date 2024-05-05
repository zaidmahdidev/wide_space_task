import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regex_router/regex_router.dart';

import '../models/conversation.dart';
import '../widgets/conversation_tile.dart';
import 'conversation/index.dart';
import 'conversation/new_page.dart';
import 'message/index_page.dart';

final chatModuleRoutes = <String, RouteBuilder>{
  ConversationNewPage.routeName: (context, arguments) {
    return ProviderScope(
      overrides: [
        currentConversation.overrideWithValue(
          Conversation.fromMap({
            'data': {
              'loan_id': (arguments.body as Map)['loan_id'],
              'phone': (arguments.body as Map)['phone'],
              'loan_application_id':
                  (arguments.body as Map)['loan_application_id'],
              'user': {
                'name': (arguments.body as Map)['name'],
              }
            },
          }),
        ),
      ],
      child: const ConversationNewPage(),
    );
  },
  ConversationMessageIndexPage.routeName: (context, arguments) {
    return ProviderScope(
      overrides: [
        currentConversation.overrideWithValue(
          Conversation.fromMap({
            ...arguments.pathArgs,
            if (arguments.body is Map) ...arguments.body as Map
          }),
        ),
      ],
      child: const ConversationMessageIndexPage(),
    );
  },
  ConversationIndex.routeName: (context, arguments) {
    return const ProviderScope(
      overrides: [],
      child: ConversationIndex(),
    );
  },
};
