import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 文件缓存管理器
class FileCacheManager {
  static const key = 'flutter_app_cache_manager';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  static Future<File> getSingleFile(
    String url, {
    String? key,
    Map<String, String>? headers,
  }) async {
    return await instance.getSingleFile(url, key: key, headers: headers);
  }

  /// 获取缓存文件
  static Future<FileInfo?> getFileFromCache(String? url,
      {bool ignoreMemCache = false}) async {
    if (url != null && url.isNotEmpty) {
      return await instance.getFileFromCache(
        url,
        ignoreMemCache: ignoreMemCache,
      );
    }
    return null;
  }

  /// 下载文件缓存
  static Future<FileInfo> downloadFile(String url,
      {String? key,
      Map<String, String>? authHeaders,
      bool force = false}) async {
    return await instance.downloadFile(
      url,
      key: key,
      authHeaders: authHeaders,
      force: force,
    );
  }

  /// 获取缓存文件流
  static Stream<FileResponse> getFileStream(String url,
      {String? key, Map<String, String>? headers, bool withProgress = false}) {
    return instance.getFileStream(
      url,
      key: key,
      headers: headers,
      withProgress: withProgress,
    );
  }

  /// 删除缓存文件
  static Future<void> removeFile(String key) async {
    return instance.removeFile(key);
  }

  /// 删除所有缓存文件
  static Future<void> emptyCache() {
    return instance.emptyCache();
  }
}
