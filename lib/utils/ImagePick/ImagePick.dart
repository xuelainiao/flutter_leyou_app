import "dart:io";

import "package:images_picker/images_picker.dart";

class ImagePickerSingleton {
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
