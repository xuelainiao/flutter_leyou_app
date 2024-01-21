import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/components/icon_svg/icon_svg.dart';
import 'package:mall_community/components/text_field_custom/field_custom.dart';
import 'package:mall_community/components/text_field_custom/custom_field_module.dart';
import 'package:mall_community/pages/chat/module/chat_module.dart';
import 'package:mall_community/utils/key_board_visible_mixn.dart';

/// 聊天页面底部输入框
class MsgBotInput extends StatefulWidget {
  const MsgBotInput({super.key});

  @override
  State<MsgBotInput> createState() => _MsgBotInputState();
}

class _MsgBotInputState extends State<MsgBotInput>
    with WidgetsBindingObserver, KeyboardVisibilityMixin {
  final tx = ''.obs;
  final ChatModule chatModule = Get.find();
  bool showkeyBoard = false;
  double baseHeight = 60.h;
  double menuHeight = 260.h;

  /// 键盘高度
  double keyboardHeight = 0.0;

  /// 底部总体高度
  double bottomHeight = 60.h + ScreenUtil().bottomBarHeight;

  /// 菜单类型 0不显示 1菜单 2表情
  MenuTypes menuType = MenuTypes.hide;
  setMenuType(MenuTypes type) {
    if (type == menuType) {
      setState(() {
        menuType = MenuTypes.hide;
        bottomHeight = baseHeight + ScreenUtil().bottomBarHeight;
      });
      return;
    }
    setState(() {
      showkeyBoard = false;
      menuType = type;
      bottomHeight = baseHeight + menuHeight;
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  sendMsg() {
    if (tx.value.isEmpty) return;
    chatModule.sendMsg(tx.value);
    CustomFieldModule.controller.clear();
    tx.value = '';
  }

  /// 监听窗口高度变化设置高度
  setHeight() {
    keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double height = baseHeight + keyboardHeight + 10.h;

    /// 如果当前底部高度 > 键盘高度 就不设置
    /// 如果发现动态切换键盘高度变小了的话 就要去掉这里
    if (bottomHeight > height) return;
    setState(() {
      bottomHeight = height;
      menuType = MenuTypes.hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: showkeyBoard ? 0 : 300),
      curve: Curves.easeIn,
      height: bottomHeight,
      padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
      onEnd: () {
        if (showkeyBoard || menuType != MenuTypes.hide) chatModule.toBottom();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            constraints: BoxConstraints(maxHeight: 120.h, minHeight: 48.h),
            padding: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
              color: HexThemColor(cF1f1f1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 48.h,
                    width: 40.w,
                    child: const Icon(
                      IconData(0xe68d, fontFamily: 'micon'),
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 12.h,
                      left: 4.w,
                    ),
                    child: FieldCustom(
                      controller: CustomFieldModule.controller,
                      change: (t) {
                        tx.value = t;
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setMenuType(MenuTypes.emoji);
                  },
                  child: SizedBox(
                    height: 48.h,
                    width: 40.w,
                    child: const Icon(
                      IconData(0xe644, fontFamily: 'micon'),
                      size: 26,
                    ),
                  ),
                ),
                SendButton(tx: tx, sendMsg: sendMsg, setType: setMenuType),
              ],
            ),
          ),
          if (menuType == MenuTypes.more) ChatBottomMenu(),
          if (menuType == MenuTypes.emoji)
            EmojiList(
              message: tx,
              setText: (t) {
                tx.value = t;
              },
            )
        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    CustomFieldModule.controller = TextEditingController();
    super.initState();
  }

  @override
  void onKeyboardVisibilityChanged(bool isKeyBoard) {
    showkeyBoard = isKeyBoard;
    if (!isKeyBoard) {
      if (AppConfig.keyBoardHeight < 100) {
        AppConfig.keyBoardHeight = keyboardHeight;
      }
      if (menuType == MenuTypes.hide) {
        setState(() {
          bottomHeight = baseHeight + ScreenUtil().bottomBarHeight;
        });
      }
    }
  }

  @override
  void didChangeMetrics() {
    /// 这里只处理键盘出现，不处理键盘消失，避免性能浪费
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 组件激活并且键盘显示并且高度大于0
      if (mounted &&
          MediaQuery.of(context).viewInsets.bottom != 0 &&
          showkeyBoard) {
        // 本机是否缓存了键盘高度
        if (showkeyBoard && AppConfig.keyBoardHeight > 200) {
          //  针对键盘出现后 切换键盘类型导致高度二次变化
          if (keyboardHeight != MediaQuery.of(context).viewInsets.bottom) {
            setHeight();
          }
          return;
        }
        setHeight();
      }
    });
  }

  @override
  void dispose() {
    CustomFieldModule.controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.tx,
    required this.sendMsg,
    required this.setType,
  });

  final RxString tx;
  final Function sendMsg;
  final Function setType;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: tx.isNotEmpty
              ? Container(
                  width: 50.w,
                  height: 30.h,
                  margin: EdgeInsets.only(bottom: 9.h),
                  child: Button(
                    text: '',
                    radius: 20,
                    icon: const Icon(IconData(0xe652, fontFamily: 'micon')),
                    borderColor: Colors.transparent,
                    onPressed: () {
                      sendMsg();
                    },
                  ),
                )
              : InkWell(
                  onTap: () {
                    setType(MenuTypes.more);
                  },
                  child: SizedBox(
                    height: 48.h,
                    width: 40.w,
                    child: const Icon(
                      IconData(0xe626, fontFamily: 'micon'),
                      size: 28,
                    ),
                  ),
                ),
        ));
  }
}

/// 页面底部菜单切换类型
enum MenuTypes { hide, more, emoji }

/// 聊天底部菜单
class ChatBottomMenu extends StatelessWidget {
  ChatBottomMenu({super.key});

  final List menus = [
    {
      'title': '相册',
      'icon': const Icon(IconData(0xe7e4, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '拍摄',
      'icon': const Icon(IconData(0xe61b, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '文件',
      'icon': const Icon(IconData(0xe601, fontFamily: 'micon'), size: 34),
    },
    {
      'title': '定位',
      'icon': const Icon(IconData(0xe620, fontFamily: 'micon'), size: 32),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 1.sw,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          alignment: WrapAlignment.spaceBetween,
          clipBehavior: Clip.hardEdge,
          children: List.generate(menus.length, (i) => buildItem(menus[i])),
        ),
      ),
    );
  }

  Widget buildItem(Map item) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: HexThemColor(cF1f1f1),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: item['icon'],
        ),
        Text(
          item['title'],
        )
      ],
    );
  }
}

/// 表情列表
class EmojiList extends StatelessWidget {
  const EmojiList({super.key, required this.message, required this.setText});
  final RxString message;
  final Function setText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  CustomFieldModule.insertText('[${svgIcons[index]['name']}]');
                  setText(message.value += '[${svgIcons[index]['name']}]');
                },
                child: AlIconSvg(
                  name: svgIcons[index]['name'],
                ),
              );
            },
            itemCount: svgIcons.length,
            padding: const EdgeInsets.all(5.0),
          ),
          Positioned(
            right: 10.w,
            bottom: 20.h,
            child: InkWell(
              onTap: () {
                CustomFieldModule.manualDelete();
                setText(CustomFieldModule.controller.text);
              },
              child: Container(
                width: 60.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: HexThemColor(cF1f1f1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  size: 40,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///页面底部组件公共方法暴露
///比如滚动的时候关闭底部菜单，如果菜单打开的话
class MsgBotInputModule {
  static GlobalKey bottomKey = GlobalKey();

  // 关闭当前菜单或者输入框
  static hideBootoMenu() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
    _MsgBotInputState? page = bottomKey.currentState as _MsgBotInputState;
    page.setMenuType(MenuTypes.hide);
  }
}
