import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class NhanVienProvider extends ApiBase {
  Future<List<NhanVien>> fetchNhanViens() async {
    final response = await get(
      EndPointAPI.NHAN_VIEN,
      queryParameters: {'idcongty': "ct001"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((item) => NhanVien.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load nhân viên');
    }
  }

  Future<List<ChucVu>> fetchChucVus() async {
    final response = await get(
      EndPointAPI.CHUC_VU,
      queryParameters: {'idcongty': "ct001"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((item) => ChucVu.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chức vụ');
    }
  }

  Future<void> addNhanVien(
    NhanVien nhanVien,
    dynamic avatarFile, {
    String? fileName,
  }) async {
    try {
      // final formData = FormData();
      log('nhanVien: ${jsonEncode(nhanVien.toJson())}');
      // Trường data là JSON, set contentType application/json
      // formData.files.add(
      //   MapEntry(
      //     'data',
      //     MultipartFile.fromString(
      //       jsonEncode(nhanVien.toJson()),
      //       contentType: MediaType('application', 'json'),
      //     ),
      //   ),
      // );

      // if (avatarFile != null && avatarFile.isNotEmpty) {
      //   formData.files.add(
      //     MapEntry(
      //       'chuky',
      //       MultipartFile.fromBytes(
      //         avatarFile,
      //         filename: 'chuky.png',
      //         contentType: MediaType('image', 'png'),
      //       ),
      //     ),
      //   );
      // }
      // logFormData(formData);

      final response = await post(
        EndPointAPI.NHAN_VIEN,
        data: nhanVien.toJson(),
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        throw Exception('Lỗi server:  [200m${response.statusCode} [0m');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNhanVien(NhanVien nhanVien) async {
    try {
      // final formData = FormData();

      // Trường data là JSON, set contentType application/json
      // formData.files.add(
      //   MapEntry(
      //     'data',
      //     MultipartFile.fromString(
      //       jsonEncode(nhanVien.toJson()),
      //       contentType: MediaType('application', 'json'),
      //     ),
      //   ),
      // );
      // if (avatarFile != null && avatarFile.isNotEmpty) {
      //   formData.files.add(
      //     MapEntry(
      //       'chuky',
      //       MultipartFile.fromBytes(
      //         avatarFile,
      //         filename: 'chuky.png',
      //         contentType: MediaType('image', 'png'),
      //       ),
      //     ),
      //   );
      // }

      // logFormData(formData);

      final response = await put(
        '${EndPointAPI.NHAN_VIEN}/${nhanVien.id}',
        data: nhanVien.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        throw Exception('Lỗi server:  [200m${response.statusCode} [0m');
      }
    } catch (e) {
      rethrow;
    }
  }

  deleteNhanVien(String id) async {
    final response = await delete('${EndPointAPI.NHAN_VIEN}/$id');
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete nhân viên');
    }
  }

  void logFormData(FormData formData) {
    print('--- FormData fields ---');
    for (var field in formData.fields) {
      print('${field.key}: ${field.value}');
    }

    print('--- FormData files ---');
    for (var fileEntry in formData.files) {
      final file = fileEntry.value;
      print(
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

  // Trước khi gọi API
}
