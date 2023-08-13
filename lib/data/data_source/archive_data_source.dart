import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class IArchiveDataSource {
  Future<Iterable<FileSystemEntity>> getFiles();
}

class ArchiveLocalDataSourceImple implements IArchiveDataSource {
  @override
  Future<Iterable<FileSystemEntity>> getFiles() async {
    final directory = Directory((await getExternalStorageDirectory())!.path);

    return directory.listSync().where((file) => file.path.endsWith('.mp4'));
  }
}
