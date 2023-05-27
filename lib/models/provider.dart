import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shortsclone/api_service.dart';
import 'package:shortsclone/models/video.dart';

class VideoProvider extends ChangeNotifier {
  int apiPage = 0;

  bool isLoading = false;
  bool isInitialFetch = true;
  bool _isInternetLost = false;
  final List<Video> _videos = [];

  VideoProvider() {
    InternetConnectionChecker().onStatusChange.listen((event) async {
      if (event == InternetConnectionStatus.disconnected) {
        isInternetLost = true;
      }
      if (event == InternetConnectionStatus.connected) {
        if (_videos.isEmpty) {
          isInitialFetch = true;
          isInternetLost = false;
          await fetchPaginatedVideos();
        } else {
          isInternetLost = false;
        }
      }
    });
  }

  List<Video> get videos => _videos;

  set isInternetLost(bool boolean) {
    _isInternetLost = boolean;
    notifyListeners();
  }

  bool get isInternetLost => _isInternetLost;

  Future<void> fetchPaginatedVideos() async {
    if (isLoading || isInternetLost) return;

    log('video fetched');
    isLoading = true;
    notifyListeners();
    if (isInitialFetch) {
      apiPage = 0;
    }
    await VideosApi().getVideos(apiPage).then((response) {
      apiPage = apiPage + 1;
      for (var data in response.data["data"]["posts"]) {
        addvideoToList(Video.fromJson(data));
      }
    });
    if (isInitialFetch = true) isInitialFetch = false;
    isLoading = false;
    notifyListeners();
  }

  void addvideoToList(Video videoData) {
    _videos.add(videoData);
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
