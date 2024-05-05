import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clip/clip.dart';
import 'package:ebn_balady/features/chat/widgets/video_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:just_audio/just_audio.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/utils/screen_util.dart';
import '../models/message.dart';
import 'message_audio_player.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final DefaultCacheManager _cacheManager;

  MessageBubble(this.message, {super.key})
      : _cacheManager = DefaultCacheManager();

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    final alignment = widget.message.isSender!
        ? AlignmentDirectional.topEnd
        : AlignmentDirectional.topStart;
    final nip = Directionality.of(context) == TextDirection.rtl
        ? (widget.message.isSender! ? BubbleNip.leftTop : BubbleNip.rightTop)
        : (widget.message.isSender! ? BubbleNip.rightTop : BubbleNip.leftTop);
    final margin = EdgeInsetsDirectional.only(
      start: widget.message.isSender! ? 56 : 0,
      end: widget.message.isSender! ? 0 : 56,
    );
    final color = (widget.message.isSender!
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.onSurface.withOpacity(.7));
    final textColor = (widget.message.isSender!
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.surface);
    final timeTextColor = (widget.message.isSender!
        ? Theme.of(context).colorScheme.onSurface.withOpacity(.6)
        : Theme.of(context).colorScheme.surface.withOpacity(.6));

    switch (widget.message.type!) {
      case MessageType.image:
        return Container(
          margin: margin,
          child: GestureDetector(
            child: Bubble(
              padding: const BubbleEdges.all(4.0),
              margin: const BubbleEdges.symmetric(vertical: 2.0),
              color: color,
              alignment: alignment,
              nip: nip,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 2,
                      minWidth: MediaQuery.of(context).size.width / 2,
                    ),
                    child: widget.message.body is String
                        ? CachedNetworkImage(
                            imageUrl: widget.message.body,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            widget.message.body,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.jm().format(widget.message.createdAt!),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: timeTextColor, letterSpacing: 1, height: 2),
                  ),
                ],
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) =>
                      GalleryPage(attachments: [widget.message.body])),
            ),
          ),
        );

      case MessageType.audio:
        return GestureDetector(
          onTap: () {
            //
          },
          child: Container(
            margin: margin,
            child: Bubble(
              padding: const BubbleEdges.all(4.0),
              margin: const BubbleEdges.symmetric(vertical: 2.0),
              color: color,
              alignment: alignment,
              nip: nip,
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      SizedBox(
                        height: 56,
                        child: MessageAudioPlayer(
                          key: ValueKey(widget.message.id),
                          source: ((widget.message.body is File
                                  ? Future<File>.value(widget.message.body)
                                  : widget._cacheManager
                                      .getSingleFile(widget.message.body)))
                              .then<AudioSource>(
                            (File value) =>
                                AudioSource.uri(Uri.parse(value.path)),
                          ),
                          color: textColor,
                        ),
                      ),
                      Text(
                        DateFormat.jm().format(widget.message.createdAt!),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: timeTextColor, letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

      case MessageType.text:
        return GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: widget.message.body));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.textCopiedToClipboard),
              ),
            );
          },
          child: Container(
            margin: margin,
            child: Bubble(
              alignment: alignment,
              nip: nip,
              color: color,
              padding: const BubbleEdges.all(4.0),
              margin: const BubbleEdges.symmetric(vertical: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (widget.message.referencedTransaction != null) ...[
                  //   Container(
                  //     height: 100,
                  //     width: ScreenUtil.screenWidth * .6,
                  //     decoration: BoxDecoration(
                  //         color: Theme.of(context)
                  //             .colorScheme
                  //             .onSurface
                  //             .withOpacity(.1),
                  //         borderRadius: BorderRadius.circular(8.0)),
                  //     child: Container(
                  //       margin: const EdgeInsets.all(4),
                  //       decoration: BoxDecoration(
                  //           color: Theme.of(context).colorScheme.surface,
                  //           borderRadius: BorderRadius.circular(8.0)),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           if (widget.message.referencedTransaction!.thumb
                  //               .isNotEmpty) ...[
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
                  //                     widget
                  //                         .message.referencedTransaction!.thumb,
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
                  //                   widget.message.referencedTransaction!.type
                  //                       .name,
                  //                   style:
                  //                       Theme.of(context).textTheme.subtitle1,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 4,
                  //                 ),
                  //                 Text(
                  //                   "${NumberFormat("###,###").format(widget.message.referencedTransaction!.gross)} ${widget.message.referencedTransaction!.currency.symbol}",
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
                  //                   DateFormat('yyyy-MM-dd').format(widget
                  //                       .message.referencedTransaction!.time),
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
                  //           ))
                  //         ],
                  //       ),
                  //     ),
                  //   )
                  // ],
                  Linkify(
                    text: widget.message.body,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: textColor),
                    linkifiers: const [
                      ...defaultLinkifiers,
                    ],
                    linkStyle: TextStyle(
                      color: textColor,
                      decoration: TextDecoration.underline,
                    ),
                    onOpen: (link) {
                      try {
                        launch(link.url);
                      } catch (_) {}
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.jm().format(widget.message.createdAt!),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: timeTextColor, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ),
        );

      case MessageType.video:
        return GestureDetector(
          onTap: () {
            //
          },
          child: Container(
            margin: margin,
            child: Bubble(
              padding: const BubbleEdges.all(4.0),
              margin: const BubbleEdges.symmetric(vertical: 2.0),
              color: color,
              alignment: alignment,
              nip: nip,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      VisibilityDetector(
                        key: ObjectKey(_controller),
                        onVisibilityChanged: (visibility) {
                          if (visibility.visibleFraction > 0 && mounted) {
                            initVideoPlayer();
                          } else {}
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: ScreenUtil.screenWidth * .7,
                              minHeight: ScreenUtil.screenHeight * .2,
                              maxHeight: ScreenUtil.screenHeight * .5),
                          child: _controller?.value.isInitialized ?? false
                              ? AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(
                                        _controller!,
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional.center,
                                        child: FloatingActionButton(
                                          backgroundColor:
                                              _controller!.value.isPlaying
                                                  ? Colors.transparent
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(.4),
                                          elevation: 0,
                                          onPressed: () {
                                            setState(() {
                                              _controller!.value.isPlaying
                                                  ? _controller!.pause()
                                                  : _controller!.play();
                                            });
                                          },
                                          child: Icon(
                                            _controller!.value.isPlaying
                                                ? null
                                                : Icons.play_arrow,
                                            color: _controller!.value.isPlaying
                                                ? Colors.transparent
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                    .withOpacity(.4),
                                          ),
                                        ),
                                      ),
                                      if (_controller!.value.isPlaying) ...[
                                        Align(
                                          alignment:
                                              AlignmentDirectional.bottomStart,
                                          child: IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                if (_controller!
                                                    .value.isPlaying) {
                                                  _controller!.pause();
                                                }
                                              });

                                              await Get.to(() =>
                                                  VideoFullScreen(
                                                    controller: _controller!,
                                                  ));

                                              setState(() {});
                                            },
                                            icon: Icon(
                                              Icons.fullscreen,
                                              color:
                                                  _controller!.value.isPlaying
                                                      ? Colors.grey
                                                      : Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: ScreenUtil.screenWidth * .7,
                                  height: ScreenUtil.screenHeight * .5,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          DateFormat.jm().format(widget.message.createdAt!),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

      default:
        return Container();
    }
  }

  Future<void> initVideoPlayer() async {
    setState(() {});

    if (widget.message.type == MessageType.video) {
      _controller ??= VideoPlayerController.file((widget.message.body is File
          ? widget.message.body
          : await widget._cacheManager.getSingleFile(widget.message.body)));
      if (_controller != null &&
          !_controller!.value.isInitialized &&
          !_controller!.value.isBuffering) {
        await _controller!.initialize();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }
}
