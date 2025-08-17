import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/nhan_vien.dart';
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
    };

    try {
      final response = await post(
        EndPointAPI.LOGIN,
        queryParameters: {
          'tenDangNhap': params.tenDangNhap,
          'matKhau': params.matKhau,
        },
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      // result['data'] = UserInfoDTO.fromJson(response.data);
      final resp = response.data;
      if (resp is Map<String, dynamic>) {
        result['data'] = UserInfoDTO.fromJson(resp);
      } else {
        // Backend có thể trả về chuỗi hoặc dạng khác -> chuyển thành String để hiển thị
        result['data'] = resp.toString();
      }
      AccountHelper.instance.setUserInfo(result['data']);
      log('result: ${result['data']}');
      print(
        'AccountHelper: ${jsonEncode(AccountHelper.instance.getUserInfo())}',
      );
    } catch (e) {
      log("Error at createAssetCategory - AssetCategoryRepository: $e");
    }

    return result;
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
      final response = await delete(
        '${EndPointAPI.ACCOUNT}/$id',
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

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<UserInfoDTO>(
        response.data,
        UserInfoDTO.fromJson,
      );
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

final fakeUserList = [
  {
    "id": 1,
    "username": "admin",
    "password": "hashed_password_1",
    "fullName": "Admin User",
    "dateOfBirth": "1985-01-01T00:00:00.000Z",
    "email": "admin@example.com",
    "createdAt": "2024-01-01T08:00:00.000Z",
    "updatedAt": "2024-01-10T10:00:00.000Z",
    "createdBy": "system",
    "updatedBy": "admin",
    "isActive": true,
    "role": "ADMIN",
  },
  {
    "id": 2,
    "username": "john_doe",
    "password": "hashed_password_2",
    "fullName": "John Doe",
    "dateOfBirth": "1990-05-15T00:00:00.000Z",
    "email": "john.doe@example.com",
    "createdAt": "2024-02-01T09:00:00.000Z",
    "updatedAt": "2024-02-15T11:00:00.000Z",
    "createdBy": "admin",
    "updatedBy": "john_doe",
    "isActive": true,
    "role": "USER",
  },
  {
    "id": 3,
    "username": "jane_smith",
    "password": "hashed_password_3",
    "fullName": "Jane Smith",
    "dateOfBirth": "1992-08-20T00:00:00.000Z",
    "email": "jane.smith@example.com",
    "createdAt": "2024-03-01T10:00:00.000Z",
    "updatedAt": null,
    "createdBy": "admin",
    "updatedBy": null,
    "isActive": false,
    "role": "USER",
  },
];
