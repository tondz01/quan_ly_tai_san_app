import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ConvertPdfRepository extends ApiBase {

  Future<Map<String, dynamic>> convertDocxToPdfBytes({
    required String fileName,
    required Uint8List fileBytes,
    String? jsessionId,
  }) async {
    Map<String, dynamic> result = {
      'data': Uint8List(0),
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      final response = await post(
        '${EndPointAPI.UPLOAD_FILE}/convert/docx-to-pdf',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.bytes,
          headers: {
            'Accept': 'application/pdf',
            if (jsessionId != null && jsessionId.isNotEmpty)
              'Cookie': 'JSESSIONID=$jsessionId',
          },
        ),
      );

      result['status_code'] = response.statusCode;
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS &&
          response.data is List<int>) {
        result['data'] = Uint8List.fromList(response.data);
      }
    } catch (e) {
      SGLog.error(
        'ConvertPdfRepository',
        'Error at convertDocxToPdfBytes: $e',
      );
    }

    return result;
  }
}


