import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './emojis.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///  input 输入框
class BotInput extends StatefulWidget {
  const BotInput({
    super.key,
    this.bottom = 0,
    this.send,
    this.type = 'keyWord',
    this.submitTx = '发送',
  });

  final double bottom;
  final String type;
  final String submitTx;
  final Function(String)? send;

  @override
  State<BotInput> createState() => _BotInputState();
}

class _BotInputState extends State<BotInput>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late TextEditingController _textEditingController;
  late StreamSubscription<bool> keyboardSubscription;

  /// 输入框聚焦控制器
  FocusNode focusNode = FocusNode();

  /// 键盘是否显示
  bool showKey = false;

  /// 是否显示表情
  bool emojiShow = false;

  /// 键盘高度
  double keyboardHeight = 0.0;

  /// 缓存的键盘高度
  double oldHeight = 0.0;

  /// 输入内容
  String txValue = "";

  TextStyle textStyle = const TextStyle(
    color: Color.fromRGBO(170, 170, 170, 1),
    fontSize: 14,
    fontFamily: 'emoji',
  );

  void showEmoji() {
    if (showKey) {
      oldHeight = keyboardHeight;
    } else {
      oldHeight = 300;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      showKey = false;
      emojiShow = true;
    });
  }

  void clearText() {
    _textEditingController.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.white,
      alignment: Alignment.topCenter,
      height: 44.h,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
            child: Row(
              children: [
                input(),
                // IconButton(
                //   onPressed: showEmoji,
                //   iconSize: 24.sp,
                //   icon: const Icon(IconData(0xe634, fontFamily: "psj_font")),
                // ),
                // txValue != ""
                //     ? SizedBox(
                //         width: 54.w,
                //         height: 26.h,
                //         child: Button(
                //           text: widget.submitTx,
                //           radius: 40,
                //           color: c_ee4c3d,
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //             widget.send?.call(txValue);
                //           },
                //         ),
                //       )
                //     : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget input() {
    return Expanded(
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(241, 241, 241, 1),
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: TextField(
          maxLines: null,
          maxLength: 100,
          autofocus: true,
          controller: _textEditingController,
          focusNode: focusNode,
          keyboardType: TextInputType.multiline,
          style: textStyle.copyWith(color: Colors.black),
          textInputAction: TextInputAction.send,
          textAlignVertical: TextAlignVertical.center, // 垂直居中对齐
          decoration: InputDecoration(
            isCollapsed: true,
            hintText: '聊点什么呢...',
            hintStyle: textStyle,
            border: InputBorder.none,
            counterText: '',
          ),
          onSubmitted: (value) {
            Navigator.of(context).pop();
            widget.send?.call(value);
          },
          onChanged: (value) {
            setState(() {
              txValue = value;
            });
          },
        ),
      ),
    );
  }

  /// 表情列表
  Widget emojiList() {
    return Visibility(
        visible: emojiShow,
        child: EmojisList(
          click: (emoji) {
            _textEditingController.text += emoji;
            _textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: _textEditingController.text.length));
            txValue = _textEditingController.text;
          },
        ));
  }

  Widget buildEmojiGird() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _textEditingController.text += emojis[index];
            _textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: _textEditingController.text.length));
            txValue = _textEditingController.text;
          },
          child: Text(
            emojis[index],
            style: const TextStyle(fontFamily: 'emoji', fontSize: 28),
          ),
        );
      },
      itemCount: emojis.length,
      padding: const EdgeInsets.all(5.0),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    keyboardSubscription.cancel();
    _textEditingController.dispose();
    super.dispose();
  }
}

class EmojisList extends StatelessWidget {
  const EmojisList({super.key, required this.click});

  final Function(String) click;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 40,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            click.call(emojis[index]);
          },
          child: Text(
            emojis[index],
            style: const TextStyle(
              fontFamily: 'emoji',
              fontSize: 28,
            ),
          ),
        );
      },
      itemCount: emojis.length,
      padding: const EdgeInsets.all(5.0),
    );
  }
}
