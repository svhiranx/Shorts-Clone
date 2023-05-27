import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shortsclone/models/video.dart';

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
