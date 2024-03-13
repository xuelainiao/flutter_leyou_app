import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/drag_bottom_dismiss/drag_bottom_pop_sheet.dart';
import 'package:mall_community/utils/utils.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({
    super.key,
    required this.pics,
    this.current = 0,
    this.menus = const [
      {'title': '保存到相册'}
    ],
    this.onLongPressDown,
  });
  final List<Map<String, dynamic>> pics;
  final List<Map<String, dynamic>> menus;
  final Function(Map)? onLongPressDown;
  final int current;

  @override
  State<PreviewImage> createState() => _PreviewImage2State();
}

class _PreviewImage2State extends State<PreviewImage> {
  int currentIndex = 0;

  List<String> menus = ['保存到相册'];

  /// 长按
  onLongPressDown() {
    if (menus.isEmpty) return;
    showBottomMenu(widget.menus, (Map? data) {
      if (data != null) {
        widget.onLongPressDown?.call(data);
        switch (data['title']) {
          case '保存到相册':
            // savePhoneAlbum([
            //   pics[currentIndex],
            // ]);
            break;
          default:
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DragBottomPopGesture(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onLongPress: onLongPressDown,
          child: ExtendedImageGesturePageView.builder(
            itemBuilder: (BuildContext context, int index) {
              Widget image = Container(
                padding: const EdgeInsets.all(5.0),
                child: ExtendedImage.network(
                  widget.pics[index]['url'],
                  fit: BoxFit.contain,
                  enableSlideOutPage: true,
                  mode: ExtendedImageMode.gesture,
                ),
              );
              return Hero(
                tag: widget.pics[index]['key'],
                child: image,
              );
            },
            itemCount: widget.pics.length,
            onPageChanged: (int index) {
              currentIndex = index;
            },
            controller: ExtendedPageController(
              initialPage: widget.current,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}
