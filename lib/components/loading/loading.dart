import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/not_data/not_data.dart';
import 'package:mall_community/utils/request/dio_response.dart';
import 'package:mall_community/utils/request/error_exception.dart';
import 'package:visibility_detector/visibility_detector.dart';

///文本加载组件
class LoadingText extends StatelessWidget {
  const LoadingText({super.key, this.text = '加载中 . . .'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: tx14.copyWith(color: routineTextC),
          )
        ],
      ),
    );
  }
}

/// 组件请求加载 包裹你要渲染的组件 加载成功才显示渲染组件
class LoadingPage extends StatefulWidget {
  const LoadingPage({
    super.key,
    required this.fetch,
    required this.child,
    this.showEmpty = true,
    this.empty = '',
  });

  /// 请求函数
  final Future<ApiResponse> Function() fetch;

  /// 是否显示缺省状态|无数据
  final bool showEmpty;

  /// 无数据提示
  final String empty;

  /// 加载成功渲染的组件
  final Widget child;
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  int status = NetWorkDataStatus.notLoading;
  late Key key;
  late final AppLifecycleListener listener;

  getData() async {
    try {
      ApiResponse result = await widget.fetch.call();
      status = NetWorkDataStatus.loadingOK;
      if (widget.showEmpty) {
        if (result.data is List && result.data.lenth == 0) {
          status = NetWorkDataStatus.notData;
        } else if (result.data is Map &&
            result.data.containsKey('list') &&
            result.data['list'].length == 0) {
          status = NetWorkDataStatus.notData;
        }
      }
      // 延迟500ms加载 请求状态切换太快会闪烁
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {});
      });
    } on ApiError catch (e) {
      setState(() {
        status = e.errCode;
      });
    } catch (err) {
      setState(() {
        status = NetWorkDataStatus.notNetworkError;
      });
    } finally {}
  }

  onShow() {
    if (status == NetWorkDataStatus.notLogin) {
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    key = UniqueKey();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: key,
      child: getWidget(),
      onVisibilityChanged: (VisibilityInfo state) {
        if (state.visibleFraction == 1) {
          onShow();
        }
      },
    );
  }

  getWidget() {
    String? label;
    Function? callback;
    if (status == NetWorkDataStatus.notLogin) {
      label = '前往登录';
      callback = () {
        Get.toNamed('/login');
      };
    }
    if (status == NetWorkDataStatus.notNetworkError) {
      label = '重新加载';
      callback = () {
        getData();
      };
    }

    if (status == NetWorkDataStatus.notLoading) {
      return const Center(child: LoadingText());
    } else if (status == NetWorkDataStatus.loadingOK) {
      return widget.child;
    } else {
      return Center(
        child: NotDataIcon(
          status: status,
          label: label,
          subTitle: widget.empty,
          callBack: callback,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
