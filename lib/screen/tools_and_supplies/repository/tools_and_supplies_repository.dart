// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:async';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class ToolsAndSuppliesRepository extends ApiBase {
  // Path to the local JSON file for mock data
  // static const String _mockDataPath =
  //     'lib/screen/tools_and_supplies/model/tools_and_supplies_data.json';

  Future<Map<String, dynamic>> getListToolsAndSupplies(String idCongTy) async {
    List<ToolsAndSuppliesDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
  
    try {
      final response = await get(
        EndPointAPI.TOOLS_AND_SUPPLIES,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<ToolsAndSuppliesDto>(
        response.data,
        ToolsAndSuppliesDto.fromJson,
      );
    } catch (e) {
      log("Error at getListToolsAndSupplies - ToolsAndSuppliesRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getListPhongBan(String idCongTy) async {
    List<PhongBan> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.PHONG_BAN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<PhongBan>(
        response.data,
        PhongBan.fromJson,
      );
    } catch (e) {
      log("Error at getListPhongBan - ToolsAndSuppliesRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createToolsAndSupplies(
    ToolsAndSuppliesRequest params,
  ) async {
    ToolsAndSuppliesDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.TOOLS_AND_SUPPLIES,
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at createAssetGroup - AssetGroupRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateToolsAndSupplies(
    ToolsAndSuppliesRequest params,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.TOOLS_AND_SUPPLIES}/${params.id}',
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateToolsAndSupplies - ToolsAndSuppliesRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteToolsAndSupplies(
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.TOOLS_AND_SUPPLIES}/$id',
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateToolsAndSupplies - ToolsAndSuppliesRepository: $e");
    }

    return result;
  }
}
