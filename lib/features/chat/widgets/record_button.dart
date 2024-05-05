import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class RecordButton extends StatefulWidget {
  /// function reture the recording sound file
  final Function(File soundFile) onSubmit;

  // ignore: sort_constructors_first
  const RecordButton({
    required this.onSubmit,
    super.key,
  });

  @override
  State<RecordButton> createState() => _RecordButton();
}

class _RecordButton extends State<RecordButton> {
  late SoundRecordNotifier soundRecordNotifier;

  @override
  void initState() {
    soundRecordNotifier = SoundRecordNotifier();
    soundRecordNotifier.isShow = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => soundRecordNotifier,
        ),
      ],
      child: Consumer<SoundRecordNotifier>(
        builder: (context, value, _) {
          return Directionality(
            textDirection: Directionality.of(context) == TextDirection.rtl ? TextDirection.ltr : TextDirection.rtl,
            child: makeBody(value),
          );
        },
      ),
    );
  }

  Widget makeBody(SoundRecordNotifier state) {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragUpdate: (scrollEnd) {
            state.updateScrollValue(scrollEnd.globalPosition, context);
          },
          child: recordVoice(state),
        )
      ],
    );
  }

  Widget recordVoice(SoundRecordNotifier state) {
    if (state.lockScreenRecord == true) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FloatingActionButton(
                  elevation: 0,
                  heroTag: const Key('submit-record'),
                  mini: true,
                  onPressed: () async {
                    soundRecordNotifier.isShow = false;

                    if (soundRecordNotifier.second >= 1 || soundRecordNotifier.minute > 0) {
                      String path = await state.stop();
                      widget.onSubmit(File.fromUri(Uri(path: path)));
                    }

                    soundRecordNotifier.resetEdgePadding();
                  },
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                  ),
                ),
                FloatingActionButton(
                  elevation: 0,
                  heroTag: const Key('cancel-record'),
                  mini: true,
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.delete_outlined,
                    // color: Colors.white,
                  ),
                  onPressed: () {
                    soundRecordNotifier.isShow = false;
                    soundRecordNotifier.resetEdgePadding();
                  },
                ),
              ],
            ),
            ShowCounter(
              soundRecorderState: soundRecordNotifier,
            ),
          ],
        ),
      );
    }

    final colorizeColors = [
      Theme.of(context).colorScheme.onSurface,
      Theme.of(context).colorScheme.onSurface.withOpacity(.2),
      Theme.of(context).colorScheme.onSurface,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 14.0,
      fontFamily: 'Horizon',
    );

    return Listener(
      onPointerDown: (details) async {
        state.setNewInitialDraggableHeight(details.position.dy);
        state.resetEdgePadding();
        state.record();
      },
      onPointerUp: (details) async {
        if (!state.isLocked) {
          if (state.buttonPressed) {
            if (state.second > 1 || state.minute > 0) {
              String path = await state.stop();
              widget.onSubmit(File.fromUri(Uri(path: path)));
            }

            state.resetEdgePadding();
          }
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: soundRecordNotifier.isShow ? 0 : 1),
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        width: soundRecordNotifier.isShow ? MediaQuery.of(context).size.width : 48,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: state.edge),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    key: state.key,
                    elevation: 0,
                    heroTag: const Key('submit-recrod'),
                    mini: true,
                    onPressed: null,
                    child: const Icon(
                      Icons.mic,
                    ),
                  ),
                  if (soundRecordNotifier.isShow) ...[
                    DefaultTextStyle(
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            AppLocalizations.of(context)!.swipeToCancel,
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ],
                        isRepeatingAnimation: true,
                      ),
                    ),
                    ShowCounter(
                      soundRecorderState: state,
                    )
                  ],
                ],
              ),
              SizedBox(
                width: 48,
                child: LockRecord(soundRecorderState: state),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This Class Represent Icons To swap top to lock recording
class LockRecord extends StatefulWidget {
  /// Object From Provider Notifier
  final SoundRecordNotifier soundRecorderState;

  // ignore: sort_constructors_first
  const LockRecord({
    required this.soundRecorderState,
    super.key,
  });

  @override
  State<LockRecord> createState() => _LockRecordState();
}

class _LockRecordState extends State<LockRecord> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    /// If click the Button Then send show lock and un lock icon
    if (!widget.soundRecorderState.buttonPressed) return Container();

    return AnimatedOpacity(
      opacity: widget.soundRecorderState.showLock ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Transform.translate(
        offset: Offset(
          0,
          (48 - widget.soundRecorderState.heightPosition < 0) ? -70 : -(widget.soundRecorderState.heightPosition + 70),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          opacity: widget.soundRecorderState.edge >= 48 ? 0 : 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade50,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    opacity: widget.soundRecorderState.second % 2 != 0 ? 0 : 1,
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 28,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    opacity: widget.soundRecorderState.second % 2 == 0 ? 0 : 1,
                    child: const Icon(
                      Icons.lock_open_rounded,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Used this class to show counter and mic Icon
class ShowCounter extends StatelessWidget {
  final SoundRecordNotifier soundRecorderState;

  // ignore: sort_constructors_first
  const ShowCounter({
    required this.soundRecorderState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${soundRecorderState.second.toString().padLeft(2, '0')} : ${soundRecorderState.minute.toString().padLeft(2, '0')}",
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(width: 8),
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: soundRecorderState.second % 2 == 0 ? 1 : 0,
          child: const Icon(
            Icons.circle,
            color: Colors.red,
            size: 12,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class SoundRecordNotifier extends ChangeNotifier {
  GlobalKey key = GlobalKey();

  /// This Timer Just For wait about 1 second until starting record
  Timer? _timer;

  /// This time for counter wait about 1 send to increase counter
  Timer? _timerCounter;

  /// Use last to check where the last draggable in X
  double last = 0;

  /// recording mp3 sound Object
  Record recordMp3 = Record();

  /// used to update state when user draggable to the top state
  double currentButtonHeihtPlace = 0;

  /// used to know if isLocked recording make the object true
  /// else make the object isLocked false
  bool isLocked = false;

  /// used to know if isLocked recording make the object true
  /// else make the object isLocked false
  bool showLock = false;

  /// when pressed in the recording mic button convert change state to true
  /// else still false
  bool isShow = false;

  /// to show second of recording
  late int second;

  /// to show minute of recording
  late int minute;

  /// to know if pressed the button
  late bool buttonPressed;

  /// used to update space when dragg the button to left
  late double edge;
  late bool loopActive;

  /// store final path where user need store mp3 record
  late bool startRecord;

  /// store the value we draggble to the top
  late double heightPosition;

  /// store status of record if lock change to true else
  /// false
  late bool lockScreenRecord;

  final lockDuration = const Duration(seconds: 2);

  SoundRecordNotifier({
    this.edge = 0.0,
    this.minute = 0,
    this.second = 0,
    this.buttonPressed = false,
    this.loopActive = false,
    this.startRecord = false,
    this.heightPosition = 0,
    this.lockScreenRecord = false,
  });

  /// To increase counter after 1 sencond
  void _mapCounterGenerater() {
    _timerCounter = Timer(const Duration(seconds: 1), () {
      _increaseCounterWhilePressed();
      _mapCounterGenerater();
    });
  }

  /// used to reset all value to initial value when end the record
  void resetEdgePadding() async {
    isLocked = false;
    showLock = false;
    edge = 0;
    buttonPressed = false;
    second = 0;
    minute = 0;
    isShow = false;
    key = GlobalKey();
    heightPosition = 0;
    lockScreenRecord = false;
    if (_timer != null) _timer!.cancel();
    if (_timerCounter != null) _timerCounter!.cancel();
    await stop();
    notifyListeners();
  }

  Future<String> stop() async => (await recordMp3.stop())!;

  /// used to change the draggable to top value
  void setNewInitialDraggableHeight(double newValue) {
    currentButtonHeihtPlace = newValue;
  }

  /// used to change the draggable to top value
  /// or To The X vertical
  /// and update this value in screen
  void updateScrollValue(Offset currentValue, BuildContext context) async {
    if (buttonPressed == true) {
      final x = currentValue;

      /// take the diffrent between the origin and the current
      /// draggable to the top place

      if (showLock) {
        double hightValue = currentButtonHeihtPlace - x.dy;

        /// if reached to the max draggable value in the top
        if (hightValue >= 32) {
          isLocked = true;
          showLock = false;
          lockScreenRecord = true;
          hightValue = 32;
          notifyListeners();
        }

        if (hightValue < 0) hightValue = 0;
        heightPosition = hightValue;
        lockScreenRecord = isLocked;
        notifyListeners();
      }

      /// this operation for update X oriantation
      /// draggable to the left or right place
      try {
        RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);

        if (Directionality.of(context) == TextDirection.ltr) {
          if (position.dx <= MediaQuery.of(context).size.width * 0.7) {
            resetEdgePadding();
          } else if (x.dx >= MediaQuery.of(context).size.width) {
            edge = 0;
            edge = 0;
          } else {
            if (x.dx <= MediaQuery.of(context).size.width * 0.8) {}
            if (last < x.dx) {
              edge = edge -= x.dx / 200;
              if (edge < 0) {
                edge = 0;
              }
            } else if (last > x.dx) {
              edge = edge += x.dx / 200;
            }
            last = x.dx;
          }
        } else {
          if (position.dx >= MediaQuery.of(context).size.width * 0.2) {
            resetEdgePadding();
          } else if (x.dx >= MediaQuery.of(context).size.width) {
            edge = 0;
            edge = 0;
          } else {
            if (x.dx <= MediaQuery.of(context).size.width * 0.8) {}
            if (last > x.dx) {
              edge = edge -= x.dx / 50;
              if (edge < 0) {
                edge = 0;
              }
            } else if (last < x.dx) {
              edge = edge += x.dx / 50;
            }
            last = x.dx;
          }
        }
        // ignore: empty_catches
      } catch (e) {}
      notifyListeners();
    }
  }

  /// this function to manage counter value
  /// when reached to 60 sec
  /// reset the sec and increase the min by 1
  void _increaseCounterWhilePressed() {
    if (loopActive) {
      return;
    }

    loopActive = true;

    second = second + 1;
    buttonPressed = buttonPressed;
    if (second == 60) {
      second = 0;
      minute = minute + 1;
    }

    if (second >= lockDuration.inSeconds) showLock = true;

    notifyListeners();
    loopActive = false;
    notifyListeners();
  }

  /// this function to start record voice
  void record() async {
    if (!await recordMp3.hasPermission()) {
      await [
        Permission.microphone,
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();
    } else {
      isShow = true;
      buttonPressed = true;
      _timer = Timer(const Duration(milliseconds: 300), recordMp3.start);
      _mapCounterGenerater();
      notifyListeners();
    }
    notifyListeners();
  }
}
