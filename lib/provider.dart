import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shortsclone/api_service.dart';
import 'package:shortsclone/video.dart';

class VideoProvider extends ChangeNotifier {
  int apiPage = 0;

  bool isLoading = false;

  final List<Video> _videos = [];

  List<Video> get videos => _videos;

  Future<void> fetchPaginatedVideos() async {
    if (isLoading == true) return;
    log('video fetched');
    isLoading = true;
    notifyListeners();
    await VideosApi().getVideos(apiPage).then((response) {
      apiPage = apiPage + 1;
      for (var data in response.data["data"]["posts"]) {
        addvideoToList(Video.fromJson(data));
      }
    });
    isLoading = false;
    notifyListeners();
  }

  void addvideoToList(Video videoData) {
    _videos.add(videoData);
    notifyListeners();
  }
}

class PageProvider with ChangeNotifier {
  int _currentVideo = 0;
  int get currentVideo => _currentVideo;

  set currentVideo(int currentVideo) {
    _currentVideo = currentVideo;
    notifyListeners();
  }
}
