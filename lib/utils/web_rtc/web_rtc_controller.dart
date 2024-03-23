import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mall_community/utils/log/log.dart';

/// webRtc 实例控制类
/// onIceCandidate ice候选人回调
/// onRemoteAddStream 远程视频可用回调
/// onRemoveStream 远程视频不可用或者远程断开连接
class WebRtcController {
  WebRtcController({
    required Function(RTCIceCandidate) onIceCandidate,
    required Function(MediaStream) onRemoteAddStream,
    Function(MediaStream)? onRemoveStream,
  }) {
    _onRemoteAddStream = onRemoteAddStream;
    _onRemoveStream = onRemoveStream;
    _onIceCandidate = onIceCandidate;
  }

  // 当前推拉视频流队列
  final List<WebRtcView> _rtcList = [];

  /// 远程视频流可用回调
  late Function(MediaStream) _onRemoteAddStream;

  /// 远程视频删除
  Function(MediaStream)? _onRemoveStream;

  /// ice 候选人回调
  late Function(RTCIceCandidate) _onIceCandidate;

  /// 获取设备信息
  /// 防止有的场景没有摄像头或者麦克风
  getDevices() {}

  ///创建 webRtcView
  Future<WebRtcView?> createdView(String viewId, bool isSelf) async {
    try {
      WebRtcView view = await _createView(viewId: viewId, isSelf: isSelf);
      _rtcList.add(view);
      return view;
    } catch (e) {
      Log.error("创建 Webrtcview 错误 $e");
      return null;
    }
  }

  /// 销毁指定的 webRtcView
  deleteView(String viewId) {
    int index = _rtcList.indexWhere((item) => item.viewId == viewId);
    if (index != -1) {
      WebRtcView view = _rtcList[index];
      view.pc?.dispose();
      view.viewRenderer.srcObject?.dispose();
      view.viewRenderer.srcObject = null;
      _rtcList.removeAt(index);
    }
  }

  /// 销毁所有 webRtcView
  dispose() {
    for (var item in _rtcList) {
      item.pc?.dispose();
      item.viewRenderer.srcObject = null;
      item.viewRenderer.srcObject?.dispose();
    }
    _rtcList.clear();
    _localStream?.dispose();
  }

  /// 创建本地描述 offer
  Future<RTCSessionDescription> createOffer(RTCPeerConnection pc) async {
    RTCSessionDescription s = await pc.createOffer();
    await pc.setLocalDescription(_fixSdp(s));
    return s;
  }

  /// 创建 应答 _createAnswer
  Future<RTCSessionDescription> createAnswer(RTCPeerConnection pc) async {
    RTCSessionDescription s = await pc.createAnswer();
    await pc.setLocalDescription(_fixSdp(s));
    return s;
  }

  /// 设置指定 webRtcView description
  Future setRemote(WebRtcView view, RTCSessionDescription description) async {
    try {
      if (view.pc != null) {
        await view.pc!.setRemoteDescription(description);
      }
    } catch (e) {
      Log.error("设置指定的 webrtcView 描述 错误 $e");
    }
  }

  /// 获取指定的 webRtcView
  WebRtcView? getView(String viewId) {
    int index = _rtcList.indexWhere((item) => item.viewId == viewId);
    if (index == -1) return null;
    return _rtcList[index];
  }

  /// 开关扬声器
  Future<void> exocytosisAudio(bool b) async {
    Helper.setSpeakerphoneOn(b);
  }

  /// 切换前后摄像头
  Future<void> switchCamera() async {
    List<MediaStreamTrack>? track = _localStream?.getVideoTracks();
    if (track != null && track.isNotEmpty) {
      Helper.switchCamera(track[0]);
    }
  }

  /// 麦克风静音
  Future<void> switchMuted(bool enable) async {
    List<MediaStreamTrack>? tracks = _localStream?.getAudioTracks();
    if (tracks != null && tracks.isNotEmpty) {
      await Helper.setMicrophoneMute(enable, tracks[0]);
    }
  }

  String get sdpSemantics => 'unified-plan';

  // 推流参数
  final Map<String, dynamic> _mediaConstraints = {
    "audio": {
      "sampleRate": {"exact": '48000'}, // 采样率
      "sampleSize": {"exact": '16'}, // 采样位数
      "channelCount": {"exact": '1'}, // 声道
      "echoCancellation": true, // 回音消除
      "autoGainControl": true, // 自动增益
      "noiseSuppression": true // 降噪
    },
    "video": {
      'mandatory': {
        'minWidth': '1920',
        'minHeight': '1080',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };

  final List<RTCRtpSender> _senders = <RTCRtpSender>[];

  // 本地视频流
  MediaStream? _localStream;
  Future<MediaStream> createLocalStream() async {
    late MediaStream stream;
    stream = await navigator.mediaDevices.getUserMedia(_mediaConstraints);
    return stream;
  }

  Future<WebRtcView> _createView(
      {required String viewId, required bool isSelf}) async {
    RTCVideoRenderer viewRenderer = RTCVideoRenderer();
    await viewRenderer.initialize();
    WebRtcView view = WebRtcView(viewId: viewId, viewRenderer: viewRenderer);

    // 是否是自己
    if (isSelf) {
      _localStream = await createLocalStream();
      viewRenderer.srcObject = _localStream;
      await createPreConnect(view);
    }
    return view;
  }

  /// 创建会话 链接
  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {'url': 'stun:stun4.l.google.com:19302'},
    ]
  };
  Future<void> createPreConnect(WebRtcView view) async {
    RTCPeerConnection pc = await createPeerConnection(_iceServers);
    pc.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        _onRemoteAddStream.call(event.streams[0]);
      }
    };
    _localStream!.getTracks().forEach((track) async {
      _senders.add(await pc.addTrack(track, _localStream!));
    });

    pc.onIceConnectionState = (candidate) async {
      // print("flutter -- rtc 链接 ----------- $candidate");
    };

    pc.onConnectionState = (state) {
      // print("flutter --rtc ice对等 链接 状态 ----------- $state");
    };
    pc.onIceCandidate = (RTCIceCandidate? candidate) {
      if (candidate == null) return;
      //需要此延迟，以便有足够的时间尝试ICE候选人
      //然后跳到下一个。1秒只是一个启发式值
      //并且应该在您自己的环境中进行彻底的测试。
      Future.delayed(const Duration(seconds: 1), () {
        _onIceCandidate.call(candidate);
      });
    };
    pc.onRemoveStream = (stream) {
      _onRemoveStream?.call(stream);
    };

    view.pc = pc;
  }

  RTCSessionDescription _fixSdp(RTCSessionDescription s) {
    var sdp = s.sdp;
    s.sdp =
        sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
    return s;
  }
}

class WebRtcView {
  WebRtcView({required this.viewId, required this.viewRenderer});

  String viewId;
  RTCPeerConnection? pc;
  RTCVideoRenderer viewRenderer;
  RTCSessionDescription? sdp;
  List<RTCIceCandidate> remoteCandidates = [];

  /// 视频画面是否可用
  /// 目前 webrtc 不支持通过对方关闭摄像头 然后流回调告诉我们
  /// 所以我们只能自己手动维护 触发 WebRtcViewWidget 更新显示占位图
  getx.RxBool isVideoEnabled = false.obs;

  /// 是否静音 默认 false
  bool get muted => viewRenderer.srcObject?.getAudioTracks()[0].muted ?? false;

  /// 摄像头是否开启 通过流读取 但是不能实时 只能自己手动刷新页面触发
  bool get videoEnabled {
    List<MediaStreamTrack>? tracks = viewRenderer.srcObject?.getVideoTracks();
    if (tracks == null || tracks.isEmpty) return false;
    return tracks[0].enabled;
  }

  /// 开关音频流 和静音不是一个效果 而是直接不传输音频流
  bool switchAudioOf(bool enable) {
    List<MediaStreamTrack>? list = viewRenderer.srcObject?.getAudioTracks();
    if (list == null || list.isEmpty) return false;
    for (var tranck in list) {
      tranck.enabled = enable;
    }
    return true;
  }

  /// 开关视频流
  bool switchVideoPusdher(bool b) {
    List<MediaStreamTrack>? list = viewRenderer.srcObject?.getVideoTracks();
    if (list == null || list.isEmpty) return false;
    for (var track in list) {
      track.enabled = b;
    }
    return true;
  }
}

/// webrtc view 视图
/// 通过该 view 可以知道对方是否显示画面
/// 未显示画面可展示占位图
class WebRtcViewWidget extends StatefulWidget {
  const WebRtcViewWidget({
    super.key,
    required this.view,
    this.placeholder,
    this.mirror = false,
  });

  /// 模型控制器
  final WebRtcView view;

  /// 是否翻转
  final bool mirror;

  /// 占位 widget
  final Widget? placeholder;

  @override
  State<WebRtcViewWidget> createState() => _WebRtcViewWidgetState();
}

class _WebRtcViewWidgetState extends State<WebRtcViewWidget> {
  /// 画面第一帧回调
  onFristFrame() {
    Log.info("webrtc 画面第一帧展示");
    if (widget.view.videoEnabled) {
      widget.view.isVideoEnabled.value = true;
    }
  }

  /// 画面大小变化
  onResize() {
    Log.info("webrtc 画面 size 变化");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.view.viewRenderer.onFirstFrameRendered = onFristFrame;
    widget.view.viewRenderer.onResize = onResize;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.view.isVideoEnabled.value) {
        return RTCVideoView(
          widget.view.viewRenderer,
          mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          placeholderBuilder: (context) {
            return placeholder();
          },
        );
      } else {
        return placeholder();
      }
    });
  }

  Widget placeholder() {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          tileMode: TileMode.repeated,
          colors: [
            Colors.black54,
            Colors.black26,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// 一开始是想这里销毁  但是因为 webrtc 可能会全局展示 所以销毁交给创建他的对象去自己管理
    // widget.view.viewRenderer.dispose();
    super.dispose();
  }
}
