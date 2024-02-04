import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

mixin KeyboardVisibilityMixin<T extends StatefulWidget> on State<T> {
  late StreamSubscription<bool> keyboardSubscription;
  late KeyboardVisibilityController keyboardVisibilityController;

  /// 键盘可见性回调函数
  void onKeyboardVisibilityChanged(bool isKeyBoard) {}

  @override
  void initState() {
    super.initState();
    keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      onKeyboardVisibilityChanged(visible);
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}
