import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/Loading/Loading.dart';

setEasyRefreshDeafult() {
  EasyRefresh.defaultHeaderBuilder = () => headerLoading;
  EasyRefresh.defaultFooterBuilder = () => footerLoading;
}

/// tabview 上啦刷新配置
ClassicFooter myClassicTabViewFooter = ClassicFooter(
  dragText: '上滑加载'.tr,
  armedText: '松开加载更多数据',
  readyText: '加载中...',
  processingText: '加载中...',
  processedText: '加载完毕',
  noMoreText: '没有更多数据了',
  failedText: '加载失败',
  messageText: '',
  // position: IndicatorPosition.locator,
);

/// sliver 下拉刷新配置
Header sliverHeaderLoading = BuilderHeader(
  triggerOffset: 70,
  clamping: false,
  infiniteOffset: 70,
  position: IndicatorPosition.locator,
  builder: (ctx, state) => HeaderLoading(state: state),
);

/// 普通下拉刷新配置
Header headerLoading = BuilderHeader(
  triggerOffset: 100,
  clamping: false,
  infiniteOffset: 100,
  safeArea: true,
  position: IndicatorPosition.above,
  builder: (ctx, state) => HeaderLoading(state: state),
);

/// 普通上啦刷新
Footer footerLoading = BuilderFooter(
  triggerOffset: 70,
  clamping: false,
  infiniteOffset: 40,
  builder: (ctx, state) => FooterLoading(state: state),
);

/// sliver 上啦刷新
Footer sliverFooterLoading = BuilderFooter(
  triggerOffset: 70,
  clamping: false,
  infiniteOffset: 70,
  position: IndicatorPosition.locator,
  builder: (ctx, state) => FooterLoading(state: state),
);

/// 普通上啦刷新
ClassicFooter myClassicFooter = ClassicFooter(
  dragText: '上滑加载'.tr,
  armedText: '松开加载更多数据',
  readyText: '加载中...',
  processingText: '加载中...',
  processedText: '加载完毕',
  noMoreText: '没有更多数据了',
  failedText: '加载失败',
  showMessage: false,
  // position: IndicatorPosition.behind,
);

/// 自定义触底加载
class FooterLoading extends StatelessWidget {
  const FooterLoading({
    super.key,
    this.noMoreTtile = '没有更多数据啦',
    required this.state,
    this.height = 60,
  });

  final String noMoreTtile;
  final IndicatorState state;
  final double height;

  @override
  Widget build(BuildContext context) {
    var mode = state.mode;
    var result = state.result;
    double opacity = state.offset > 1 ? 1 : state.offset;
    return (mode == IndicatorMode.inactive || mode == IndicatorMode.done) &&
            result == IndicatorResult.none
        ? const SizedBox()
        : Container(
            height: state.offset,
            width: double.infinity,
            alignment: Alignment.center,
            child: result == IndicatorResult.noMore
                ? Text(noMoreTtile)
                : Opacity(
                    opacity: opacity,
                    child: const LoadingText(),
                  ),
          );
  }
}

/// 自定义下拉刷新加载图标
class HeaderLoading extends StatelessWidget {
  const HeaderLoading({
    super.key,
    this.bgColor = Colors.white,
    required this.state,
  });

  /// 下拉刷新背景色
  final Color bgColor;
  final IndicatorState state;

  @override
  Widget build(BuildContext context) {
    return state.mode == IndicatorMode.inactive
        ? const SizedBox()
        : Container(
            height: state.offset,
            width: double.infinity,
            alignment: Alignment.center,
            child: const LoadingText(),
          );
  }
}
