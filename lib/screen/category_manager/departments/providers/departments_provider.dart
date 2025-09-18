import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/nhom_don_vi.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class DepartmentsProvider extends ApiBase {
  Future<List<PhongBan>> fetchDepartments() async {
    try {
      final response = await get(
        EndPointAPI.PHONG_BAN,
        queryParameters: {'idcongty': "ct001"},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => PhongBan.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchProjects(String idCongTy) async {
    List<PhongBan> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.DU_AN,
        queryParameters: {'idcongty': idCongTy},
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      log(
        "fetchProjects: statusCode=${response.statusCode}, data=${jsonEncode(response.data)}",
      );
      result['data'] = ResponseParser.parseToList<PhongBan>(
        response.data,
        PhongBan.fromJson,
      );
    } catch (e) {
      log("Error at addProject - AssetTransferRepository: $e");
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
        '${EndPointAPI.PHONG_BAN}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "DepartmentsProvider",
        "Error at insertDataFile - DepartmentsProvider: $e",
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
        '${EndPointAPI.PHONG_BAN}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "DepartmentsProvider",
        "Error at insertDataFileBytes - DepartmentsProvider: $e",
      );
    }
    return result;
  }

  Future<void> addDepartment(PhongBan department) async {
    try {
      await post(EndPointAPI.PHONG_BAN, data: department.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDepartment(PhongBan department) async {
    try {
      await put(
        '${EndPointAPI.PHONG_BAN}/${department.id}',
        data: department.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    try {
      await delete('${EndPointAPI.PHONG_BAN}/$departmentId');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<NhomDonVi>> fetchDepartmentGroups() async {
    try {
      final response = await get(
        EndPointAPI.NHOM_DON_VI,
        queryParameters: {'idcongty': "ct001"},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => NhomDonVi.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> saveDepartmentBatch(
    List<PhongBan> departments,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.PHONG_BAN}/batch',
        data: jsonEncode(departments),
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
      log("Error at saveDepartmentBatch - DepartmentsProvider: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteDepartmentBatch(List<String> data) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.PHONG_BAN}/batch',
        data: data,
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
      log("Error at deleteDepartmentBatch - DepartmentsProvider: $e");
    }

    return result;
  }
}
