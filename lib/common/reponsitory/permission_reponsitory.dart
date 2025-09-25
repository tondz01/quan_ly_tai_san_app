import 'dart:convert';
import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/model/permission_dto.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:dio/dio.dart';

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

  Future<PermissionDto?> checkCreatePermission(String idUser) async {
    try {
      final response = await get('${EndPointAPI.PERMISSIONS}/check-create/$idUser');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        SGLog.error("PermissionRepository", "Check create failed: ${response.data['message']}");
        return null;
      }
      if (response.data['data'] == null) return null;
      return PermissionDto.fromJson(response.data['data']);
    } catch (e) {
      SGLog.error("PermissionRepository", "Error at checkCreatePermission: $e");
      return null;
    }
  }

  Future<bool?> checkCanCreatePermission(String userId, String permissionCode) async {
    return _checkPermissionAction(userId, permissionCode, 'cancreate');
  }

  Future<bool?> checkCanUpdatePermission(String userId, String permissionCode) async {
    return _checkPermissionAction(userId, permissionCode, 'canupdate');
  }

  Future<bool?> checkCanDeletePermission(String userId, String permissionCode) async {
    return _checkPermissionAction(userId, permissionCode, 'candelete');
  }

  Future<bool?> _checkPermissionAction(
    String userId,
    String permissionCode,
    String action,
  ) async {
    try {
      final response = await get(
        '${EndPointAPI.PERMISSIONS}/user/$userId/$action/$permissionCode',
        options: Options(
          headers: {
            'X-User-Id': userId,
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true,
          receiveDataWhenStatusError: true,
        ),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        SGLog.error(
          "PermissionRepository",
          "Check $action failed: ${response.data is Map ? response.data['message'] : response.statusMessage}",
        );
        return null;
      }

      final dynamic body = response.data;
      if (body is Map && body['data'] is Map) {
        // Map action to expected camelCase key in response data
        final key = action == 'cancreate'
            ? 'canCreate'
            : action == 'canupdate'
                ? 'canUpdate'
                : action == 'candelete'
                    ? 'canDelete'
                    : action;
        return body['data'][key] == true;
      }
      if (body is bool) return body;
      return null;
    } catch (e) {
      SGLog.error("PermissionRepository", "Error at _checkPermissionAction($action): $e");
      return null;
    }
  }
}
