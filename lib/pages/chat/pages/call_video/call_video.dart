import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/utils/web_rtc/web_rtc_controller.dart';

class CallVieoPage extends StatefulWidget {
  const CallVieoPage({super.key});

  @override
  State<CallVieoPage> createState() => _CallVieoPageState();
}

class _CallVieoPageState extends State<CallVieoPage> {
  late WebRtcController webRtcController;
  String viewId = UniqueKey().toString();
  WebRtcView? view;
  onCreate(WebRtcView webRtcView) {
    debugPrint("视频创建");
    setState(() {
      view = webRtcView;
    });
  }

  onCloseLocal() {
    setState(() {
      view = null;
    });
  }

  start() {
    webRtcController.createdView(viewId, context, true);
  }

  @override
  void initState() {
    webRtcController = WebRtcController(
      createLocalStream: onCreate,
      destroyStream: onCloseLocal,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black54,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            view != null ? RTCVideoView(view!.viewRenderer!) : const SizedBox(),
            Positioned(
              bottom: 100,
              left: 50,
              child: Button(
                onPressed: start,
                text: "创建本地视频",
              ),
            ),
            Positioned(
              bottom: 100,
              left: 200,
              child: Button(
                onPressed: () {
                  webRtcController.deleteView(viewId);
                },
                text: "销毁",
              ),
            )
          ],
        ),
      ),
    );
  }
}
