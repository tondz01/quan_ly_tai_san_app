import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ReasonIncreaseRepository extends ApiBase {
  Future<Map<String, dynamic>> getListReasonIncreaseRepository(
  ) async {
    List<ReasonIncrease> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get("https://ecotel-odoo.id.vn:8386/api/lydotang");
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<ReasonIncrease>(
        response.data['data'],
        ReasonIncrease.fromJson,
      );
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at getReasonIncrease - ReasonIncreaseRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> createReasonIncreaseRepository(
    ReasonIncrease params,
  ) async {
    ReasonIncrease? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.REASON_INCREASE,
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE &&
          response.statusCode != Numeral.STATUS_CODE_SUCCESS_NO_CONTENT) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ReasonIncrease.fromJson(response.data);
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at createReasonIncrease - ReasonIncreaseRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateReasonIncreaseRepository(
    ReasonIncrease params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.REASON_INCREASE}/$id',
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
        "Error at updateReasonIncrease - ReasonIncreaseRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteReasonIncreaseRepository(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.REASON_INCREASE}/$id');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.info(
        "Repository",
        "Error at deleteReasonIncrease - ReasonIncreaseRepository: $e",
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
        '${EndPointAPI.REASON_INCREASE}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "ReasonIncreaseRepository",
        "Error at insertDataFile - ReasonIncreaseRepository: $e",
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
        '${EndPointAPI.REASON_INCREASE}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "ReasonIncreaseRepository",
        "Error at insertDataFileBytes - ReasonIncreaseRepository: $e",
      );
    }
    return result;
  }

  Future<Map<String, dynamic>> saveReasonIncreaseBatch(
    List<ReasonIncrease> list,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.REASON_INCREASE}/batch',
        data: jsonEncode(list),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<ReasonIncrease>(
        response.data,
        ReasonIncrease.fromJson,
      );
    } catch (e) {
      log("Error at saveReasonIncreaseBatch - ReasonIncreaseRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteReasonIncreaseBatch(
    List<String> ids,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.REASON_INCREASE}/batch',
        data: ids,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<ReasonIncrease>(
        response.data,
        ReasonIncrease.fromJson,
      );
    } catch (e) {
      log("Error at deleteReasonIncreaseBatch - ReasonIncreaseRepository: $e");
    }

    return result;
  }
}
