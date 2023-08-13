import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class IArchiveDataSource {
  Future<List<dynamic>> getFiles();
}

class ArchiveLocalDataSourceImple implements IArchiveDataSource {
  @override
  Future<List> getFiles() async {
    List file = [];
    String? directory = (await getExternalStorageDirectory())!.path;

    file = Directory(directory)
        .listSync(); //use your folder name insted of resume.
    return file;
  }
}
