class ApiResponse<T> {
  ApiResponse({
    required this.code,
    required this.msg,
    required this.data,
  });
  late final int code;
  late final String msg;
  late T data;

  ApiResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'] is List ? json['msg'].join() : json['msg'] ?? '';
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['data'] = data;
    return data;
  }
}
