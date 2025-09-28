import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';

import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class NhanVienProvider extends ApiBase {
  UserInfoDTO? userInfo = AccountHelper.instance.getUserInfo();
  Future<List<NhanVien>> fetchNhanViens() async {
    final response = await get(
      EndPointAPI.NHAN_VIEN,
      queryParameters: {'idcongty': userInfo?.idCongTy ?? 'ct001'},
    );
    if (response.statusCode == 200) {
      // Kiểm tra cấu trúc response và lấy data phù hợp
      final responseData = response.data;
      List<dynamic> data;

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        // Nếu response có cấu trúc {success: true, data: [...], ...}
        data = responseData['data'] ?? [];
      } else if (responseData is List) {
        // Nếu response trực tiếp là array
        data = responseData;
      } else {
        // Fallback
        data = [];
      }

      return data.map((item) => NhanVien.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load nhân viên');
    }
  }

  Future<List<ChucVu>> fetchChucVus() async {
    final response = await get(
      '${EndPointAPI.CHUC_VU}/congty/${userInfo?.idCongTy}',
    );
    if (response.statusCode == 200) {
      // Kiểm tra cấu trúc response và lấy data phù hợp
      final responseData = response.data;
      List<dynamic> data;

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        // Nếu response có cấu trúc {success: true, data: [...], ...}
        data = responseData['data'] ?? [];
      } else if (responseData is List) {
        // Nếu response trực tiếp là array
        data = responseData;
      } else {
        // Fallback
        data = [];
      }

      return data.map((item) => ChucVu.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chức vụ');
    }
  }

  Future<Map<String, dynamic>> addNhanVien(
    NhanVien nhanVien,
    dynamic avatarFile, {
    String? fileName,
  }) async {
    Map<String, dynamic> result = {
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    final response = await post(EndPointAPI.NHAN_VIEN, data: nhanVien.toJson());
    if (checkStatusCodeFailed(response.statusCode ?? 0)) {
      result['status_code'] = response.statusCode;
      result['message'] = response.data['message'];
      return result;
    }
    result['status_code'] = response.statusCode;
    result['data'] = response.data;
    return result;
  }

  Future<Map<String, dynamic>> updateNhanVien(NhanVien nhanVien) async {
    Map<String, dynamic> result = {
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    final response = await put(
      '${EndPointAPI.NHAN_VIEN}/${nhanVien.id}',
      data: nhanVien.toJson(),
    );
    
    if (checkStatusCodeFailed(response.statusCode ?? 0)) {
      result['status_code'] = response.statusCode;
      result['message'] = response.data['message'];
      return result;
    }
    result['status_code'] = response.statusCode;
    result['data'] = response.data;
    return result;
  }

  Future<Map<String, dynamic>> deleteNhanVien(String id) async {
    Map<String, dynamic> result = {
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    final response = await delete('${EndPointAPI.NHAN_VIEN}/$id');
    final body = response.data; // ở đây là Map luôn (nếu API trả về JSON)

    if (body['success'] == true) {
      result['status_code'] = response.statusCode;
      return result;
    } else {
      result['status_code'] = response.statusCode;
      result['message'] = body['message'] ?? "Failed to delete nhân viên";
    }
    return result;
  }

  void logFormData(FormData formData) {
    for (var field in formData.fields) {
      SGLog.info("NhanVienProvider", '${field.key}: ${field.value}');
    }

    for (var fileEntry in formData.files) {
      final file = fileEntry.value;
      SGLog.info(
        "NhanVienProvider",
        '${fileEntry.key}: ${file.filename} '
            '(${file.length} bytes, ${file.contentType})',
      );
    }
  }

  // Thêm: gọi API lấy Agreement UUID
  Future<Map<String, dynamic>> getAgreementUUID({
    required String idNhanVien,
    required String pin,
  }) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.NHAN_VIEN}/get-ky-so',
        queryParameters: {'idnhanvien': idNhanVien, 'pin': pin},
      );

      result['status_code'] =
          response.statusCode ?? Numeral.STATUS_CODE_DEFAULT;
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final resp = response.data;
        if (resp is Map<String, dynamic>) {
          // Nếu backend trả {'data': 'uuid'} hoặc {'agreementUuid': '...'}
          result['data'] =
              (resp['data'] ?? resp['agreementUuid'] ?? resp['uuid'] ?? '')
                  .toString();
          result['message'] = (resp['message'] ?? '').toString();
        } else {
          result['data'] = resp.toString();
        }
      } else {
        // Trả message nếu có
        if (response.data is Map<String, dynamic>) {
          result['message'] = (response.data['message'] ?? '').toString();
        }
      }
    } catch (e) {
      log("Error at getAgreementUUID - AuthRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> saveNhanVienBatch(
    List<NhanVien> nhanViens,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.NHAN_VIEN}/batch',
        data: jsonEncode(nhanViens),
      );

      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS ||
          response.statusCode == Numeral.STATUS_CODE_SUCCESS_CREATE) {
        result['status_code'] = response.statusCode;
        result['data'] = ResponseParser.parseToList<NhanVien>(
          response.data,
          NhanVien.fromJson,
        );
        return result;
      } else {
        result['status_code'] = response.statusCode;
        return result;
      }
    } catch (e) {
      SGLog.error("NhanVienProvider", "Error at saveNhanVienBatch: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteNhanVienBatch(List<String> data) async {
    Map<String, dynamic> result = {
      'data': '',
      'message': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.NHAN_VIEN}/batch',
        data: data,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data['message'];
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<NhanVien>(
        response.data,
        NhanVien.fromJson,
      );
    } catch (e) {
      SGLog.error("NhanVienProvider", "Error at deleteNhanVienBatch: $e");
    }

    return result;
  }
}
