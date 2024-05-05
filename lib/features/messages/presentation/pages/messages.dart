import 'package:ebn_balady/features/messages/data/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../posts/presentation/widgets/filter_widget.dart';
import '../widgets/message_container.dart';
import 'dropdown_page.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController searchController = TextEditingController();
  List<MessageModel> messagesList = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      thumbVisibility: true,
      thicknessWhileDragging: 8,
      thickness: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return MessageContainerWidget(
                    messageData: messagesList[index],
                    index: index,
                  );
                },
                childCount: messagesList.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 72,
              ),
            ),
            const SliverToBoxAdapter(child: FilterWidget()),
            SliverToBoxAdapter(
                child: IconButton(
              onPressed: () {
                Get.to(DropDownPage());
              },
              icon: const Icon(Icons.navigation),
            )),
            SliverToBoxAdapter(
              child: Center(
                  child: Text(
                AppLocalizations.of(Get.context!)!.noMessagesYet,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.grey),
              )),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 72,
              ),
            )
          ],
        ),
      ),
    );
  }
}
