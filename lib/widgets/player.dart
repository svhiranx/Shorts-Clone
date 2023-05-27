import 'package:provider/provider.dart';
import 'package:shortsclone/models/provider.dart';
import 'package:shortsclone/widgets/scrolling_ui_overlay.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.index, required this.ratio});

  final int index;
  final double ratio;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  bool isInit = false;
  @override
  void initState() {
    super.initState();
    var video =
        Provider.of<VideoProvider>(context, listen: false).videos[widget.index];
    videoController = VideoPlayerController.network(video.mediaUrl);
    // .asset('assets/video.mp4');
    chewieController = ChewieController(
      showControlsOnInitialize: false,
      aspectRatio: widget.ratio,
      showControls: false,
      showOptions: true,
      placeholder: Positioned.fill(
          child: FittedBox(
        fit: BoxFit.cover,
        child: Center(child: Image.network(video.thumbnail)),
      )),
      errorBuilder: (context, errorMessage) {
        log(errorMessage);
        return const Positioned.fill(
            child: Center(
          child: Text(
            'Sorry an error occured :(',
            style: TextStyle(color: Colors.white),
          ),
        ));
      },
      overlay: UIOverlay(video: video),
      autoInitialize: true,
      autoPlay: false,
      looping: true,
      videoPlayerController: videoController!,
    );
    videoController!.addListener(() {
      if (isInit) {
        return;
      } else {
        setState(() {
          isInit = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoController?.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<PageProvider>(context, listen: true);
    if (videoController!.value.isInitialized) {
      if (pageProvider.currentVideo == widget.index) {
        videoController!.play();
      } else {
        videoController!.pause();
      }
    }

    return Positioned.fill(
      child: GestureDetector(
        onTap: () => log(widget.index.toString()),
        child: Chewie(
          controller: chewieController!,
        ),
      ),
    );
  }
}
