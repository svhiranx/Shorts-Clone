import 'package:dio/dio.dart';

class VideosApi {
  String url = 'https://internship-service.onrender.com/videos';
  Future<Response> getVideos(int page) async {
    final response = await Dio().get(
      url,
      queryParameters: {'page': page},
    );
    return response;
  }
}
