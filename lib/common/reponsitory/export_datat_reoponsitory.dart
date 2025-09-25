import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import 'save_export_file_stub.dart'
    if (dart.library.html) 'save_export_file_web.dart'
    if (dart.library.io) 'save_export_file_io.dart';

class ExportDataReponsitory extends ApiBase {
  Future<Map<String, dynamic>> exportData(
    List<dynamic> data,
    String fileName,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': -1,
      'message': '',
    };

    try {
      final response = await post(
        EndPointAPI.EXPORT_DATA,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.bytes, // nhận binary data
        ),
      );

      // Lưu file ra máy (ví dụ Excel)
      final bytes = Uint8List.fromList(response.data);
      final savedPath = await saveExportFile(bytes, '$fileName.xlsx');

      // Sửa logic kiểm tra lỗi
      if (savedPath.startsWith("404/")) {
        final error = savedPath.substring(4); // Bỏ "404/" prefix
        result['message'] = "Lỗi khi xuất file dữ liệu: $error";
        result['status_code'] = Numeral.NOTFOUND_EXCEPTION_CODE;
        SGLog.error("ExportDataReponsitory", "Error at saveExportFile: $error");
      } else if (savedPath == "download_triggered") {
        result['message'] = "✅ File đã trigger download trên Web";
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      } else {
        result['message'] = "✅ File đã lưu ở: $savedPath";
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      }
    } catch (e) {
      result['message'] = "Error at exportData: $e";
      SGLog.error("ExportDataReponsitory", "Error at exportData: $e");
    }

    return result;
  }
}
