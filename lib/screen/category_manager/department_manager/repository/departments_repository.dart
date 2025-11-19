// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class DepartmentRepository extends ApiBase {
  // Path to the local JSON file for mock data
  // static const String _mockDataPath =
  //     'lib/screen/tools_and_supplies/model/tools_and_supplies_data.json';

  Future<Map<String, dynamic>> getListDepartment(String idCongTy) async {
    List<PhongBan> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get('${EndPointAPI.PHONG_BAN}/congty/$idCongTy');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Lấy phần data từ response
      final List<dynamic> dataList = response.data['data'] ?? [];

      // Parse từng item trong data list
      result['data'] = dataList.map((item) => PhongBan.fromJson(item)).toList();
    } catch (e) {
      SGLog.error("DepartmentRepository", "Error at getListDepartment: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createDepartment(PhongBan params) async {
    PhongBan? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final jsonData = params.toJson();
      log('createDepartment params.toJson(): $jsonData');
      final response = await post(EndPointAPI.PHONG_BAN, data: jsonData);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("DepartmentRepository", "Error at createDepartment: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateDepartment(PhongBan params) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final jsonData = params.toJson();
      log('updateDepartment params.toJson(): $jsonData');
      final response = await put(
        '${EndPointAPI.PHONG_BAN}/${params.id}',
        data: jsonData,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("DepartmentRepository", "Error at updateDepartment: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteDepartment(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.PHONG_BAN}/$id');

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("DepartmentRepository", "Error at deleteDepartment: $e");
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
        '${EndPointAPI.DU_AN}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetTransferRepository",
        "Error at insertDataFile - AssetTransferRepository: $e",
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
        '${EndPointAPI.DU_AN}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetTransferRepository",
        "Error at insertDataFileBytes - AssetTransferRepository: $e",
      );
    }
    return result;
  }

  Future<Map<String, dynamic>> saveDepartmentBatch(
    List<PhongBan> nhanViens,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.PHONG_BAN}/batch',
        data: jsonEncode(nhanViens),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] =
            response.data['message'] ?? 'Lưu danh sách chức vụ thất bại';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<PhongBan>(
        response.data,
        PhongBan.fromJson,
      );
    } catch (e) {
      SGLog.error("DepartmentRepository", "Error at saveDepartmentBatch: $e");
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
        data: jsonEncode(data),
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
      SGLog.error("DepartmentRepository", "Error at deleteDepartmentBatch: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getDataWithPagination(
    int page,
    int size,
    String search,
  ) async {
    Map<String, dynamic> result = {
      'data': <PhongBan>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'totalPages': 0,
      'currentPage': 0,
      'totalItems': 0,
    };

    try {
      final response = await get(
        // Đổi từ post thành get
        '${EndPointAPI.PHONG_BAN}/paged?idcongty=ct001&page=$page&size=$size&search=$search',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<PhongBan>(
          itemsData,
          PhongBan.fromJson,
        );
      }
      result['totalPages'] = response.data['totalPages'];
      result['currentPage'] = response.data['currentPage'];
      result['totalItems'] = response.data['totalItems'];
      result['totalPages'] = response.data['totalPages'];
    } catch (e) {
      log("Error at getDataWithPagination - DepartmentRepository: $e");
    }

    return result;
  }
}
