import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreen extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoFullScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  late ChewieController _chewieController;

 @override
  void initState() {
   _chewieController = ChewieController(
     allowedScreenSleep: false,
     allowFullScreen: true,
     deviceOrientationsAfterFullScreen: [
       DeviceOrientation.landscapeRight,
       DeviceOrientation.landscapeLeft,
       DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
     ],
     videoPlayerController: widget.controller,
     aspectRatio: widget.controller.value.aspectRatio,
     autoInitialize: true,
     autoPlay: true,
     showControls: true,
   );

   _chewieController.addListener(() {
     if (_chewieController.isFullScreen) {
       SystemChrome.setPreferredOrientations([
         DeviceOrientation.landscapeRight,
         DeviceOrientation.landscapeLeft,
       ]);
     } else {
       SystemChrome.setPreferredOrientations([
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown,
       ]);
     }
   });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
