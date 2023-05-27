import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shortsclone/api_service.dart';
import 'package:shortsclone/video.dart';

class VideoProvider extends ChangeNotifier {
  int apiPage = 0;

  bool isLoading = false;
  bool _isInitialFetch = true;
  bool _isInternetLost = false;
  final List<Video> _videos = [];

  VideoProvider() {
    InternetConnectionChecker().onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.disconnected) {
        isInternetLost = true;
      }
      if (event == InternetConnectionStatus.connected) {
        if (videos == []) {
          isInitialFetch = true;
          fetchPaginatedVideos();
        }
        isLoading = false;
        isInitialFetch = false;
        isInternetLost = false;
      }
    });
  }

  List<Video> get videos => _videos;
  set isInitialFetch(bool boolean) {
    _isInitialFetch = boolean;
  }

  set isInternetLost(bool boolean) {
    _isInternetLost = boolean;
    notifyListeners();
  }

  bool get isInternetLost => _isInternetLost;
  bool get isInitialFetch => _isInitialFetch;

  Future<void> fetchPaginatedVideos() async {
    if (isLoading == true) return;

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
