import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/pop_animate/pop_animate.dart';

/// Overlay管理对象
class OverlayManager {
  static final OverlayManager _internal = OverlayManager._();
  OverlayManager._();
  factory OverlayManager() {
    return _internal;
  }

  /// Overlay Map
  Map<String, OverlayEntry> overlayMap = {};

  /// 显示Overlay
  void showOverlay(
    Widget widget,
    UniqueKey key, {
    bool isAnimate = true,
    Alignment alignment = Alignment.center,
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return isAnimate
            ? PopAnimate(
                alignment: alignment,
                child: widget,
              )
            : widget;
      },
    );
    overlayMap[key.toString()] = overlayEntry;
    Overlay.of(Get.context!).insert(overlayEntry);
  }

  /// 删除Overlay
  void removeOverlay(UniqueKey key) {
    OverlayEntry? overlayEntry = overlayMap[key.toString()];
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayMap.remove(key.toString());
    }
  }

  updateOverlay(UniqueKey key) {
    OverlayEntry? overlayEntry = overlayMap[key.toString()];
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }
}
