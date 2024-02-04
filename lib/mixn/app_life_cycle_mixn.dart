import 'package:flutter/material.dart';

/// APP 生命周期混入 而不是当前页面生命周期 注意
mixin APPLifeCycleMixn<T extends StatefulWidget> on State<T> {
  late final AppLifecycleListener listener;

  /// APP 可见
  onShow() {
    debugPrint('onShow');
  }

  onHide() {
    debugPrint('onHide');
  }

  onDetach() {
    debugPrint('onDetach 退出app');
  }

  /// APP 活动暂停 进入后台 不可见
  onPause() {
    debugPrint('onPause app暂停');
  }

  /// APP 切换到任务管理器页面
  onInactive() {
    debugPrint('onInactive');
  }

  onRestart() {
    debugPrint('onRestart');
  }

  @override
  void initState() {
    super.initState();
    listener = AppLifecycleListener(
      onShow: onShow,
      onHide: onHide,
      onDetach: onDetach,
      onPause: onPause,
      onInactive: onInactive,
      onRestart: onRestart,
    );
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }
}
