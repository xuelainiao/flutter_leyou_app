import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class NetWorkImg extends StatefulWidget {
  NetWorkImg(
    this.url, {
    super.key,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.loadNum = 3,
    this.isCache = true,
    this.raduis = 0.0,
    this.alignment = Alignment.center,
  });

  /// 图片地址
  final String url;

  /// 填充模式
  final BoxFit fit;

  /// 图片宽度
  final width;

  /// 图片高度
  final height;

  ///重加载次数
  int loadNum = 0;

  /// 是否需要缓存
  final isCache;

  /// 图片圆角大小
  final raduis;

  /// 对齐方式
  final Alignment alignment;

  @override
  State<NetWorkImg> createState() => _NewWorkImgState();
}

class _NewWorkImgState extends State<NetWorkImg> {
  /// url 是否正确
  bool isUrl = true;

  late String _url;

  // /// 域名前缀
  // String prefix = 'https://panshijie-1310500608.cos.ap-guangzhou.myqcloud.com';

  // /// 全球加速域名
  // String globalUrl = "https://panshijie-1310500608.cos.accelerate.myqcloud.com";

  int _loadNum = 0;

  bool isValidUrl(String url) {
    RegExp regex = RegExp(r'^(https?://)');
    return regex.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    isUrl = isValidUrl(widget.url);
    _url = widget.url;
    // if (widget.url.startsWith(prefix)) {
    //   _url = widget.url.replaceFirst(prefix, globalUrl);
    // }
    return !isUrl
        ? errWidget()
        : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.raduis)),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: ExtendedImage.network(
                _url,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                cache: widget.isCache,
                retries: widget.loadNum,
                excludeFromSemantics: true,
                gaplessPlayback: true, //切换前保留原图 防止返回闪动重新渲染
                alignment: widget.alignment,
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return loading();
                    case LoadState.completed:
                      return null;
                    case LoadState.failed:
                      if (_loadNum == widget.loadNum) {
                        return errWidget();
                      } else {
                        state.reLoadImage();
                        return const SizedBox();
                      }
                  }
                },
              ),
            ),
          );
  }

  Widget loading() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.white,
      alignment: Alignment.center,
    );
  }

  Widget errWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: const Icon(Icons.error_outline),
    );
  }
}
