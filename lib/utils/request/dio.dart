import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:mall_community/common/appConfig.dart';
import 'package:mall_community/utils/request/Response.dart';
import 'package:mall_community/utils/request/config.dart';

import 'InterceptorsWrapper.dart';

class ApiClient {
  static ApiClient? _instance;

  late dio.Dio _dio;
  factory ApiClient({String? baseUrl}) {
    baseUrl ??= AppConfig.baseUrl;
    _instance ??= ApiClient._internal(baseUrl);
    return _instance!;
  }

  ApiClient._internal(String url) {
    _dio = dio.Dio();
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.timeoutSeconds;

    // 配置代理
    // _dio.httpClientAdapter = IOHttpClientAdapter(
    //   createHttpClient: () {
    //     final client = HttpClient();
    //     client.findProxy = (uri) {
    //       return 'PROXY 192.168.111.161:8899';
    //     };
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //     return client;
    //   },
    // );

    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(dio.LogInterceptor(
      responseBody: false,
      requestBody: false,
      requestHeader: false,
      responseHeader: false,
      request: false,
    ));
  }

  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? query,
    String? baseUrl,
  }) async {
    try {
      _dio.options.baseUrl = baseUrl ?? AppConfig.baseUrl;
      final response = await _dio.get(url, queryParameters: query);
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ApiResponse<T>> post<T>(
    String url, {
    dynamic data,
    String? baseUrl,
  }) async {
    try {
      _dio.options.baseUrl = baseUrl ?? AppConfig.baseUrl;
      final response = await _dio.post(url, data: data);
      return ApiResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ApiResponse<T>> put<T>(
    String url, {
    dynamic data,
    String? baseUrl,
  }) async {
    try {
      final response = await _dio.put(url, data: data);
      _dio.options.baseUrl = baseUrl ?? AppConfig.baseUrl;
      return ApiResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String url, {
    dynamic data,
    String? baseUrl,
  }) async {
    try {
      _dio.options.baseUrl = baseUrl ?? AppConfig.baseUrl;
      final response = await _dio.delete(url, data: data);
      return ApiResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  /// 上传文件
  Future<ApiResponse<T>> uploadFile<T>(dio.MultipartFile file,
      {String type = 'video'}) async {
    try {
      final formData = dio.FormData.fromMap({
        'name': 'iFile',
        'date': DateTime.now().toIso8601String(),
        'iFile': file
      });
      String url = '/api/file.upload/video';
      if (type == 'image') {
        url = '/shop/v1/file.upload/image';
      }
      _dio.options.baseUrl = AppConfig.baseUrl;
      final response = await _dio.post(url, data: formData);
      return ApiResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  /// 文件下载
  Future<File> downloadFile<T>(String url) async {
    try {
      String savePath = '${Directory.systemTemp.path}/${url.split('/').last}';
      await dio.Dio().download(url, savePath,
          options: dio.Options(
            responseType: dio.ResponseType.bytes,
          ));
      return File(savePath);
    } catch (error) {
      throw error;
    }
  }
}
