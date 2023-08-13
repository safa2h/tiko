import 'package:path_provider/path_provider.dart';

Future<bool> get getFile async {
  final directory = await getExternalStorageDirectory();

  return directory!.path.endsWith('.mp4');
  // print(path);
  // return File('$path/fileCreated.mp4');
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String toMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}








// Future<File> write_string(String counter) async {
//   final file = await getFile;
//   try {
//     return await file.writeAsString(counter);
//   } catch (e) {
//     print(e.toString());
//     return file.writeAsString('dsf');
//   }
// }

// Future<String> readString() async {
//   final file = await getFile;
//   try {
//     return await file.readAsString();
//   } catch (e) {
//     print(e.toString());
//     return file.readAsString();
//   }
// }

