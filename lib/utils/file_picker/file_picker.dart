import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/utils/request/dio.dart';

/// app 选择文件
class AppFilePicker {
  ///选择单个文件
  ///并且是过滤的
  ///pdf doc docx xls xlsx ppt pptx txt
  static Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt'],
    );
  }

  /// 选择单个文件并且上传到服务器返回在线地址
  static Future<FileMsgInfo?> selectFileuploadFile() async {
    ApiClient apiClient = ApiClient();
    FilePickerResult? result = await pickFile();
    if (result == null) return null;

    var file = dio.MultipartFile.fromFileSync(
      result.files[0].path!,
      filename: result.files[0].name,
    );
    var resultFile = await apiClient.uploadFile([file]);
    FileMsgInfo fileMsgInfo = FileMsgInfo({
      'content': '${resultFile.data['list'][0]['url']}',
      'fileName': file.filename,
      'fileSize': file.length,
      'requestId': resultFile.data['list'][0]['requestId']
    });
    return fileMsgInfo;
  }

  /// 保存文件/另存为对话框
  static Future<String?> saveFile(fileName) async {
    return await FilePicker.platform.saveFile(
      dialogTitle: '请选择一个输出文件',
      fileName: fileName,
    );
  }
}
