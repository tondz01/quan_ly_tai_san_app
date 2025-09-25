import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CcdcGroupRepository extends ApiBase {
  Future<Map<String, dynamic>> getListCcdcGroupRepository(
    String idCongTy,
  ) async {
    List<CcdcGroup> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.CCDC_GROUP,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<CcdcGroup>(
        response.data,
        CcdcGroup.fromJson,
      );
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at getCcdcGroup - CcdcGroupRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createCcdcGroupRepository(
    CcdcGroup params,
  ) async {
    CcdcGroup? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.CCDC_GROUP,
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_NO_CONTENT) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = CcdcGroup.fromJson(response.data);
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at createCcdcGroup - CcdcGroupRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateCcdcGroupRepository(
    CcdcGroup params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.CCDC_GROUP}/$id',
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at updateCcdcGroup - CcdcGroupRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteCcdcGroupRepository(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.CCDC_GROUP}/$id');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at deleteCcdcGroup - CcdcGroupRepository: $e",
      );
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
        '${EndPointAPI.CCDC_GROUP}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "CcdcGroupRepository",
        "Error at insertDataFile - CcdcGroupRepository: $e",
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
        '${EndPointAPI.CCDC_GROUP}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "CcdcGroupRepository",
        "Error at insertDataFileBytes - CcdcGroupRepository: $e",
      );
    }
    return result;
  }

    Future<Map<String, dynamic>> saveCcdcGroupBatch(
    List<CcdcGroup> ccdcGroup,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.CCDC_GROUP}/batch',
        data: jsonEncode(ccdcGroup),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<CcdcGroup>(
        response.data,
        CcdcGroup.fromJson,
      );
    } catch (e) {
      log("Error at saveCcdcGroupBatch - CcdcGroupRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteCcdcGroupBatch(Map<String, dynamic> data) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.CCDC_GROUP}/batch',
        data: data,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<CcdcGroup>(
        response.data,
        CcdcGroup.fromJson,
      );
    } catch (e) {
      log("Error at deleteCcdcGroupBatch - CcdcGroupRepository: $e");
    }

    return result;
  }
}
