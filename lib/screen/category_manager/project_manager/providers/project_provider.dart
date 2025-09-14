import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ProjectProvider extends ApiBase {
  Future<List<DuAn>> fetchProjects() async {
    try {
      final response = await get(
        EndPointAPI.DU_AN,
        queryParameters: {'idcongty': "ct001"},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => DuAn.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProject(DuAn project) async {
    try {
      await post(EndPointAPI.DU_AN, data: project.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProject(DuAn project) async {
    try {
      await put('${EndPointAPI.DU_AN}/${project.id}', data: project.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await delete('${EndPointAPI.DU_AN}/$projectId');
    } catch (e) {
      rethrow;
    }
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
}
