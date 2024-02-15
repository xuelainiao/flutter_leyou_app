import 'package:date_time_format/date_time_format.dart';

/// 时间工具
class TimeUtil {
  /// 时间格式化
  static String formatTime(int? timeStamp, {String format = 'm-d H:i'}) {
    if (timeStamp == null) return '';
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return date.format(format);
  }

  /// 时间格式化 根据最近时间动态切换
  static String formatTimeRecently(int? timeStamp) {
    if (timeStamp == null) return '';
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);
    String format = 'H:i';
    if (difference.inMinutes < 4) {
      return '刚刚';
    } else if (difference.inHours == 0) {
      return '${difference.inMinutes} 分钟以前';
    } else if (difference.inDays == 0 && difference.inHours > 0) {
      return '${difference.inHours} 小时前';
    } else if (difference.inDays > 1 && difference.inDays <= 31) {
      return '星期${date.weekday} ${date.format(format)}';
    } else if (date.year == now.year) {
      return date.format("d H:i");
    } else {
      return date.format("m-d H:i");
    }
  }

  /// 返回时间差
  static Duration timeDiffer(int? timeStamp) {
    if (timeStamp == null) return const Duration(milliseconds: 0);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    DateTime now = DateTime.now();
    return now.difference(date);
  }
}
