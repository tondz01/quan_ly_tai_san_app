import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class TypeAssetRepository extends ApiBase {
  Future<Map<String, dynamic>> getListTypeAssetRepository(
    String idCongTy,
  ) async {
    List<TypeAsset> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.TYPE_ASSET,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<TypeAsset>(
        response.data,
        TypeAsset.fromJson,
      );
    } catch (e) {
      SGLog.info("Repository", "Error at getList - TypeAssetRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createTypeAssetRepository(
    TypeAsset params,
  ) async {
    TypeAsset? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.TYPE_ASSET,
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_NO_CONTENT) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = TypeAsset.fromJson(response.data);
    } catch (e) {
      SGLog.info("Repository", "Error at create - TypeAssetRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateTypeAssetRepository(
    TypeAsset params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.TYPE_ASSET}/$id',
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info("Repository", "Error at update - TypeAssetRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteTypeAssetRepository(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.TYPE_ASSET}/$id');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info("Repository", "Error at delete - TypeAssetRepository: $e");
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
        '${EndPointAPI.TYPE_ASSET}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "TypeAssetRepository",
        "Error at insertDataFile - TypeAssetRepository: $e",
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
        '${EndPointAPI.TYPE_ASSET}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "TypeAssetRepository",
        "Error at insertDataFileBytes - TypeAssetRepository: $e",
      );
    }
    return result;
  }

  Future<Map<String, dynamic>> saveTypeAssetBatch(
    List<TypeAsset> typeAssets,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.TYPE_ASSET}/batch',
        data: jsonEncode(typeAssets),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<TypeAsset>(
        response.data,
        TypeAsset.fromJson,
      );
    } catch (e) {
      SGLog.error("TypeAssetRepository", "Error at saveTypeAssetBatch: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteTypeAssetBatchIds(List<String> ids) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.TYPE_ASSET}/batch',
        data: ids,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<TypeAsset>(
        response.data,
        TypeAsset.fromJson,
      );
    } catch (e) {
      SGLog.error(
        "TypeAssetRepository",
        "Error at deleteTypeAssetBatchIds: $e",
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
        "TypeAssetRepository",
        "Error at getConvertedPdfPreview: $e",
      );
    }

    return result;
  }
}
