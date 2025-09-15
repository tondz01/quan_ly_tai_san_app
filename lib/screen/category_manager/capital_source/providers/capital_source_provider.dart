import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CapitalSourceProvider extends ApiBase {
  Future<List<NguonKinhPhi>> fetchCapitalSources() async {
    try {
      final response = await get(
        EndPointAPI.NGUON_KINH_PHI,
        queryParameters: {'idcongty': "ct001"},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => NguonKinhPhi.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCapitalSource(NguonKinhPhi capitalSource) async {
    try {
      await post(EndPointAPI.NGUON_KINH_PHI, data: capitalSource.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCapitalSource(NguonKinhPhi capitalSource) async {
    try {
      await put(
        '${EndPointAPI.NGUON_KINH_PHI}/${capitalSource.id}',
        data: capitalSource.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCapitalSource(String capitalSourceId) async {
    try {
      await delete('${EndPointAPI.NGUON_KINH_PHI}/$capitalSourceId');
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
        '${EndPointAPI.NGUON_KINH_PHI}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "DepartmentsProvider",
        "Error at insertDataFile - CapitalSourceProvider: $e",
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
        '${EndPointAPI.NGUON_KINH_PHI}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "CapitalSourceProvider",
        "Error at insertDataFileBytes - CapitalSourceProvider: $e",
      );
    }
    return result;
  }
}
