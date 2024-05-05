import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/widgets/no_data.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../notifiers/conversations_notifier.dart';
import '../../notifiers/messages_notifier.dart';
import '../../repositories/message_repository.dart';
import '../../widgets/conversation_tile.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/record_button.dart';
import '../conversation/index.dart';

// TODO: use FutureProvider
final messagesProvider = StateNotifierProvider.autoDispose<MessagesNotifier,
    PagingController<int, Message>>(
  (ref) {
    return MessagesNotifier(
      read: ref.read,
      repository: ref.watch(messagesRepositoryProvider).value,
    );
  },
  dependencies: [
    messagesRepositoryProvider, // Used to watch repository changes
    // conversationsProvider
    //     .notifier, // Used to notify conversation tile when adding new message
  ],
);

class ConversationMessageIndexPage extends ConsumerStatefulWidget {
  static const routeName = '/conversations/:id/messages';

  const ConversationMessageIndexPage({super.key});

  @override
  ConsumerState<ConversationMessageIndexPage> createState() =>
      ConversationMessageIndexPageState();
}

class ConversationMessageIndexPageState
    extends ConsumerState<ConversationMessageIndexPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  final _messageTextController = TextEditingController();

  bool _hasTextMessage = false;

  // TransactionModel? referencedTransaction;

  @override
  void initState() {
    _messageTextController.addListener(() {
      setState(() {
        _hasTextMessage = _messageTextController.text.trim().isNotEmpty;
      });
    });

    // if ((Get.arguments as Map).containsKey('transaction')) {
    //   // referencedTransaction = Get.arguments['transaction'];
    // }
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ConversationsNotifier>(conversationsProvider.notifier,
        (previous, next) {
      // Call to watch list and scroll indicator
    });
    ref.listen<MessagesNotifier>(messagesProvider.notifier, (previous, next) {
      // Call to watch list and scroll indicator
    });

    final Conversation conversation =
        (ref.watch(messagesProvider.notifier).repository?.conversation ??
            ref.watch(currentConversation))!;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: conversation.user != null
            ? Text(
                conversation.user!['name'],
              )
            : null,
        actions: const [
          // todo: navigate to peer main screen
          // IconButton(
          //   onPressed: () => Navigator.of(context).pushNamed(
          //     ProfilePage.routeName,
          //     arguments: conversation.user!['id'],
          //   ),
          //   icon: const Icon(Icons.store_outlined),
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PagedListView<int, Message>(
              scrollController: _scrollController,
              pagingController: ref.watch(messagesProvider),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              reverse: true,
              cacheExtent: 1000,
              addAutomaticKeepAlives: true,
              builderDelegate: PagedChildBuilderDelegate<Message>(
                  itemBuilder: (context, message, index) =>
                      MessageBubble(message),
                  noItemsFoundIndicatorBuilder: (context) {
                    return NoDataFull(
                        message:
                            AppLocalizations.of(context)!.noMessagesTillNow);
                  }),
            ),
          ),
          _buildBottomBox(context, conversation),
        ],
      ),
    );
  }

  Widget _buildBottomBox(BuildContext context, Conversation conversation) {
    return Material(
      elevation: 8,
      child: Column(
        children: ListTile.divideTiles(
          color: Theme.of(context).dividerColor,
          tiles: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  // if (referencedTransaction != null) ...[
                  //   Container(
                  //     height: 140,
                  //     width: ScreenUtil.screenWidth,
                  //     decoration: BoxDecoration(
                  //         color: Theme.of(context)
                  //             .colorScheme
                  //             .onSurface
                  //             .withOpacity(.2),
                  //         borderRadius: BorderRadius.circular(8.0)),
                  //     child: Container(
                  //       margin: const EdgeInsets.all(4),
                  //       decoration: BoxDecoration(
                  //           color: Theme.of(context).colorScheme.surface,
                  //           borderRadius: BorderRadius.circular(8.0)),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           if (referencedTransaction!.thumb.isNotEmpty) ...[
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(1000.0),
                  //                   border: Border.all(
                  //                       color: Theme.of(context)
                  //                           .colorScheme
                  //                           .onSurface
                  //                           .withOpacity(.4),
                  //                       width: 1)),
                  //               margin: const EdgeInsets.symmetric(
                  //                   horizontal: 8, vertical: 4),
                  //               width: 54,
                  //               height: 54,
                  //               child: CircleAvatar(
                  //                 radius: 1000,
                  //                 backgroundColor:
                  //                     Theme.of(context).colorScheme.background,
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(1000),
                  //                   child: cachedNetworkImage(
                  //                     referencedTransaction!.thumb,
                  //                     provider: true,
                  //                     errorWidget: const Icon(
                  //                       Icons.account_box_rounded,
                  //                       size: 30,
                  //                       color: Colors.white,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             const SizedBox(
                  //               width: 12,
                  //             ),
                  //           ],
                  //           Expanded(
                  //               child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   referencedTransaction!.type.name,
                  //                   style:
                  //                       Theme.of(context).textTheme.subtitle1,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 4,
                  //                 ),
                  //                 Text(
                  //                   "${intl.NumberFormat("###,###").format(referencedTransaction!.gross)} ${referencedTransaction!.currency.symbol}",
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .subtitle1!
                  //                       .copyWith(
                  //                           fontWeight: FontWeight.bold,
                  //                           color: Theme.of(context)
                  //                               .colorScheme
                  //                               .onSurface),
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 4,
                  //                 ),
                  //                 Text(
                  //                   intl.DateFormat('yyyy-MM-dd')
                  //                       .format(referencedTransaction!.time),
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .subtitle1!
                  //                       .copyWith(
                  //                           color: Theme.of(context)
                  //                               .colorScheme
                  //                               .onSurface
                  //                               .withOpacity(.6)),
                  //                 ),
                  //               ],
                  //             ),
                  //           )),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: GestureDetector(
                  //               behavior: HitTestBehavior.opaque,
                  //               onTap: () {
                  //                 setState(() {
                  //                   referencedTransaction = null;
                  //                 });
                  //               },
                  //               child: const Icon(Icons.close),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ],
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    padding: const EdgeInsetsDirectional.only(
                      start: 8.0,
                      end: 48.0,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54.withOpacity(.06),
                              blurRadius: 20)
                        ]),
                    child: TextField(
                      enabled: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      controller: _messageTextController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.writeMessage,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0.0),
                      ),
                    ),
                  ),
                  if (_hasTextMessage)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FloatingActionButton(
                        elevation: 0,
                        heroTag: const Key('send-message'),
                        mini: true,
                        onPressed: () => _submit(
                          conversation,
                          Message.text(_messageTextController.text.trim(),
                              conversationId: conversation.id!),
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                        ),
                      ),
                    )
                  else ...[
                    Transform.translate(
                      offset: Offset(
                        Directionality.of(context) == TextDirection.rtl
                            ? 48
                            : -48,
                        -4,
                      ),
                      child: FloatingActionButton(
                        elevation: 0,
                        heroTag: const Key('show-options'),
                        mini: true,
                        onPressed: () => _showBottomSheet(conversation),
                        child: const Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                    RecordButton(
                      onSubmit: (file) {
                        _submit(
                          conversation,
                          Message.audio(
                            file,
                            conversationId: conversation.id!,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ).toList(),
      ),
    );
  }

  void _showBottomSheet(Conversation conversation) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: ListTile.divideTiles(
          color: Colors.white,
          tiles: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(AppLocalizations.of(context)!.cameraPhoto),
              onTap: () {
                Navigator.of(context).pop();
                _imagePicker
                    .pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxHeight: 1024,
                )
                    .then((file) {
                  if (file != null) {
                    _submit(
                      conversation,
                      Message.image(
                        File(file.path),
                        conversationId: conversation.id!,
                      ),
                    );
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(AppLocalizations.of(context)!.galleryPhoto),
              onTap: () {
                Navigator.of(context).pop();
                _imagePicker
                    .pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                  maxHeight: 1024,
                )
                    .then((file) {
                  if (file != null) {
                    _submit(
                      conversation,
                      Message.image(
                        File(file.path),
                        conversationId: conversation.id!,
                      ),
                    );
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_camera_back_outlined),
              title: Text(AppLocalizations.of(context)!.cameraVideo),
              onTap: () {
                Navigator.of(context).pop();
                _imagePicker
                    .pickVideo(
                  source: ImageSource.camera,
                  maxDuration: const Duration(minutes: 3),
                )
                    .then((file) {
                  if (file != null) {
                    _submit(
                      conversation,
                      Message.video(
                        File(file.path),
                        conversationId: conversation.id!,
                      ),
                    );
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_collection_outlined),
              title: Text(AppLocalizations.of(context)!.galleryVideo),
              onTap: () {
                Navigator.of(context).pop();
                _imagePicker
                    .pickVideo(
                  source: ImageSource.gallery,
                  maxDuration: const Duration(minutes: 3),
                )
                    .then((file) {
                  if (file != null) {
                    _submit(
                      conversation,
                      Message.video(
                        File(file.path),
                        conversationId: conversation.id!,
                      ),
                    );
                  }
                });
              },
            ),
          ],
        ).toList(),
      ),
    );
  }

  void _submit(Conversation conversation, Message message) async {
    try {
      ref.read(messagesProvider.notifier).add(message);
      ref.read(conversationsProvider.notifier)
        ..addOrUpdate(conversation)
        ..addLastMessage(message);

      // referencedTransaction = null;
      _messageTextController.clear();
      await _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(e.response!.data['errors'].values.first.first.toString())),
      );
    }
  }
}
