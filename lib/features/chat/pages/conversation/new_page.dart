import '../message/index_page.dart';

class ConversationNewPage extends ConversationMessageIndexPage {
  static const routeName = '/conversations/new';

  const ConversationNewPage({super.key});

  @override
  ConversationMessageIndexPageState createState() =>
      ConversationMessageIndexPageState();
}
