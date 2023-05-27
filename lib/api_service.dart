import 'dart:developer';

import 'package:dio/dio.dart';

class VideosApi {
  String url = 'https://internship-service.onrender.com/videos';
  Future getVideos(int page) async {
    try {
      final response = await Dio().get(
        url,
        queryParameters: {'page': page},
      );
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        log('Timeout Error: $e');
      } else if (e.type == DioErrorType.badResponse) {
        log('Response Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      } else if (e.type == DioErrorType.cancel) {
        log('Request Cancelled: $e');
      } else {
        log('Dio Error: $e');
      }
      return [];
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }
}
