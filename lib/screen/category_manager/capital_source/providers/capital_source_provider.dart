import 'dart:convert';
import 'dart:developer';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
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

  Future<Map<String, dynamic>> fetchProjects(String idCongTy) async {
    List<NguonKinhPhi> list = [];
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
      result['data'] = ResponseParser.parseToList<NguonKinhPhi>(
        response.data,
        NguonKinhPhi.fromJson,
      );
    } catch (e) {
      log("Error at addProject - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> addCapitalSource(
    NguonKinhPhi capitalSource,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.NGUON_KINH_PHI,
        data: capitalSource.toJson(),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;

      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['message'] = 'Thêm nguồn vốn thành công';
      } else {
        result['message'] =
            response.data['message'] ?? 'Thêm nguồn vốn thất bại';
      }
    } catch (e) {
      SGLog.error("CapitalSourceProvider", "Error at addCapitalSource: $e");
      result['message'] = 'Lỗi khi thêm nguồn vốn: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> updateCapitalSource(
    NguonKinhPhi capitalSource,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.NGUON_KINH_PHI}/${capitalSource.id}',
        data: capitalSource.toJson(),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;

      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['message'] = 'Cập nhật nguồn vốn thành công';
      } else {
        result['message'] =
            response.data['message'] ?? 'Cập nhật nguồn vốn thất bại';
      }
    } catch (e) {
      SGLog.error("CapitalSourceProvider", "Error at updateCapitalSource: $e");
      result['message'] = 'Lỗi khi cập nhật nguồn vốn: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteCapitalSource(
    String capitalSourceId,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.NGUON_KINH_PHI}/$capitalSourceId',
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;

      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['message'] = 'Xóa nguồn vốn thành công';
      } else {
        result['message'] =
            response.data['message'] ?? 'Xóa nguồn vốn thất bại';
      }
    } catch (e) {
      SGLog.error("CapitalSourceProvider", "Error at deleteCapitalSource: $e");
      result['message'] = 'Lỗi khi xóa nguồn vốn: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteCapitalSourceBatch(
    List<String> data,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      // Xóa từng item một vì API batch có thể không tồn tại
      int successCount = 0;
      int failCount = 0;
      List<String> errors = [];

      for (String id in data) {
        try {
          final response = await delete('${EndPointAPI.NGUON_KINH_PHI}/$id');
          if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
            successCount++;
          } else {
            failCount++;
            errors.add('ID $id: ${response.data['message'] ?? 'Lỗi không xác định'}');
          }
        } catch (e) {
          failCount++;
          errors.add('ID $id: $e');
        }
      }

      if (failCount == 0) {
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
        result['message'] = 'Xóa thành công $successCount nguồn vốn';
      } else if (successCount > 0) {
        result['status_code'] = 207; // Partial success
        result['message'] = 'Xóa thành công $successCount/$data.length nguồn vốn. Lỗi: ${errors.join(', ')}';
      } else {
        result['status_code'] = Numeral.STATUS_CODE_DEFAULT;
        result['message'] = 'Xóa thất bại tất cả nguồn vốn. Lỗi: ${errors.join(', ')}';
      }
    } catch (e) {
      log("Error at deleteCapitalSourceBatch - CapitalSourceProvider: $e");
      result['message'] = 'Lỗi khi xóa nguồn vốn: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> saveCapitalSourceBatch(
    List<NguonKinhPhi> capitalSources,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.NGUON_KINH_PHI}/batch',
        data: jsonEncode(capitalSources),
      );

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<NguonKinhPhi>(
        response.data,
        NguonKinhPhi.fromJson,
      );
    } catch (e) {
      log("Error at saveCapitalSourceBatch - CapitalSourceProvider: $e");
    }

    return result;
  }
}
