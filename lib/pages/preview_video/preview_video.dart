import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';
import 'package:mall_community/utils/cache_manager/cache_manager.dart';
import 'package:video_player/video_player.dart';

/// 视频预览页面
class PreviewVideo extends StatefulWidget {
  const PreviewVideo({super.key});

  @override
  State<PreviewVideo> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  late String url = '';
  late String cover = '';
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  late Chewie playerWidget;

  init() async {
    FileInfo? fileInfo = await FileCacheManager.getFileFromCache(url);
    if (fileInfo != null) {
      videoPlayerController = VideoPlayerController.file(fileInfo.file)
        ..initialize().then((value) {
          setChewie();
        });
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setChewie();
          FileCacheManager.downloadFile(url);
        }).catchError((err) {
          debugPrint('catchError $err  $url');
        });
    }
  }

  setChewie() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      autoInitialize: true,
      looping: false,
    );
    playerWidget = Chewie(
      controller: chewieController!,
    );
    setState(() {});
  }

  @override
  void initState() {
    Map? params = Get.arguments;
    if (params != null) {
      url = params['url'] ?? '';
      cover = params['cover'] ?? '';
    }
    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: videoPlayerController != null &&
              videoPlayerController!.value.isInitialized &&
              chewieController != null
          ? Hero(
              tag: cover,
              child: SafeArea(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: playerWidget,
                ),
              ),
            )
          : NetWorkImg(cover),
    );
  }

  Color defaultSlidePageBackgroundHandler(
      {required Offset offset,
      required Size pageSize,
      required Color color,
      required SlideAxis pageGestureAxis}) {
    double opacity = 0.0;
    if (pageGestureAxis == SlideAxis.both) {
      opacity = offset.distance /
          (Offset(pageSize.width, pageSize.height).distance / 2.0);
    } else if (pageGestureAxis == SlideAxis.horizontal) {
      opacity = offset.dx.abs() / (pageSize.width / 2.0);
    } else if (pageGestureAxis == SlideAxis.vertical) {
      opacity = offset.dy.abs() / (pageSize.height / 2.0);
    }
    return color.withOpacity(min(1, max(0.8 - opacity, 0.0)));
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }
}
