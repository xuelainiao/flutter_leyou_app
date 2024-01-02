import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastUtils {
  static void showToast(
    String message, {
    position = 'center',
    type = 'toast',
    Widget? toastWidget,
  }) {
    EasyLoading.dismiss();

    EasyLoading.instance
      ..animationStyle = EasyLoadingAnimationStyle.custom
      ..customAnimation = CustomEasyLoadingAnimation()
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark;

    EasyLoadingToastPosition _postion = EasyLoadingToastPosition.center;
    switch (position) {
      case 'top':
        _postion = EasyLoadingToastPosition.top;
        break;
      case 'bottom':
        _postion = EasyLoadingToastPosition.bottom;
        break;
    }

    if (toastWidget != null) {
      type = 'success';
      EasyLoading.instance.successWidget = toastWidget;
      EasyLoading.instance
        ..contentPadding = const EdgeInsets.all(0)
        ..textPadding = const EdgeInsets.all(0)
        ..backgroundColor = const Color.fromRGBO(21, 24, 30, 0.8)
        ..radius = 10;
    } else {
      EasyLoading.instance
        ..contentPadding =
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
        ..textPadding = const EdgeInsets.all(2)
        ..backgroundColor = const Color.fromRGBO(21, 24, 30, 0.90)
        ..radius = 4.0;
    }

    switch (type) {
      case 'toast':
        EasyLoading.showToast(message, toastPosition: _postion);
        break;
      case 'error':
        EasyLoading.showError(message);
        break;
      case 'success':
        EasyLoading.showSuccess(message);
        break;
    }
  }

  static void showProgress(value, message) {
    EasyLoading.showProgress(value, status: message);
  }

  static void showLoad({message = 'loading...'}) {
    EasyLoading.instance
      ..contentPadding =
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
      ..textPadding = const EdgeInsets.all(2)
      ..radius = 8;
    EasyLoading.show(status: message);
  }

  static void hideLoad() {
    EasyLoading.dismiss();
  }
}

/// 自定义 toast 动画
class CustomEasyLoadingAnimation extends EasyLoadingAnimation {
  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
