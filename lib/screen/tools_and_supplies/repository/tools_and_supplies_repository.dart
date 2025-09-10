// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:async';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolsAndSuppliesRepository extends ApiBase {
  Future<Map<String, dynamic>> getListToolsAndSupplies(String idCongTy) async {
    List<ToolsAndSuppliesDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      // API call đầu tiên - lấy danh sách tools and supplies
      final response = await get(
        EndPointAPI.TOOLS_AND_SUPPLIES,
        queryParameters: {'idcongty': idCongTy},
      );

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data
      list = ResponseParser.parseToList<ToolsAndSuppliesDto>(
        response.data,
        ToolsAndSuppliesDto.fromJson,
      );

      // Gọi API detail cho từng item với error handling
      await Future.wait(
        list.map((e) async {
          try {
            final detailResponse = await get(
              '${EndPointAPI.OWNERSHIP_UNIT_DETAIL}/by-ccdcvt/${e.id}',
            );

            if (!checkStatusCodeFailed(detailResponse.statusCode ?? 0)) {
              e.detailOwnershipUnit =
                  ResponseParser.parseToList<OwnershipUnitDetailDto>(
                    detailResponse.data['data'],
                    OwnershipUnitDetailDto.fromJson,
                  );
            } else {
              e.detailOwnershipUnit = [];
            }
          } catch (detailError) {
            e.detailOwnershipUnit = [];
          }
        }),
      );
      result['data'] = list;
    } catch (e) {
      log("Error at getListToolsAndSupplies - ToolsAndSuppliesRepository: $e");
      result['status_code'] = Numeral.STATUS_CODE_DEFAULT;
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
      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
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
    SGLog.debug(
      'ToolsAndSuppliesRequest 2',
      'Request payload: ${params.toJson()}',
    );
    try {
      final response = await post(
        EndPointAPI.TOOLS_AND_SUPPLIES,
        data: params.toJson(),
      );

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
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

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
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

  Future<Map<String, dynamic>> deleteToolsAndSupplies(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.TOOLS_AND_SUPPLIES}/$id');

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
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
