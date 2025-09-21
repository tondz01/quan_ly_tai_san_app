import 'dart:convert';
import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/model/permission_dto.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class PermissionRepository extends ApiBase {
  Future<Map<String, dynamic>> setPermissionBatch(
    List<PermissionDto> permissions,
  ) async {
    log("Setting batch permissions1: ${permissions.length} items");
    Map<String, dynamic> result = {
      'data': <PermissionDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };
    try {
      final url = '${EndPointAPI.PERMISSIONS}/set-permission-batch';
      final body = permissions.map((e) => e.toJson()).toList();
      SGLog.info(
        "PermissionRepository",
        "Set permission batch: ${jsonEncode(body)}",
      );
      final response = await post(url, data: jsonEncode(body));
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? '';
        return result;
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      List<PermissionDto> permissionResult =
          (response.data['data'] as List)
              .map((e) => PermissionDto.fromJson(e))
              .toList();
      SGLog.info(
        "PermissionRepository",
        "Set permission batch success: ${permissionResult.length}",
      );
      result['data'] = permissionResult;
    } catch (e) {
      SGLog.error("PermissionRepository", "Error at setPermissionBatch: $e");
      result['message'] = e.toString();
    }
    return result;
  }

  Future<Map<String, dynamic>> getAllPermissionsByUserId(String userId) async {
    Map<String, dynamic> result = {
      'data': <PermissionDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };
    try {
      final response = await get('${EndPointAPI.PERMISSIONS}/user/$userId');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      List<PermissionDto> permissions =
          (response.data as List)
              .map((e) => PermissionDto.fromJson(e))
              .toList();
      result['data'] = permissions;
    } catch (e) {
      SGLog.error(
        "PermissionRepository",
        "Error at getAllPermissions - PermissionRepository: $e",
      );
      result['message'] = e.toString();
    }
    return result;
  }

  Future<Map<String, dynamic>> updatePermissionBatch(
    List<PermissionDto> permissions,
  ) async {
    Map<String, dynamic> result = {
      'data': <PermissionDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };
    try {
      final url = '${EndPointAPI.PERMISSIONS}/update-permission-batch';
      final body = permissions.map((e) => e.toJson()).toList();
      final response = await put(url, data: jsonEncode(body));
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'] ?? '';
        return result;
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      List<PermissionDto> permissionResult =
          (response.data as List)
              .map((e) => PermissionDto.fromJson(e))
              .toList();
      SGLog.info(
        "PermissionRepository",
        "Update permission batch success: ${permissionResult.length}",
      );
      result['data'] = permissionResult;
    } catch (e) {
      SGLog.error("PermissionRepository", "Error at updatePermissionBatch: $e");
      result['message'] = e.toString();
    }
    return result;
  }
}
