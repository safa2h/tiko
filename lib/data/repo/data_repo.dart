import 'package:dio/dio.dart';
import 'package:tiko/data/data.dart';
import 'package:tiko/data/data_source/data_source.dart';

abstract class IDataRepository {
  Future<Data> getdata(String url);
  Future<void> downloadVideo(String url);
}

class DataRepositoryImple implements IDataRepository {
  final IDataSource dataSource;

  DataRepositoryImple(this.dataSource);
  @override
  Future<Data> getdata(String url) {
    return dataSource.getdata(url);
  }

  @override
  Future<void> downloadVideo(String url) async {
    return dataSource.downloadVideo(url);
  }
}
