import 'package:flutter/cupertino.dart';
import 'package:tiko/data/data_source/archive_data_source.dart';

abstract class IArchiveRepository {
  Future<List<dynamic>> getFiles();
}

class ArchiveRepositoryImple implements IArchiveRepository {
  static ValueNotifier<List<dynamic>> fileNotifier = ValueNotifier([]);
  final IArchiveDataSource dataSource;

  ArchiveRepositoryImple(this.dataSource);
  @override
  Future<List> getFiles() async {
    final files = await dataSource.getFiles();
    fileNotifier.value = files;
    return files;
  }
}
