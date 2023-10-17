import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiko/main.dart';

abstract class IHttpservice {
  Future<Response> getRequest(String endPoint);
  Future<void> download(String url, int size, String name);
  Future<void> downloadFile();
  Future<Response> post(String endPoint, Map<String, dynamic> data);
}

CancelToken cancelToken = CancelToken();

class HttpService implements IHttpservice {
  late Dio dio;

  HttpService() {
    dio = Dio(
      BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 120),
          baseUrl: ''),
    );
  }
  @override
  Future<Response> getRequest(String endPoint) async {
    Response response;

    try {
      response = await dio.get(endPoint, cancelToken: cancelToken);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      if (cancelToken.isCancelled) {
        cancelToken = CancelToken();
      }
      throw Exception(e.message);
    }

    return response;
  }

  @override
  Future<Response> post(String endPoint, Map<String, dynamic> data) async {
    Response response;

    try {
      response = await dio.post(endPoint, data: data, cancelToken: cancelToken);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      throw Exception(e.message);
    }
    if (cancelToken.isCancelled) {
      cancelToken = CancelToken();
    }

    return response;
  }

  Future<void> downloadFile() async {
    final directory = await getExternalStorageDirectory();
    final String fileName =
        '${directory!.path}/${DateTime.now().toString()}file.mp4';
    try {
      await dio.download(
        'https://static.videezy.com/system/resources/previews/000/037/813/original/WH038.mp4',
        fileName,
        onReceiveProgress: (rec, total) {
          //print((rec / total));
        },
      ).whenComplete(() {});
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      if (cancelToken.isCancelled) {
        cancelToken = CancelToken();
      }
      removeDownloadedVideo(videoPath: fileName);

      throw Exception(e.message);
    }
  }

  @override
  Future<void> download(String url, int size, String name) async {
    final directory = await getExternalStorageDirectory();
    final String fileName =
        '${directory!.path}/${DateTime.now().toString()}file.mp4';
    try {
      await dio.download(
        url,
        fileName,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) async {
          // print('progress ${(count / total) * 100}');
          String downloadName = ((count / total) * 100).toInt() == 100
              ? 'Completed'
              : 'Downloading';

          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'download_channel', 'Download Notifications',
              channelDescription:
                  'This channel is used for downloading notifications.',
              channelShowBadge: false,
              importance: Importance.max,
              priority: Priority.high,
              playSound: false,
              onlyAlertOnce: true,
              icon: 'ic_launcher',
              when: 100,
              enableVibration: false,
              maxProgress: 100,
              showProgress: true,
              progress: ((count / total) * 100).toInt());

          flutterLocalNotificationsPlugin.show(
              1,
              downloadName,
              name,
              NotificationDetails(
                android: androidPlatformChannelSpecifics,
              ));
        },
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        removeDownloadedVideo(videoPath: fileName);

        throw Exception("Connection  Timeout Exception");
      }
      if (cancelToken.isCancelled) {
        cancelToken = CancelToken();
      }
      removeDownloadedVideo(videoPath: fileName);

      throw Exception(e.message);
    }
  }
}

Future<void> saveDownloadedVideoToGallery({required String videoPath}) async {
  await ImageGallerySaver.saveFile(videoPath,
      name: "${DateTime.now().second}tiko");
}

Future<void> removeDownloadedVideo({required String videoPath}) async {
  return Directory(videoPath).deleteSync(recursive: true);
}
