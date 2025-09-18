import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/request/auth/auth_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class AuthRepository extends ApiBase {
  Future<Map<String, dynamic>> login(AuthRequest params) async {
    UserInfoDTO? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };

    try {
      final response = await post(
        EndPointAPI.LOGIN,
        queryParameters: {
          'tenDangNhap': params.tenDangNhap,
          'matKhau': params.matKhau,
        },
        options: Options(
          // Cho phép nhận response kể cả khi 400/500 thay vì ném exception
          validateStatus: (status) => true,
          receiveDataWhenStatusError: true,
        ),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        final data = response.data;
        if (data is Map<String, dynamic>) {
          result['message'] =
              (data['message'] ?? data['error'] ?? data['detail'] ?? '')
                  .toString();
        } else if (data is String) {
          try {
            final parsed = jsonDecode(data);
            if (parsed is Map<String, dynamic>) {
              result['message'] =
                  (parsed['message'] ??
                          parsed['error'] ??
                          parsed['detail'] ??
                          '')
                      .toString();
            } else {
              result['message'] = data;
            }
          } catch (_) {
            result['message'] = data;
          }
        }
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      final raw = response.data;
      final rawData = raw is Map<String, dynamic> ? raw['data'] : raw;
      final userMap =
          rawData is String
              ? (jsonDecode(rawData) as Map<String, dynamic>)
              : (rawData as Map<String, dynamic>);
      final user = UserInfoDTO.fromJson(userMap);
      AccountHelper.instance.setUserInfo(user);

      // Gọi các API phụ trợ
      await _loadUserDepartments(user.idCongTy);
      await _loadUserEmployee(user.idCongTy);
      await _loadChucVu(user.idCongTy);

      result['data'] = user;
      result['message'] = '';
    } catch (e) {
      if (e is DioException) {
        final resp = e.response;
        result['status_code'] = resp?.statusCode ?? Numeral.STATUS_CODE_DEFAULT;
        final data = resp?.data;
        if (data is Map<String, dynamic>) {
          final msg = data['message'] ?? data['error'] ?? data['detail'];
          if (msg != null) {
            result['message'] = msg.toString();
          }
        } else if (data is String) {
          try {
            final parsed = jsonDecode(data);
            if (parsed is Map<String, dynamic>) {
              final msg =
                  parsed['message'] ?? parsed['error'] ?? parsed['detail'];
              if (msg != null) {
                result['message'] = msg.toString();
              }
            } else {
              result['message'] = data;
            }
          } catch (_) {
            result['message'] = data;
          }
        }
        if ((result['message'] as String).isEmpty) {
          result['message'] = e.message ?? 'Đã xảy ra lỗi khi đăng nhập';
        }
      } else {
        result['message'] = 'Đã xảy ra lỗi khi đăng nhập';
      }
    }

    return result;
  }

  /// Load danh sách phòng ban của user và lưu vào AccountHelper
  Future<void> _loadUserDepartments(String idCongTy) async {
    try {
      final response = await get(
        EndPointAPI.PHONG_BAN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final List<dynamic> rawData = response.data;
        final List<PhongBan> departments =
            rawData
                .map((json) => PhongBan.fromJson(json as Map<String, dynamic>))
                .toList();
        AccountHelper.instance.setDepartment(departments);
      }
    } catch (e) {
      log('Error calling API PHONG_BAN: $e');
    }
  }

  /// Load thông tin nhân viên của user và lưu vào AccountHelper
  Future<void> _loadUserEmployee(String idCongTy) async {
    try {
      final response = await get(
        EndPointAPI.NHAN_VIEN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final rawNhanVien = response.data;

        // API trả về mảng JSON luôn
        final nhanVienList =
            (rawNhanVien as List<dynamic>)
                .map((e) => NhanVien.fromJson(e as Map<String, dynamic>))
                .toList();

        AccountHelper.instance.setNhanVien(nhanVienList);
      }
    } catch (e) {
      log('Error calling API NHAN_VIEN: $e');
    }
  }

  /// Load thông tin chức vụ của user và lưu vào AccountHelper
  Future<void> _loadChucVu(String idCongTy) async {
    try {
      final response = await get('${EndPointAPI.CHUC_VU}/congty/$idCongTy');
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final rawChucVu = response.data;
        // Lấy ra list trong field "data"
        final data = rawChucVu['data'] as List<dynamic>;
        final chucVuList =
            data
                .map((e) => ChucVu.fromJson(e as Map<String, dynamic>))
                .toList();

        AccountHelper.instance.setChucVu(chucVuList);
      }
    } catch (e) {
      log('Error calling API CHUC_VU: $e');
    }
  }

  Future<Map<String, dynamic>> createAccount(UserInfoDTO params) async {
    UserInfoDTO? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(EndPointAPI.ACCOUNT, data: params.toJson());

      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        if (response.data is Map<String, dynamic>) {
          result['message'] = (response.data['message'] ?? '').toString();
        }
        return result;
      }

      // Normalize to success for bloc check
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      final resp = response.data;
      if (resp is Map<String, dynamic>) {
        result['message'] = (resp['message'] ?? '').toString();
        // Prefer affectedRows if provided, fallback to data or 1
        if (resp.containsKey('affectedRows')) {
          result['data'] = resp['affectedRows'];
        } else if (resp.containsKey('data')) {
          result['data'] = resp['data'] ?? 1;
        } else {
          result['data'] = 1;
        }
      } else {
        result['data'] = resp ?? 1;
      }
      print('object result: ${result['data']}');
    } catch (e) {
      log("Error at createAccount - AuthRepository: $e");
    }

    return result;
  }

  Future<Response<UserInfoDTO>> updateUser(String id, UserInfoDTO user) async {
    try {
      final response = await put(
        EndPointAPI.ACCOUNT,
        queryParameters: {'id': id},
        data: user.toJson(),
      );
      final userUpdated = UserInfoDTO.fromJson(
        Map<String, dynamic>.from(response.data),
      );
      return Response<UserInfoDTO>(
        data: userUpdated,
        statusCode: response.statusCode,
        requestOptions: response.requestOptions,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<Response<void>> deleteUser(String id) async {
    try {
      final response = await delete('${EndPointAPI.ACCOUNT}/$id');
      // Don't try to parse response.data if it's empty
      return Response<void>(
        data: null,
        statusCode: response.statusCode,
        requestOptions: response.requestOptions,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getListUser() async {
    List<UserInfoDTO> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.ACCOUNT);
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Chuẩn hóa dữ liệu trả về sang danh sách UserInfoDTO
      final raw = response.data;
      dynamic normalized = raw;
      if (raw is Map && raw.containsKey('data')) {
        normalized = raw['data'];
      }
      final users = ResponseParser.parseToList<UserInfoDTO>(
        normalized,
        UserInfoDTO.fromJson,
      );
      result['data'] = users;
    } catch (e) {
      log("Error at getListUser - AuthRepository: $e");
    }
    return result;
  }

  Future<Map<String, dynamic>> getListNhanVien(String idCongTy) async {
    List<NhanVien> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.NHAN_VIEN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<NhanVien>(
        response.data,
        NhanVien.fromJson,
      );
    } catch (e) {
      log("Error at getListNhanVien - AuthRepository: $e");
    }
    return result;
  }
}
