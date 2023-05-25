import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
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
    var pageProvider = Provider.of<PageProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PreloadPageView.builder(
            preloadPagesCount: 3,
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: videoProvider.videos.length,
            onPageChanged: (value) {
              log(value.toString());
              pageProvider.currentVideo = value;
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Positioned.fill(
                        //   child: Image.network(
                        //       fit: BoxFit.fitHeight, video.thumbnail),
                        // ),

                        Player(
                          index: index,
                          video: videoProvider.videos[index],
                        ),

                        if (videoProvider.isLoading)
                          Column(
                            children: [
                              const Spacer(),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
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
            }),
      ),
    );
  }
}

class Player extends StatefulWidget {
  const Player({super.key, required this.video, required this.index});

  final Video video;
  final int index;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController = VideoPlayerController.network(widget.video.mediaUrl);
    chewieController = ChewieController(
      aspectRatio: videoController!.value.aspectRatio / 2.1,
      showControls: true,
      showOptions: false,
      overlay: UIOverlay(video: widget.video),
      autoInitialize: true,
      autoPlay: false,
      looping: true,
      videoPlayerController: videoController!,
    );
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
    var pageProvider = Provider.of<PageProvider>(context);

    if (videoController!.value.isInitialized) {
      log('${pageProvider.currentVideo} ${widget.index}');
      if (pageProvider.currentVideo == widget.index) {
        videoController!.play();
      } else {
        videoController!.pause();
      }
      videoController!.setLooping(true);
    }

    return Positioned.fill(
      child: Chewie(
        controller: chewieController!,
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
      bottom: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
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

  Column userAndDescription(BuildContext context) {
    return Column(
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
              ),
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
            padding: const EdgeInsets.only(left: 10),
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
    );
  }
}
