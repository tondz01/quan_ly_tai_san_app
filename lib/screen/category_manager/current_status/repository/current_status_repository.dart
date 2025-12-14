import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CurrentStatusRepository extends ApiBase {
  Future<Map<String, dynamic>> getListCurrentStatusRepository(
    String idCongTy,
  ) async {
    List<CurrentStatus> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.CURRENT_STATUS,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<CurrentStatus>(
        response.data,
        CurrentStatus.fromJson,
      );
    } catch (e) {
      SGLog.info("Repository", "Error at getList - CurrentStatusRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createCurrentStatusRepository(
    CurrentStatus params,
  ) async {
    CurrentStatus? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.CURRENT_STATUS,
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_NO_CONTENT) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = CurrentStatus.fromJson(response.data);
    } catch (e) {
      SGLog.info("Repository", "Error at create - CurrentStatusRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateCurrentStatusRepository(
    CurrentStatus params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.CURRENT_STATUS}/$id',
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info("Repository", "Error at update - CurrentStatusRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteCurrentStatusRepository(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.CURRENT_STATUS}/$id');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info("Repository", "Error at delete - CurrentStatusRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> insertDataFile(String filePath) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final fileName = filePath.split(RegExp(r'[\\/]+')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await post(
        '${EndPointAPI.CURRENT_STATUS}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "CurrentStatusRepository",
        "Error at insertDataFile - CurrentStatusRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> insertDataFileBytes(
    String fileName,
    Uint8List fileBytes,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });
      final response = await post(
        '${EndPointAPI.CURRENT_STATUS}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "CurrentStatusRepository",
        "Error at insertDataFileBytes - CurrentStatusRepository: $e",
      );
    }
    return result;
  }

  Future<Map<String, dynamic>> saveCurrentStatusBatch(
    List<CurrentStatus> currentStatuss,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.CURRENT_STATUS}/batch',
        data: jsonEncode(currentStatuss),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<CurrentStatus>(
        response.data,
        CurrentStatus.fromJson,
      );
    } catch (e) {
      SGLog.error("CurrentStatusRepository", "Error at saveCurrentStatusBatch: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteCurrentStatusBatchIds(List<String> ids) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.CURRENT_STATUS}/batch',
        data: ids,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<CurrentStatus>(
        response.data,
        CurrentStatus.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "CurrentStatusRepository",
        "Error at deleteCurrentStatusBatchIds: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> getConvertedPdfPreview(
    String previewFileNameOrPath, {
    String? jsessionId,
  }) async {
    Map<String, dynamic> result = {
      'data': Uint8List(0),
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      // Build endpoint. If caller passes full path like "/preview/example.pdf",
      // keep it; otherwise append to upload preview base.
      final String endpoint = previewFileNameOrPath.startsWith('/api')
          ? previewFileNameOrPath
          : '${EndPointAPI.UPLOAD_FILE}/preview/$previewFileNameOrPath';

      final response = await get(
        endpoint,
        options: Options(
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
      } else {
        result['data'] = Uint8List(0);
      }
    } catch (e) {
      SGLog.error(
        "CurrentStatusRepository",
        "Error at getConvertedPdfPreview: $e",
      );
    }

    return result;
  }
}
