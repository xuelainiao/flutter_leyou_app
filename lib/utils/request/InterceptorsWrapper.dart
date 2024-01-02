import 'package:dio/dio.dart' as dio;
// import 'package:mall_community/components/Confirmation/Confirmation.dart';
import 'package:mall_community/utils/request/Response.dart';
import 'package:mall_community/utils/toast/toast.dart';
import 'config.dart';

class LoggingInterceptor extends dio.InterceptorsWrapper {
  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    // options.headers['token'] = UserModule.token;

    if (options.method == 'GET' || options.method == 'PUT') {
      options.queryParameters ?? {};
      options.queryParameters['app_id'] = ApiConfig.appId;
      // options.queryParameters['token'] = UserModule.token;
    } else {
      if (options.data is Map) {
        options.data['app_id'] = ApiConfig.appId;
        // options.data['token'] = UserModule.token;
      } else if (options.data is dio.FormData) {
        options.data.fields.add(MapEntry('app_id', ApiConfig.appId.toString()));
        // options.data.fields.add(MapEntry('token', UserModule.token));
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    final apiResponse = ApiResponse.fromJson(response.data);
    String msg = apiResponse.msg ?? '服务端错误';
    switch (apiResponse.code) {
      case -3:
        // if (Get.isDialogOpen != true) {
        //   UserPageModule userPageModule = Get.find();
        //   userPageModule.loginOut();
        //   Get.dialog(ConfirmationDialog(
        //     content: const Text('当前登录状态已失效'),
        //     onConfirm: (res) {
        //       toUinPage(AppConfig.login_path);
        //     },
        //   ));
        // }
        break;
      case -5:
        // Get.dialog(ConfirmationDialog(
        //   title: '下线提醒',
        //   content: Text('账号已经下线', style: tx14),
        //   onConfirm: (res) {
        //     toUinPage(AppConfig.login_path);
        //   },
        // ));
        break;
      default:
    }
    if (apiResponse.code != 1) {
      ToastUtils.showToast(msg);
      throw dio.DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: apiResponse.msg,
      );
    }
    super.onResponse(response, handler);
  }

// 920962a2a50370f68a6d8246a866192c
  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    // 在请求发生错误时拦截并处理错误
    // ToastUtils.showToast(err.message ?? '服务端错误 请稍后再试');
    super.onError(err, handler);
  }
}
