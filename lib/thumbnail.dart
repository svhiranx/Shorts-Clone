import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortsclone/provider.dart';
import 'package:shortsclone/scroll_screen.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    var video =
        Provider.of<VideoProvider>(context, listen: false).videos[index];

    return GestureDetector(
        key: ValueKey(video.postId),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ScrollScreen(initialIndex: index)),
          );
          log(index.toString() + 'thumbnail index');
          Provider.of<PageProvider>(context, listen: false).currentVideo =
              index;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(video.thumbnail),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: <Color>[
              //         Colors.black,
              //         Colors.transparent,
              //       ],
              //       tileMode: TileMode.mirror,
              //     ),
              //   ),
              //   width: double.infinity,
              //   padding: const EdgeInsets.only(left: 5, top: 5),
              //   child: Text(
              //     overflow: TextOverflow.ellipsis,
              //     video.title,
              //     style: const TextStyle(color: Colors.white),
              //   ),
              // ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.black,
                    Colors.transparent,
                  ],
                  tileMode: TileMode.mirror,
                )),
                child: Column(
                  children: [
                    Row(
                      key: ValueKey(video.creator.id),
                      children: [
                        CircleAvatar(
                          radius: 7,
                          backgroundImage: NetworkImage(video.creator.pic!),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            video.creator.handle,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
