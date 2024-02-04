import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 录音波纹图 根据当前录音声音的高度来显示
class WaveformsList extends StatelessWidget {
  WaveformsList({super.key});

  final WaveformsModule waveformsModule = Get.put(WaveformsModule());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: AnimatedList(
        key: waveformsModule.animatedListKey,
        controller: waveformsModule.scrollController,
        itemBuilder: (ctx, i, animatable) {
          return ScaleTransition(
              scale: animatable,
              child: itemBuild(waveformsModule.waveforms[i]));
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  itemBuild(h) {
    double height = h / 100 * 50;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: height < 2 ? 4 : height,
          constraints: const BoxConstraints(maxHeight: 50),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class WaveformsModule extends GetxController {
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  ScrollController scrollController = ScrollController();
  List<double> waveforms = [];

  add(double height) {
    // 这里的声音不太敏感 为了体验感 我们稍微减低一下
    waveforms.add(height < 40 ? height - 30 : height);
    animatedListKey.currentState?.insertItem(waveforms.length - 1);
    toBottom();
  }

  /// 滚动到底部
  toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double height = scrollController.position.maxScrollExtent;
      scrollController.animateTo(
        height,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  clear() {
    waveforms.clear();
  }
}
