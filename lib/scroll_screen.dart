import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shortsclone/provider.dart';
import 'package:shortsclone/video.dart';
import 'package:video_player/video_player.dart';

class ScrollScreen extends StatefulWidget {
  const ScrollScreen({super.key, required this.initialIndex});
  final int initialIndex;

  @override
  State<ScrollScreen> createState() => _ScrollScreenState();
}

class _ScrollScreenState extends State<ScrollScreen> {
  PreloadPageController? _controller;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _controller = PreloadPageController(initialPage: widget.initialIndex);
    _controller!.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller!.position.pixels == _controller!.position.maxScrollExtent) {
      Provider.of<VideoProvider>(context, listen: false).fetchPaginatedVideos();
      log('max reached');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var videoProvider = Provider.of<VideoProvider>(context);
    var pageProvider = Provider.of<PageProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: PreloadPageView.builder(
          preloadPagesCount: 3,
          controller: _controller,
          scrollDirection: Axis.vertical,
          itemCount: videoProvider.videos.length,
          onPageChanged: (value) {
            pageProvider.currentVideo = value;
            log('${value}actual value');
          },
          itemBuilder: (context, index) {
            var ratio = MediaQuery.of(context).size.width /
                MediaQuery.of(context).size.height;
            return StreamBuilder(
                stream: InternetConnectionChecker().onStatusChange,
                builder: (context, snapshot) {
                  switch (snapshot.data) {
                    case InternetConnectionStatus.disconnected:
                      return Expanded(
                          key: ValueKey(videoProvider.videos[index]),
                          child: Center(
                            child: Text(
                              ' No internet connection ❌',
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                    case null:
                    case InternetConnectionStatus.connected:
                      return Column(
                        key: ValueKey(videoProvider.videos[index]),
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Player(index: index, ratio: ratio),
                                if (videoProvider.isLoading)
                                  Column(
                                    children: [
                                      const Spacer(),
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const LinearProgressIndicator(
                                            color: Colors.black,
                                          ))
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ],
                      );
                  }
                });
          }),
    );
  }
}

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
    // TODO: implement initState
    super.initState();
    var video =
        Provider.of<VideoProvider>(context, listen: false).videos[widget.index];
    videoController = VideoPlayerController.network(video.mediaUrl);
    // .network(video.mediaUrl);
    //

    // VideoPlayerController.network(widget.video.mediaUrl);

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
        return Positioned.fill(
            child: Center(
          child: Text(
            errorMessage,
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
    // TODO: implement dispose
    super.dispose();
    videoController?.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<PageProvider>(context, listen: true);
    log('${pageProvider.currentVideo}  :${widget.index} ');
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

class UIOverlay extends StatelessWidget {
  const UIOverlay({
    super.key,
    required this.video,
  });

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                Icon(
                  Icons.emoji_emotions_outlined,
                  size: 40,
                  color: Colors.grey.shade300,
                ),
                Text(
                  video.reaction.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Icon(
                  video.commentAllowed
                      ? Icons.insert_comment_outlined
                      : Icons.comments_disabled_outlined,
                  size: 40,
                  color: Colors.grey.shade300,
                ),
                Text(
                  video.comments.toString(),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          userAndDescription(context),
        ],
      ),
    );
  }

  Container userAndDescription(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            Colors.black,
            Colors.transparent,
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                video.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(video.creator.pic!),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                video.creator.handle,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, bottom: 40),
              width: MediaQuery.of(context).size.width,
              child: ReadMoreText(
                style: TextStyle(
                  color: Colors.grey.shade300,
                ),
                colorClickableText: Colors.blue,
                video.description,
                trimMode: TrimMode.Line,
                trimLines: 2,
              )),
        ],
      ),
    );
  }
}
