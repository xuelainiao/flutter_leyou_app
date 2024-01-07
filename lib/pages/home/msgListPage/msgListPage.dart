import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/commStyle.dart';
import 'package:mall_community/components/NewWorkImageWidget/NewWorkImageWidget.dart';
import 'package:mall_community/components/Tabs/Tabs.dart';

///用户消息列表
class MsgListPage extends StatefulWidget {
  const MsgListPage({super.key});

  @override
  State<MsgListPage> createState() => _MsgListPageState();
}

class _MsgListPageState extends State<MsgListPage>
    with TickerProviderStateMixin {
  final tabs = [
    {'text': "消息"},
    {'text': '联系人'}
  ];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        top: ScreenUtil().statusBarHeight,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(232, 225, 255, 1),
            Color.fromRGBO(199, 234, 254, 1),
          ],
          begin: Alignment.centerLeft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Tabs(
                          tabs: tabs,
                          tabController: tabController,
                          labelColor: primaryColor,
                          unselectedLabelColor: primaryNavColor,
                          indicator: const BoxDecoration(),
                          labelStyle: tx20.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(IconData(0xe67e, fontFamily: 'micon')),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(IconData(0xe6cb, fontFamily: 'micon')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: BrnSearchText(
              prefixIcon: Container(
                height: 44.h,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(
                  IconData(0xe67e, fontFamily: 'micon'),
                  size: 18,
                ),
              ),
              hintText: '搜索用户、群组',
              hintStyle: tx14.copyWith(color: placeholderTextC),
              outSideColor: Colors.transparent,
              innerPadding: const EdgeInsets.all(0),
              borderRadius: BorderRadius.circular(10),
              innerColor: backgroundColor,
              onTextCommit: (valur) {},
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: ListView.builder(
                itemCount: 100,
                itemExtent: 70,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, i) => buildItem(i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildItem(int i) {
    return ListTile(
      onTap: () {},
      leading: SizedBox(
        width: 50.r,
        height: 50.r,
        child: NetWorkImg(
          "https://panshijie-1310500608.cos.ap-guangzhou.myqcloud.com/20220326111649406.jpg",
          raduis: 50.0,
        ),
      ),
      title: SizedBox(
        height: 28.h,
        child: Text(
          '测试',
          style: tx14.copyWith(
            color: primaryTextC,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(
        '您好啊 帅哥 我喜欢你',
        style: tx10.copyWith(color: secondaryTextC),
      ),
      trailing: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('2023-12-10'),
            const SizedBox(height: 10),
            ClipOval(
              child: Container(
                height: 18.r,
                width: 18.r,
                alignment: Alignment.center,
                color: errorColor,
                child: Text(
                  "1",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
