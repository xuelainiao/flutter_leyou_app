import "package:flutter/widgets.dart";
import "package:images_picker/images_picker.dart";
import 'package:dio/dio.dart' as dio;
import "dart:io";
import "package:mall_community/utils/request/dio.dart";
import "package:mall_community/utils/toast/toast.dart";

ApiClient apiClient = ApiClient();

/// 图片选择器
class ImagePicker {
  /// 选择多个图像
  static Future<List<Media>?> pickImages({int maxImages = 1}) async {
    return await ImagesPicker.pick(
      count: maxImages,
      pickType: PickType.image,
    );
  }

  /// 选择单个视频
  static Future<List<Media>?> pickVideo({int maxImages = 1}) async {
    return await ImagesPicker.pick(
      count: maxImages,
      pickType: PickType.video,
    );
  }

  /// 拍照
  static Future<List<Media>?> takePhotos(String type,
      {int maxTime = 15}) async {
    return await ImagesPicker.openCamera(
      pickType: type == 'image' ? PickType.image : PickType.video,
      maxTime: maxTime,
      quality: 0.5, //控制质量 避免太大
    );
  }

  /// 保存图片或者视频到相册
  static Future<bool> saveFile(File file,
      {String albumName = "", String type = 'image'}) async {
    if (type == 'image') {
      return await ImagesPicker.saveImageToAlbum(file, albumName: albumName);
    } else {
      return await ImagesPicker.saveVideoToAlbum(file, albumName: albumName);
    }
  }
}

/// 选择相册并且上传到服务器返回在线地址
Future<List> selectImguploadFile() async {
  try {
    ToastUtils.showLoad();
    List<Media>? list = await ImagePicker.pickImages();
    if (list == null) return [];
    List<dio.MultipartFile> files = [];
    for (var item in list) {
      var file = dio.MultipartFile.fromFileSync(
        item.path,
        filename: item.path.split("/").last,
      );
      files.add(file);
    }
    var result = await apiClient.uploadFile(files);
    return result.data['list'];
  } catch (e) {
    debugPrint('选择图片上传失败 $e');
    ToastUtils.showToast('图片上传失败');
    return [];
  } finally {
    ToastUtils.hideLoad();
  }
}

/// 拍摄照片或者视频上传到服务器
/// 这是针对单个的
Future<Map?> taskPhone(String type) async {
  try {
    List<Media>? list = await ImagePicker.takePhotos(type);
    if (list == null) return null;
    ToastUtils.showLoad();
    List<dio.MultipartFile> files = [];
    files.add(dio.MultipartFile.fromFileSync(
      list[0].path,
      filename: list[0].path.split("/").last,
    ));
    if (list[0].thumbPath != null) {
      files.add(dio.MultipartFile.fromFileSync(
        list[0].thumbPath!,
        filename: list[0].thumbPath!.split("/").last,
      ));
    }
    var result = await apiClient.uploadFile(files, type: 'video');
    return result.data;
  } catch (e) {
    return null;
  } finally {
    ToastUtils.hideLoad();
  }
}
