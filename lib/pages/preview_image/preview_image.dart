import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({super.key});

  @override
  State<PreviewImage> createState() => _PreviewImage2State();
}

class _PreviewImage2State extends State<PreviewImage> {
  List pics = [];

  int currentIndex = 0;

  List<String> menus = ['保存到相册'];

  /// 长按
  onLongPressDown() {
    if (menus.isEmpty) return;
    // showBottomMenu(menus, (String value) {
    //   if (value != '') {
    //     switch (value) {
    //       case '转发':
    //         uniapp.$emit('showShare', {
    //           'type': 'image',
    //           'data': pics[currentIndex],
    //         });
    //         break;
    //       case '保存到相册':
    //         savePhoneAlbum([
    //           pics[currentIndex],
    //         ]);
    //         break;
    //       default:
    //     }
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    Map? params = Get.arguments;
    if (params != null && params['list'] != null) {
      setState(() {
        currentIndex = params['index'] ?? 0;
        pics = params['list'] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          Get.back();
        },
        onLongPress: onLongPressDown,
        child: pics.isEmpty
            ? const SizedBox()
            : ExtendedImageSlidePage(
                slideAxis: SlideAxis.both,
                slideType: SlideType.wholePage,
                slidePageBackgroundHandler: (Offset? offset, Size size) {
                  return defaultSlidePageBackgroundHandler(
                    offset: offset!,
                    pageSize: size,
                    color: Colors.black,
                    pageGestureAxis: SlideAxis.both,
                  );
                },
                child: ExtendedImageGesturePageView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    Widget image = Container(
                      padding: const EdgeInsets.all(5.0),
                      child: ExtendedImage.network(
                        pics[index],
                        fit: BoxFit.contain,
                        enableSlideOutPage: true,
                        mode: ExtendedImageMode.gesture,
                      ),
                    );
                    return Hero(
                      tag: pics[index],
                      child: image,
                    );
                  },
                  itemCount: pics.length,
                  onPageChanged: (int index) {
                    currentIndex = index;
                  },
                  controller: ExtendedPageController(
                    initialPage: currentIndex,
                  ),
                  scrollDirection: Axis.horizontal,
                ),
              ),
      ),
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
}
