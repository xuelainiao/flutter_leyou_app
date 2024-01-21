import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:mall_community/api/chat/chat.dart';
import 'package:mall_community/utils/request/dio_response.dart';

/// 好友和群数据module
class MsgListModule extends GetxController {
  final loading = false.obs;

  ///好友消息列表
  final msgList = [].obs;
  Map<String, dynamic> params = {'page': 1, 'pageSize': 10};
  Future<ApiResponse> getMsgList() async {
    var result = await reqFriendMsgs(params);
    if (result.data['list'].length > 0) {
      msgList.addAll(result.data['list']);
    }
    return result;
  }

  ///好友列表
  final friends = [].obs;
  Map<String, dynamic> params2 = {'page': 1, 'pageSize': 10};
  Future<ApiResponse> getFriends() async {
    var result = await reqFriends(params2);
    if (result.data['list'].length > 0) {
      friends.addAll(result.data['list']);
    }
    return result;
  }

  ///群列表
  final groups = [].obs;
  Map<String, dynamic> params3 = {'page': 1, 'pageSize': 10};
  Future<ApiResponse> getGroups() async {
    var result = await reqGroups(params3);
    if (result.data['list'].length > 0) {
      groups.addAll(result.data['list']);
    }
    return result;
  }

  // 加载更多
  late EasyRefreshController easyRefreshController;
  getMore(type) async {
    late ApiResponse result;
    switch (type) {
      case 1:
        params2['page'] += 1;
        result = await getFriends();
        break;
      case 2:
        params3['page'] += 1;
        result = await getGroups();
        break;
      default:
        params['page'] += 1;
        result = await getMsgList();
    }

    if (result.data['list'].length == 0 || result.data['list'].length < 10) {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    } else {
      easyRefreshController.finishLoad(IndicatorResult.success);
    }
  }

  toChat(user) {
    Get.toNamed('/chat', arguments: {
      'userId': user['userId'],
      'avatar': user['avatar'],
      'userName': user['userName'],
    });
  }
}
