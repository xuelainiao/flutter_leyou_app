import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// webRtc 实例控制类
class WebRtcController {
  WebRtcController({
    Function(WebRtcView)? createLocalStream,
    Function(WebRtcView)? createRemoteStream,
    Function()? destroyStream,
    Function()? destroyRemoteStream,
  }) {
    _createLocalStream = createLocalStream;
    _createRemoteStream = createRemoteStream;
    _destroyStream = destroyStream;
  }

  // 当前推拉视频流队列
  List<WebRtcView> _rtcList = [];

  /// 本地视频流创建回调
  Function(WebRtcView)? _createLocalStream;

  /// 远程视频流创建回调
  Function(WebRtcView)? _createRemoteStream;

  /// 视频流销毁
  Function()? _destroyStream;

  /// 获取设备信息
  getDevices() {}

  /// 权限检测
  ///

  ///创建 webRtcView
  createdView(String viewId, BuildContext context, bool isSelf) async {
    // this._createSession(peerId: peerId, sessionId:);
    WebRtcView view =
        await _createView(viewId: viewId, context: context, isSelf: isSelf);
    _rtcList.add(view);
    _createLocalStream?.call(view);
  }

  /// 销毁指定的 webRtcView
  deleteView(String viewId) {
    int index = _rtcList.indexWhere((item) => item.viewId == viewId);
    if (index != -1) {
      WebRtcView view = _rtcList[index];
      view.viewRenderer?.srcObject?.dispose();
      view.viewRenderer?.srcObject = null;
      _rtcList.removeAt(index);
      _destroyStream?.call();
    }
  }

  /// 更新指定的 webRtcView
  updateView() {}

  /// 获取指定的 webRtcView
  getView(int viewId) {}

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
      "focusMode": 'continuous', // 持续对焦
      "facingMode": 'user', // 前摄
      "frameRate": {"ideal": '30', 'min': '15'}, // 帧率
      "aspectRatio": 9 / 16,
      "width": {"ideal": '1920', "min": '1920'},
      "height": {"ideal": '1080', "min": '1080'}
    },
  };

  final List<RTCRtpSender> _senders = <RTCRtpSender>[];

  // 本地视频流
  MediaStream? _localStream;

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  Future<MediaStream> _createStream() async {
    late MediaStream stream;
    stream = await navigator.mediaDevices.getUserMedia(_mediaConstraints);
    // onLocalStream?.call(stream);
    return stream;
  }

  Future<WebRtcView> _createView(
      {required String viewId,
      required BuildContext context,
      required bool isSelf}) async {
    WebRtcView view = WebRtcView(viewId: viewId);

    RTCVideoRenderer viewRenderer = RTCVideoRenderer();
    await viewRenderer.initialize();
    view.viewRenderer = viewRenderer;

    // 创建链接
    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);

    // 是否是自己
    if (isSelf) {
      _localStream = await _createStream();
      _localStream?.getTracks().forEach((MediaStreamTrack track) async {
        var rtpSender = await pc.addTrack(track, _localStream!);
        _senders.add(rtpSender);
      });
      viewRenderer.srcObject = _localStream;
    }

    pc.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        viewRenderer.srcObject = event.streams[0];
      }
    };

    pc.onIceCandidate = (RTCIceCandidate? candidate) async {
      if (candidate == null) {
        debugPrint('onIceCandidate: complete!');
        return;
      }
    };

    pc.onIceConnectionState = (state) {};

    pc.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        // remoteRenderer.srcObject = event.streams[0];
      }
    };

    pc.onRemoveStream = (stream) {
      // onRemoveRemoteStream?.call(newSession, stream);
      // _remoteStreams.removeWhere((it) {
      //   return (it.id == stream.id);
      // });
    };

    view.pc = pc;
    return view;
  }

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {'OfferToReceiveAudio': true, 'OfferToReceiveVideo': true}
  };

  /// 创建 offer
  Future<RTCSessionDescription?> _createOffer(WebRtcView view) async {
    try {
      RTCSessionDescription s = await view.pc!.createOffer(_dcConstraints);
      await view.pc!.setLocalDescription(_fixSdp(s));
      return s;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  RTCSessionDescription _fixSdp(RTCSessionDescription s) {
    var sdp = s.sdp;
    s.sdp =
        sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
    return s;
  }
}

class WebRtcView {
  WebRtcView({required this.viewId});

  String viewId;
  RTCPeerConnection? pc;
  RTCVideoRenderer? viewRenderer;
  List<RTCIceCandidate> remoteCandidates = [];
}
