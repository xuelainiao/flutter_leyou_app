import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/drag_widget/drag_widget.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/pages/call_video/components/call_time.dart';
import 'package:mall_community/pages/chat/pages/call_video/controller/call_video_controller.dart';
import 'package:mall_community/utils/web_rtc/web_rtc_controller.dart';

class CallVieoPage extends StatefulWidget {
  const CallVieoPage({super.key});

  @override
  State<CallVieoPage> createState() => _CallVieoPageState();
}

class _CallVieoPageState extends State<CallVieoPage> {
  late CallVideoController callVideoController;

  onCloseLocal() {
    setState(() {
      callVideoController.view = null;
    });
  }

  // 是否前置摄像头
  bool isfrontCamera = true;
  switchCamera() async {
    await callVideoController.webRtcController.switchCamera();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isfrontCamera = !isfrontCamera;
      });
    });
  }

  bool isOpenVideo = true;
  // 开关摄像头
  openVideo() {
    if (callVideoController.view != null) {
      isOpenVideo = !isOpenVideo;
      callVideoController.view?.switchVideoPusdher(!isOpenVideo);
      callVideoController.sendCameraClose(isOpenVideo);
      setState(() {});
    }
  }

  switchMuted() async {
    await callVideoController.webRtcController.switchMuted(!isMuted());
    setState(() {});
  }

  // 是否外放
  bool isExocytosis = true;
  switchExocytosis() {
    callVideoController.webRtcController.exocytosisAudio(!isExocytosis);
    setState(() {
      isExocytosis = !isExocytosis;
    });
  }

  // 是否静音
  bool isMuted() {
    if (callVideoController.view != null) {
      return callVideoController.view!.muted;
    } else {
      return true;
    }
  }

  // 是否开启摄像头
  bool getOpenVIdeo() {
    if (callVideoController.view != null) {
      return callVideoController.view!.videoEnabled;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    dynamic params = Get.arguments;
    if (params != null && params['callVideoController'] != null) {
      callVideoController = params['callVideoController'];
      callVideoController.setConnteroll(callVideoController);
    } else {
      callVideoController = Get.put(CallVideoController());
      callVideoController.webRtcController = WebRtcController(
          onIceCandidate: callVideoController.onIceCandidate,
          onRemoteAddStream: callVideoController.onRemoteAddStream,
          onRemoveStream: callVideoController.onRemoveStream);
      callVideoController.startWebRtc(context);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Hero(
      tag: "call_video_page",
      child: Scaffold(
        body: Container(
            color: Colors.black54,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GetBuilder<CallVideoController>(
              init: callVideoController,
              builder: (ctx) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ctx.view != null
                        ? SizedBox(
                            width: size.width,
                            height: size.height,
                            child: WebRtcViewWidget(
                              view: ctx.view!,
                              mirror: isfrontCamera ? true : false,
                              placeholder: UserBgWidget(
                                avatar: UserInfo.user['avatar'],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    if (ctx.toView != null && ctx.isConnect)
                      DragWidget(
                        top: ScreenUtil().statusBarHeight + 60,
                        child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(10),
                            child: WebRtcViewWidget(
                              view: ctx.toView!,
                              mirror: true,
                              placeholder: UserBgWidget(
                                avatar: callVideoController.friendInfo.avatar,
                                avatarCenter: true,
                                avatarSize: 40,
                              ),
                            )),
                      ),
                    if (ctx.isConnect) navBar(),
                    buttonRow(),
                    Positioned(
                      bottom: 10 + ScreenUtil().bottomBarHeight,
                      child: buttonBox(
                        child: const Icon(
                          IconData(0xe7d3, fontFamily: 'micon'),
                          color: Colors.white,
                          size: 30,
                        ),
                        color: Colors.red,
                        click: callVideoController.stopWebRtc,
                      ),
                    )
                  ],
                );
              },
            )),
      ),
    );
  }

  Widget navBar() {
    return Positioned(
      top: ScreenUtil().statusBarHeight + 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: IconButton(
              onPressed: callVideoController.scalelVideo,
              icon: const Icon(
                Icons.fullscreen_exit_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 60),
              child: const CallTime(),
            ),
          )
        ],
      ),
    );
  }

  Widget buttonRow() {
    return Positioned(
      bottom: 140.h,
      left: 20.w,
      right: 20.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buttonBox(
            child: isMuted()
                ? const Icon(
                    IconData(0xe66a, fontFamily: 'micon'),
                    color: Colors.black,
                  )
                : const Icon(IconData(0xe66b, fontFamily: 'micon')),
            color: isMuted() ? Colors.black.withOpacity(0.5) : Colors.white,
            click: switchMuted,
          ),
          buttonBox(
            child: isExocytosis
                ? const Icon(
                    IconData(0xe671, fontFamily: 'micon'),
                  )
                : const Icon(
                    IconData(0xe673, fontFamily: 'micon'),
                    color: Colors.white,
                  ),
            color: isExocytosis ? Colors.white : Colors.black.withOpacity(0.5),
            click: switchExocytosis,
          ),
          buttonBox(
            child: getOpenVIdeo()
                ? const Icon(IconData(0xe672, fontFamily: 'micon'))
                : const Icon(
                    IconData(0xe674, fontFamily: 'micon'),
                    color: Colors.white,
                  ),
            color:
                getOpenVIdeo() ? Colors.white : Colors.black.withOpacity(0.5),
            click: openVideo,
          ),
          buttonBox(
            child: isfrontCamera
                ? const Icon(IconData(0xe66d, fontFamily: 'micon'))
                : const Icon(
                    IconData(0xe66d, fontFamily: 'micon'),
                    color: Colors.white,
                  ),
            color: isfrontCamera ? Colors.white : Colors.black.withOpacity(0.5),
            click: switchCamera,
          ),
        ],
      ),
    );
  }

  Widget buttonBox({
    required Widget child,
    required Function click,
    Color color = Colors.white,
    String tx = "",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: OutlinedButton(
            onPressed: () {
              click.call();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: color,
              fixedSize: const Size(60, 62),
              padding: const EdgeInsets.all(0),
              shadowColor: Colors.transparent,
              side: BorderSide.none,
            ),
            child: child,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tx,
          style: tx12.copyWith(color: Colors.white),
        )
      ],
    );
  }
}

/// 视频通话背景
class UserBgWidget extends StatelessWidget {
  const UserBgWidget({
    super.key,
    required this.avatar,
    this.avatarCenter = false,
    this.avatarSize = 100,
  });

  final String avatar;
  final double avatarSize;
  final bool avatarCenter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
            ),
            child: Image.network(
              avatar,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            alignment: avatarCenter ? Alignment.center : Alignment.topCenter,
            padding: avatarCenter ? null : const EdgeInsets.only(top: 300),
            color: Colors.black54,
            child: MyAvatar(
              src: avatar,
              size: avatarSize,
            ),
          ),
        ),
      ],
    );
  }
}
