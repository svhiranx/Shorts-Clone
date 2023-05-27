import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shortsclone/models/provider.dart';
import 'package:shortsclone/widgets/player.dart';

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
      body: Stack(
        children: [
          videoProvider.isInternetLost
              ? const Center(
                  child: Text(
                    ' No internet connection ❌',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : PreloadPageView.builder(
                  preloadPagesCount: 3,
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  itemCount: videoProvider.videos.length,
                  onPageChanged: (value) {
                    pageProvider.currentVideo = value;
                  },
                  itemBuilder: (context, index) {
                    var ratio = MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height;

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
                  }),
          const Positioned(
              top: 50,
              left: 10,
              child: SizedBox(
                child: BackButton(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
