import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailGenerator {
  static Future<String> generateThumbnail(String path) async {
    final String? newpath = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,

      /// path_provider
      imageFormat: ImageFormat.PNG,
      quality: 5,
    );
    return newpath!;
  }
}
