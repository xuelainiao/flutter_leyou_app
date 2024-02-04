import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:mall_community/utils/permission/permission.dart';
import 'package:mall_community/utils/request/dio.dart';
import 'package:mall_community/utils/toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 音频录音播放
class SoundRecording {
  static final SoundRecording _instance = SoundRecording._internal();
  factory SoundRecording() {
    _instance.init();
    return _instance;
  }
  SoundRecording._internal();

  Timer? timer;
  Duration? currentDuration;
  FlutterSoundRecorder? recorderModule;
  FlutterSoundPlayer? playerModule;
  StreamSubscription? recorderSubscription;
  StreamSubscription? playerSubscription;

  init() {
    recorderModule ??= FlutterSoundRecorder();
    // recorderModule?.setLogLevel(LEVEL.INFO);
  }

  /// 开始录音
  startRecording(
    Function(RecordingDisposition? e, dynamic err, PlayerStatus state)
        callback, {
    Duration duration = const Duration(seconds: 60),
  }) async {
    try {
      bool perStatus = await AppPermission.getPermission(Permission.microphone);
      if (perStatus) {
        Directory tempDir = await getTemporaryDirectory();
        String path = '${tempDir.path}/flutter_${ext[Codec.aacADTS.index]}';
        await recorderModule?.openRecorder();
        await recorderModule?.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
          bitRate: 8000,
          numChannels: 1,
          sampleRate: 8000,
        );
        // 设置订阅回调时长
        recorderModule
            ?.setSubscriptionDuration(const Duration(milliseconds: 200));
        // 监听录音
        recorderSubscription = recorderModule?.onProgress?.listen(
          (RecordingDisposition e) {
            currentDuration = e.duration;
            callback(e, null, PlayerStatus.run);
          },
          onError: (err) {
            debugPrint('录音错误 $err');
            callback(null, err, PlayerStatus.error);
          },
          onDone: () {
            callback(null, null, PlayerStatus.finished);
          },
        );
        // 录音时长计时
        timer = Timer(duration, () {
          stopRecording();
          callback(null, '已达到录音时长上限', PlayerStatus.arrivalTime);
        });
        // // 即将达到录音时长上限提醒
        // if (duration.inSeconds > 20) {
        //   Timer(duration - const Duration(seconds: 5), () {
        //     ToastUtils.showToast('即将达到录音时长上限');
        //     callback(null, '即将到达录音时长上限', PlayerStatus.soonLimit);
        //   });
        // }
      } else {
        callback(null, "请允许APP获取麦克风权限", PlayerStatus.error);
      }
    } catch (e) {
      debugPrint("录音失败$e");
      callback(null, e, PlayerStatus.error);
    }
  }

  /// 结束录音
  Future<SoundResuelt?> stopRecording() async {
    try {
      cancelRecorderSubscriptions();
      timer?.cancel();
      timer = null;
      String? path = await recorderModule?.stopRecorder();

      /// 有时候未打开录音但是调用了结束就会返回这个
      if (path == "Recorder is not open") return null;
      return SoundResuelt({'url': path, 'second': currentDuration?.inSeconds});
    } catch (err) {
      debugPrint('停止录音错误 $err');
      return null;
    }
  }

  /// 取消录音监听
  void cancelRecorderSubscriptions() {
    recorderSubscription?.cancel();
    recorderSubscription = null;
  }

  /// 判断文件是否存在
  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  /// 上传临时录音
  Future<Map?> uploadSound(String path) async {
    try {
      ApiClient apiClient = ApiClient();
      if (await fileExists(path)) {
        dio.MultipartFile file = dio.MultipartFile.fromFileSync(
          path,
          filename:
              "${DateTime.now().microsecondsSinceEpoch}_${path.split("/").last}",
        );
        var result = await apiClient.uploadFile([file]);
        return result.data['list'][0];
      }
      return null;
    } catch (e) {
      ToastUtils.showToast('上传录音错误 请稍后再试');
      return null;
    }
  }

  /// 播放音频
  Future player(String path,
      Function(PlayerStatus status, {Duration? position}) callback) async {
    try {
      playerModule ??= FlutterSoundPlayer();
      await playerModule?.closePlayer();
      await playerModule?.openPlayer();

      if (path.contains('http')) {
        await playerModule?.startPlayer(
          fromURI: path,
          codec: Codec.mp3,
          sampleRate: 44000,
          whenFinished: () {
            callback(PlayerStatus.finished);
            stopPlayer();
          },
        );
      } else {
        if (await fileExists(path)) {
          if (playerModule!.isPlaying) {
            playerModule?.stopPlayer();
          }
          await playerModule?.startPlayer(
              fromURI: path,
              codec: Codec.aacADTS,
              sampleRate: 44000,
              whenFinished: () {
                callback(PlayerStatus.finished);
                stopPlayer();
              });
        } else {
          ToastUtils.showToast('播放音频文件不存在');
          callback(PlayerStatus.error);
          return;
        }
      }
      callback(PlayerStatus.run);
      playerModule?.setSubscriptionDuration(const Duration(milliseconds: 500));

      //监听播放进度
      playerSubscription =
          playerModule?.onProgress!.listen((PlaybackDisposition e) {
        callback(PlayerStatus.run, position: e.position);
      });
    } catch (e) {
      ToastUtils.showToast('播放音频错误 请稍后再试');
      callback(PlayerStatus.error);
    }
  }

  /// 结束播放
  stopPlayer() async {
    await playerModule?.stopPlayer();
    cancelPlayerSubscriptions();
  }

  /// 结束播放监听
  cancelPlayerSubscriptions() {
    playerSubscription?.cancel();
    playerSubscription = null;
  }

  /// 设置音频会话
  setAudioSession() async {
    //这块是设置音频，暂时没用到可以不用设置
    // final session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration(
    //   avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
    //   avAudioSessionCategoryOptions:
    //       AVAudioSessionCategoryOptions.allowBluetooth |
    //           AVAudioSessionCategoryOptions.defaultToSpeaker,
    //   avAudioSessionMode: AVAudioSessionMode.spokenAudio,
    //   avAudioSessionRouteSharingPolicy:
    //       AVAudioSessionRouteSharingPolicy.defaultPolicy,
    //   avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    //   androidAudioAttributes: const AndroidAudioAttributes(
    //     contentType: AndroidAudioContentType.speech,
    //     flags: AndroidAudioFlags.none,
    //     usage: AndroidAudioUsage.voiceCommunication,
    //   ),
    //   androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    //   androidWillPauseWhenDucked: true,
    // ));
  }

  ///释放录音
  dispose() async {
    try {
      await recorderModule?.closeRecorder();
      await playerModule?.closePlayer();
      cancelRecorderSubscriptions();
      cancelPlayerSubscriptions();
    } catch (e) {
      debugPrint('释放录音错误 $e');
    }
  }
}

/// 录音|播放状态
enum PlayerStatus {
  /// 工作中
  run,

  /// 暂停
  pause,

  /// 停止
  stop,

  /// 即将到达上限
  soonLimit,

  /// 已达到录音时长上限
  arrivalTime,

  /// 完成
  finished,

  /// 错误
  error
}

class SoundResuelt {
  late String url;
  late int second;

  SoundResuelt(json) {
    url = json['url'] ?? '';
    second = json['second'] ?? 0;
  }

  toJson() {
    return jsonEncode({'url': url, 'second': second});
  }
}
