import 'dart:io';

import 'package:tiko/data/data_source/archive_data_source.dart';

abstract class IArchiveRepository {
  Future<Iterable<FileSystemEntity>> getFiles();
}

class ArchiveRepositoryImple implements IArchiveRepository {
  final IArchiveDataSource dataSource;

  ArchiveRepositoryImple(this.dataSource);
  @override
  Future<Iterable<FileSystemEntity>> getFiles() async {
    final files = await dataSource.getFiles();
    return files;
  }
}
