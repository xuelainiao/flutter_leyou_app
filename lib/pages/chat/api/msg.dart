import "package:mall_community/utils/request/dio.dart";

ApiClient apiClient = ApiClient();

/// 获取历史消息
Future reqMessages(data) {
  return apiClient.request(
    url: '/friend/friendMessages',
    query: data,
  );
}
