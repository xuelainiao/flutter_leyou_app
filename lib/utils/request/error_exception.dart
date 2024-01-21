/// 请求自定义错误对象
/// 之所以创建这个 是为了让开发者 只专注于 code 处理 虽然可以通过 dio 获取
class ApiError implements Exception {
  late int errCode;
  late String errMsg;

  ApiError({required code, required msg}) {
    errCode = code;
    errMsg = msg;
  }

  @override
  String toString() {
    return '请求错误: [Code $errCode] $errMsg';
  }
}
