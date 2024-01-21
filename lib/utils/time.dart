import 'package:date_time_format/date_time_format.dart';

/// 时间工具
class TimeUtil {
  static String formatTime(int? timeStamp, {String format = 'm-d H:i'}) {
    if (timeStamp == null) return '';
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return date.format(format);
  }
}
