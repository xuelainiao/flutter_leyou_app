import "package:mall_community/utils/request/dio.dart";

ApiClient apiClient = ApiClient();

/// 用户登录
Future reqLogin(data) {
  return apiClient.post('/auth/login', data: data);
}
