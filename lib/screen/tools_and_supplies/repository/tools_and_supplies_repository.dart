// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/paged_response.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolsAndSuppliesRepository extends ApiBase {
  Future<Map<String, dynamic>> getListToolsAndSupplies(
    String idCongTy, {
    int page = 0,
    int size = 20,
    String? sortBy,
    String? sortDir,
    String? search,
  }) async {
    List<ToolsAndSuppliesDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'totalElements': 0,
      'totalPages': 1,
      'currentPage': 0,
    };

    try {
      // Build query parameters
      final queryParams = <String, dynamic>{
        'idcongty': idCongTy,
        'page': page,
        'size': size,
      };

      // Only add optional parameters if they have valid values
      if (sortBy != null && sortBy.trim().isNotEmpty) {
        queryParams['sortBy'] = sortBy.trim();
      }
      if (sortDir != null && sortDir.trim().isNotEmpty) {
        queryParams['sortDir'] = sortDir.trim();
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      // Log API call parameters for debugging
      log('Calling API: ${EndPointAPI.TOOLS_AND_SUPPLIES_PAGED}');
      log('Query params: $queryParams');

      // API call với pagination
      final response = await get(
        EndPointAPI.TOOLS_AND_SUPPLIES_PAGED,
        queryParameters: queryParams,
      );

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse paginated response
      // API returns: { items: [...], totalItems: 0, page: 0, size: 0, totalPages: 0, ... }
      final responseData =
          response.data is Map
              ? response.data as Map<String, dynamic>
              : <String, dynamic>{};

      final pagedResponse = PagedResponse<ToolsAndSuppliesDto>.fromJson(
        responseData,
        ToolsAndSuppliesDto.fromJson,
      );

      list = pagedResponse.data;
      result['data'] = list;
      result['totalElements'] = pagedResponse.totalElements;
      result['totalPages'] = pagedResponse.totalPages;
      result['currentPage'] = pagedResponse.currentPage;
      try {
        AccountHelper.instance.setListCCDC(list);
        if (AccountHelper.instance.getAllCCDC().isEmpty) {
          log("setCache [CDCD]: No CCDC cached in storage.");
        } else {
          log("setCache [CDCD]: CCDC data cached successfully.");
        }
      } catch (e) {
        log(
          "setCache [CDCD]: Error at setListCCDC - ToolsAndSuppliesRepository: $e",
        );
      }
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

  Future<Map<String, dynamic>> saveToolsAndSuppliesBatch(
    List<ToolsAndSuppliesDto> toolsAndSupplies,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.TOOLS_AND_SUPPLIES}/batch',
        data: jsonEncode(toolsAndSupplies),
      );

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
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
      log(
        "Error at saveToolsAndSuppliesBatch - ToolsAndSuppliesRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteToolsAndSuppliesBatch(
    List<String> data,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await delete(
        '${EndPointAPI.TOOLS_AND_SUPPLIES}/batch',
        data: jsonEncode(data),
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
      log(
        "Error at deleteToolsAndSuppliesBatch - ToolsAndSuppliesRepository: $e",
      );
    }

    return result;
  }
}
