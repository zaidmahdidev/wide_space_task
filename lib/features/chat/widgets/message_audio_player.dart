import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MessageAudioPlayer extends StatefulWidget {
  const MessageAudioPlayer({
    super.key,
    required this.source,
    required this.color,
  });

  final Future<AudioSource> source;
  final Color color;

  @override
  MessageAudioPlayerState createState() => MessageAudioPlayerState();
}

class MessageAudioPlayerState extends State<MessageAudioPlayer> {
  final _audioPlayer = AudioPlayer();
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  late Future<Duration?> futureDuration;

  @override
  void initState() {
    super.initState();
    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen(playerStateListener);
    futureDuration =
        widget.source.then((value) => _audioPlayer.setAudioSource(value));
  }

  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await reset();
    }
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Duration?>(
      future: futureDuration,
      builder: (context, snapshot) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(width: 4.0),
            _controlButtons(!snapshot.hasData),
            _slider(snapshot.data),
          ],
        );
      },
    );
  }

  Widget _controlButtons(bool isLoading) {
    return StreamBuilder<bool>(
      stream: _audioPlayer.playingStream,
      builder: (context, _) {
        if (isLoading) {
          return CircularPercentIndicator(
            radius: 12,
            animation: true,
            animationDuration: 1200,
            lineWidth: 2.0,
            percent: 1,
            restartAnimation: true,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(.5),
            progressColor: Theme.of(context).colorScheme.primary,
            center: GestureDetector(
              child: const Icon(Icons.close, size: 12),
              onTap: () {
                _audioPlayer.stop();
              },
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            if (_audioPlayer.playerState.playing) {
              pause();
            } else {
              play();
            }
          },
          child: Icon(
            _audioPlayer.playerState.playing
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            color: widget.color,
            size: 30,
          ),
        );
      },
    );
  }

  Widget _slider(Duration? duration) {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Slider(
            thumbColor: widget.color,
            value: duration != null
                ? snapshot.data!.inMicroseconds / duration.inMicroseconds
                : 0.0,
            onChanged: (val) {
              try {
                _audioPlayer.seek(duration! * val);
              } catch (_) {}
            },
          ),
        );
      },
    );
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }
}
