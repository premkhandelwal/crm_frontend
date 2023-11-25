import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioBuilder {
  static Dio buildDioClient() {
    Dio dio = Dio();
    dio.interceptors.addAll([PrettyDioLogger()]);
    return dio;
  }
}
