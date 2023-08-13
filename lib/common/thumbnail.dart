import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailGenerator extends Equatable {
  late final File file;
  static Future<File> generateThumbnail(File file) async {
    final String? path = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: (await getTemporaryDirectory()).path,

      /// path_provider
      imageFormat: ImageFormat.PNG,
      quality: 5,
    );
    return File(path!);
  }

  @override
  List<Object?> get props => [file];
}
