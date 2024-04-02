import 'package:logger/logger.dart';

class Log {
  static final Log _instance = Log._internal();
  factory Log() {
    return _instance;
  }
  Log._internal();
  static final Logger _logger = Logger();

  /// 日志级别设置 可以过滤部分日志
  static void setLevel(Level level) {
    Logger.level = level;
  }

  /// 复杂内容输出
  static void verbose(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// debug 输出
  static void debug(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.d(message);
  }

  /// 基本信息输出
  static void info(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// 警告输出
  static void warning(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// 错误输出
  static void error(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
