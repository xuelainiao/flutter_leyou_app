import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/automatic_keep_alive/automatic_keep_alive.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/Loading/Loading.dart';
import 'package:mall_community/pages/home/msg_list_page/controller/msg_list_module.dart';

/// 用户群列表
class GroupList extends StatelessWidget {
  GroupList({super.key, required this.physics});
  final ScrollPhysics physics;
  final MsgListModule msgListModule = Get.find();

  @override
  Widget build(BuildContext context) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('gruopList'),
      child: MyAutomaticKeepAlive(
        child: LoadingPage(
          fetch: msgListModule.getGroups,
          empty: '快去广场加入您心动的社友群吧~',
          child: Obx(
            () => ListView.builder(
              itemExtent: 70,
              physics: physics,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              itemCount: msgListModule.groups.length,
              itemBuilder: (context, i) => buildItem(i),
            ),
          ),
        ),
      ),
    );
  }

  buildItem(int i) {
    Map item = msgListModule.groups[i]['group'];
    return Container(
      alignment: Alignment.center,
      height: 70,
      child: ListTile(
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: item['avatar'] == ''
            ? Container(
                width: 50.r,
                height: 50.r,
                decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: const Icon(
                  IconData(0xe659, fontFamily: 'micon'),
                  color: Colors.white,
                ),
              )
            : MyAvatar(
                src: item['avatar'],
                radius: 50.r,
                size: 50.r,
              ),
        title: Text(
          item['groupName'],
          style: tx18.copyWith(
            color: HexThemColor(primaryTextC, direction: 2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
