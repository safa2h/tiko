import 'package:tiko/common/http_service.dart';
import 'package:tiko/common/http_validator.dart';
import 'package:tiko/data/data.dart';

abstract class IDataSource {
  Future<Data> getdata(String url);
  Future<void> downloadVideo(String url);
}

class DataSourceImple with HttpValidator implements IDataSource {
  final IHttpservice httpservice;

  DataSourceImple(this.httpservice);
  @override
  Future<Data> getdata(String url) async {
    final response = await httpservice.getRequest('analysis?url=$url&hd=0');
    responseValidator(response);
    return Data.fromJosn(response.data['data']);
  }

  @override
  Future<void> downloadVideo(String url) async {
    final response = await httpservice.getRequest('analysis?url=$url&hd=0');
    responseValidator(response);
    await httpservice.download(response.data['data']['play'],
        response.data['data']['size'], response.data['data']['title']);
  }
}
