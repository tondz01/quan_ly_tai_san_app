import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/common/model/permission_dto.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/permission_service.dart';
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
      log('logged - Raw login data: $rawData');
      final userMap =
          rawData is String
              ? (jsonDecode(rawData) as Map<String, dynamic>)
              : (rawData as Map<String, dynamic>);
      log('logged - Parsed user data: ${userMap['taiKhoan']}');
      final user = UserInfoDTO.fromJson(userMap['taiKhoan']);
      AccountHelper.instance.setUserInfo(user);
      log('User logged in: ${jsonEncode(user)}');
      // Gọi các API phụ trợ
      await _loadUserDepartments(user.idCongTy);
      await _loadUserEmployee(user.idCongTy);
      await _loadChucVu(user.idCongTy);
      List<String> roles = onGetPermission(user.tenDangNhap);
      PermissionService.instance.saveRoles(roles);

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
    Map<String, dynamic> result = {
      'data': null,
      'idUser': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    bool isSuccess(int? status) {
      return status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
    }

    dynamic extractResponseData(dynamic resp) {
      if (resp is Map<String, dynamic>) {
        if (resp.containsKey('affectedRows')) return resp['affectedRows'];
        if (resp.containsKey('data')) return resp['data'] ?? 1;
        return 1;
      }
      return resp ?? 1;
    }

    Future<void> tryLoginAndApplyPermissions() async {
      try {
        final responseLogin = await post(
          EndPointAPI.LOGIN,
          queryParameters: {
            'tenDangNhap': params.username,
            'matKhau': params.matKhau,
          },
          options: Options(
            validateStatus: (status) => true,
            receiveDataWhenStatusError: true,
          ),
        );
        if (responseLogin.statusCode == Numeral.STATUS_CODE_SUCCESS) {
          final raw = responseLogin.data;
          final rawData = raw is Map<String, dynamic> ? raw['data'] : raw;
          final Map<String, dynamic> userMap = rawData is String
              ? (jsonDecode(rawData) as Map<String, dynamic>)
              : (rawData as Map<String, dynamic>);
          final user = UserInfoDTO.fromJson(userMap['taiKhoan']);
          await AuthRepository().setPermissionsForNhanVien(user);
        }
      } catch (_) {}
    }

    try {
      final response = await post(EndPointAPI.ACCOUNT, data: params.toJson());
      final int? status = response.statusCode;

      if (!isSuccess(status)) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        if (response.data is Map<String, dynamic>) {
          result['message'] = (response.data['message'] ?? '').toString();
        }
        return result;
      }

      // Normalize to success for bloc check
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      await tryLoginAndApplyPermissions();
      result['data'] = extractResponseData(response.data);
    } catch (e) {
      log("Error at createAccount - AuthRepository: $e");
    }
    return result;
  }

  Future<Response<UserInfoDTO>> updateUser(String id, UserInfoDTO user) async {
    try {
      final response = await put(
        '${EndPointAPI.ACCOUNT}/$id',
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

  Future<Response<void>> deleteUserBatch(List<String> ids) async {
    try {
      final response = await delete(
        '${EndPointAPI.ACCOUNT}/batch',
        data: ids,
      );
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

  List<String> onGetPermission(String idUser) {
    List<String> roles = [];
    log('Getting permissions for user: $idUser');
    if (idUser.toLowerCase() == 'admin') {
      roles = [
        RoleCode.NHANVIEN,
        RoleCode.PHONGBAN,
        RoleCode.DUAN,
        RoleCode.NGUONVON,
        RoleCode.MOHINHTAISAN,
        RoleCode.NHOMTAISAN,
        RoleCode.TAISAN,
        RoleCode.CCDCVT,
        RoleCode.DIEUDONG_TAISAN,
        RoleCode.DIEUDONG_CCDC,
        RoleCode.BANGIAO_TAISAN,
        RoleCode.BANGIAO_CCDC,
        RoleCode.BAOCAO,
      ];
    } else {
      final nhanVien = AccountHelper.instance.getNhanVienById(idUser);
      if (nhanVien == null || nhanVien.chucVuId == null) return [];
      final chucVu = AccountHelper.instance.getChucVuById(nhanVien.chucVuId!);
      if (chucVu == null) return [];
      final List<MapEntry<bool, String>> permissionMap = [
        MapEntry(chucVu.quanLyNhanVien, RoleCode.NHANVIEN),
        MapEntry(chucVu.quanLyPhongBan, RoleCode.PHONGBAN),
        MapEntry(chucVu.quanLyDuAn, RoleCode.DUAN),
        MapEntry(chucVu.quanLyNguonVon, RoleCode.NGUONVON),
        MapEntry(chucVu.quanLyMoHinhTaiSan, RoleCode.MOHINHTAISAN),
        MapEntry(chucVu.quanLyNhomTaiSan, RoleCode.NHOMTAISAN),
        MapEntry(chucVu.quanLyTaiSan, RoleCode.TAISAN),
        MapEntry(chucVu.quanLyCCDCVatTu, RoleCode.CCDCVT),
        MapEntry(chucVu.dieuDongTaiSan, RoleCode.DIEUDONG_TAISAN),
        MapEntry(chucVu.dieuDongCCDCVatTu, RoleCode.DIEUDONG_CCDC),
        MapEntry(chucVu.banGiaoTaiSan, RoleCode.BANGIAO_TAISAN),
        MapEntry(chucVu.banGiaoCCDCVatTu, RoleCode.BANGIAO_CCDC),
        MapEntry(chucVu.baoCao, RoleCode.BAOCAO),
      ];
      roles = permissionMap.where((e) => e.key).map((e) => e.value).toList();
    }
    if (roles.isNotEmpty) {
      return roles;
    }
    return roles;
  }

  Future<void> setPermissionsForNhanVien(UserInfoDTO user) async {
    final List<String> permissionCodes = onGetPermission(user.tenDangNhap);
    final List<PermissionDto> userPermissions =
        permissionCodes
            .map(
              (code) => PermissionDto(
                userId: user.id,
                permissionCode: code,
                canCreate: true,
                canRead: true,
                canUpdate: true,
                canDelete: true,
              ),
            )
            .toList();
    await PermissionRepository().setPermissionBatch(userPermissions);
  }
}
