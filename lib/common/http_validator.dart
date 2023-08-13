import 'package:dio/dio.dart';
import 'package:tiko/common/exception.dart';

mixin HttpValidator {
  void responseValidator(Response response) {
    if (response.statusCode != 200) {
      throw AppException('خطایی رخ داده است');
    }
  }
}
