import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/constants/project_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ProjectRepository extends ApiBase {
  Future<Map<String, dynamic>> fetchProjects(String idCongTy) async {
    List<DuAn> list = [];
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
      log("fetchProjects: statusCode=${response.statusCode}, data=${jsonEncode(response.data)}");
      result['data'] = ResponseParser.parseToList<DuAn>(
        response.data,
        DuAn.fromJson,
      );
    } catch (e) {
      SGLog.error("ProjectRepository", "Error at fetchProjects: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> addProject(DuAn project) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(EndPointAPI.DU_AN, data: project.toJson());

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<DuAn>(
        response.data,
        DuAn.fromJson,
      );
    } catch (e) {
      SGLog.error("ProjectRepository", "Error at addProject: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateProject(DuAn project) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.DU_AN}/${project.id}',
        data: project.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<DuAn>(
        response.data,
        DuAn.fromJson,
      );
    } catch (e) {
      SGLog.error("ProjectRepository", "Error at updateProject: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteProject(String projectId) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.DU_AN}/$projectId');

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("ProjectRepository", "Error at deleteProject: $e");
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
        "ProjectRepository",
        "Error at insertDataFile: $e",
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
        "ProjectRepository",
        "Error at insertDataFileBytes: $e",
      );
    }
    return result;
  }

  Future<Map<String, dynamic>> saveProjectBatch(List<DuAn> duAnList) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.DU_AN}/batch',
        data: jsonEncode(duAnList),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] =
            response.data['message'] ?? ProjectConstants.errorCreateProjectBatch;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<DuAn>(
        response.data,
        DuAn.fromJson,
      );
    } catch (e) {
      SGLog.error("ProjectRepository", "Error at saveProjectBatch: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteProjectBatch(List<String> data) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.DU_AN}/batch',
        data: jsonEncode(data),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<DuAn>(
        response.data,
        DuAn.fromJson,
      );
    } catch (e) {
      SGLog.error("ProjectRepository", "Error at deleteProjectBatch: $e");
    }

    return result;
  }
}
