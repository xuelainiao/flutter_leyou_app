import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/components/not_data/not_data.dart';
import 'package:mall_community/utils/request/dio_response.dart';
import 'package:mall_community/utils/request/config.dart';
import 'package:mall_community/utils/request/error_exception.dart';
import 'package:mall_community/utils/toast/toast.dart';

import 'interceptors_wrapper.dart';

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

  ///网络请求
  Future<ApiResponse<T>> request<T>({
    required String url,
    String method = 'get',
    dynamic data,
    dynamic query,
    String? baseUrl,
    Map<String, dynamic>? headers,
    dio.CancelToken? cancelToken,
    bool isLoad = false,
  }) async {
    try {
      if (isLoad) {
        ToastUtils.showLoad();
      }
      _dio.options.baseUrl = baseUrl ?? AppConfig.baseUrl;
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: query,
        options: dio.Options(method: method),
        cancelToken: cancelToken,
      );
      return ApiResponse.fromJson(response.data);
    } on dio.DioException catch (e) {
      if (isLoad) {
        ToastUtils.hideLoad();
      }
      throw e.error ??
          ApiError(code: NetWorkDataStatus.notNetworkError, msg: "请求错误");
    } catch (e) {
      if (isLoad) {
        ToastUtils.hideLoad();
      }
      throw ApiError(
          code: NetWorkDataStatus.notNetworkError, msg: e.toString());
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
    } on dio.DioException catch (e) {
      throw e.error ??
          ApiError(code: NetWorkDataStatus.notNetworkError, msg: "请求错误");
    } catch (e) {
      throw ApiError(
          code: NetWorkDataStatus.notNetworkError, msg: e.toString());
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
    } on dio.DioException catch (e) {
      throw e.error ??
          ApiError(code: NetWorkDataStatus.notNetworkError, msg: "请求错误");
    } catch (e) {
      throw ApiError(
          code: NetWorkDataStatus.notNetworkError, msg: e.toString());
    }
  }
}
