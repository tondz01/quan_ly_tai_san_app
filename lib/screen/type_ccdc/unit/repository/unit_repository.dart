import 'dart:convert';
import 'dart:async'; // Add this import for unawaited
import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import '../../../core/utils/response_parser.dart';

class UnitRepository extends ApiBase {
  Future<Map<String, dynamic>> getListUnit() async {
    List<UnitDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.UNIT);
      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<UnitDto>(
        response.data,
        UnitDto.fromJson,
      );
    } catch (e) {
      SGLog.error("UnitRepository", "Error at getListUnit: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi lấy danh sách đơn vị: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> createUnit(UnitDto params) async {
    UnitDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await post(EndPointAPI.UNIT, data: params.toJson());

      log('createUnit: ${params.toJson()}');

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = UnitDto.fromJson(response.data);
    } catch (e) {
      SGLog.error("UnitRepository", "Error at createUnit: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi tạo đơn vị: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> updateUnit(
    UnitDto params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.UNIT}/$id',
        data: params.toJson(),
      );

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("UnitRepository", "Error at updateUnit: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi cập nhật đơn vị: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteUnit(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.UNIT}/$id');
      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("UnitRepository", "Error at deleteUnit: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi xóa đơn vị: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> saveUnitBatch(List<UnitDto> units) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.UNIT}/batch',
        data: jsonEncode(units),
      );

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<UnitDto>(
        response.data,
        UnitDto.fromJson,
      );
    } catch (e) {
      SGLog.error("UnitRepository", "Error at saveUnitBatch: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi import đơn vị: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteUnitBatch(List<String> ids) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.UNIT}/batch', data: ids);

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<UnitDto>(
        response.data,
        UnitDto.fromJson,
      );
    } catch (e) {
      SGLog.error("UnitRepository", "Error at deleteUnitBatch: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi xóa danh sách đơn vị: $e';
    }

    return result;
  }
}
