import 'package:mall_community/utils/request/dio_response.dart';
import "package:mall_community/utils/request/dio.dart";

ApiClient apiClient = ApiClient();

/// 获取好友列表
Future reqFriends(data) {
  return apiClient.request(url: '/friend', query: data);
}

/// 我的消息列表
Future<ApiResponse> reqFriendMsgs(data) {
  return apiClient.request(
    url: '/friend/msgList',
    query: data,
  );
}

/// 获取我的群列表
Future<ApiResponse> reqGroups(data) {
  return apiClient.request(
    url: '/group/userGroup',
    query: data,
  );
}
