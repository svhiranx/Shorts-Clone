import 'package:shortsclone/creator.dart';

class Video {
  String postId;
  Creator creator;
  int comments;
  bool commentAllowed;
  int reaction;
  String title;
  String description;
  String mediaUrl;
  String thumbnail;
  String hyperlink;
  String placeholderUrl;

  Video(
      {required this.postId,
      required this.creator,
      required this.comments,
      required this.commentAllowed,
      required this.reaction,
      required this.title,
      required this.description,
      required this.mediaUrl,
      required this.thumbnail,
      required this.hyperlink,
      required this.placeholderUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> submission = json["submission"];
    return Video(
        postId: json["postId"],
        creator: Creator.fromJson(json["creator"]),
        comments: json["comment"]["count"],
        commentAllowed: json["comment"]["commentingAllowed"],
        reaction: json["reaction"]["count"],
        title: submission["title"],
        description: submission["description"],
        mediaUrl: submission["mediaUrl"],
        thumbnail: submission["thumbnail"],
        hyperlink: submission["hyperlink"],
        placeholderUrl: submission["placeholderUrl"]);
  }
}
