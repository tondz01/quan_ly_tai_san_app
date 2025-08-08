import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/request/asset_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class AssetManagementRepository extends ApiBase {
  // Get danh sách tài sản
  Future<Map<String, dynamic>> getListAssetManagement(String idCongTy) async {
    List<AssetManagementDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.ASSET_MANAGEMENT,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetManagementDto>(
        response.data,
        AssetManagementDto.fromJson,
      );
    } catch (e) {
      log("Error at getListAssetManagement - AssetManagementRepository: $e");
    }

    return result;
  }

  // Get danh sách nhóm tài sản
  Future<Map<String, dynamic>> getListAssetGroup([String? idCongTy]) async {
    List<AssetGroupDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.ASSET_GROUP,
        queryParameters: {'idcongty': idCongTy ?? 'ct001'},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      log('message: ${response.data}');

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetGroupDto>(
        response.data,
        AssetGroupDto.fromJson,
      );
    } catch (e) {
      log("Error at getListAssetGroup - AssetManagementRepository: $e");
    }

    return result;
  }

  // Get danh sách dự án
  Future<Map<String, dynamic>> getListDuAn([String? idCongTy]) async {
    List<DuAn> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.DU_AN,
        queryParameters: {'idcongty': idCongTy ?? 'ct001'},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      result['data'] = ResponseParser.parseToList<DuAn>(
        response.data,
        DuAn.fromJson,
      );
    } catch (e) {
      log("Error at getListAssetGroup - AssetManagementRepository: $e");
    }
    return result;
  }

  // Get danh sách nguồn kinh phí
  Future<Map<String, dynamic>> getListCapitalSource([String? idCongTy]) async {
    List<NguonKinhPhi> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        EndPointAPI.NGUON_KINH_PHI,
        queryParameters: {'idcongty': idCongTy ?? 'ct001'},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<NguonKinhPhi>(
        response.data,
        NguonKinhPhi.fromJson,
      );
    } catch (e) {
      log("Error at getListCapitalSource - AssetManagementRepository: $e");
    }
    return result;
  }

  // Get danh sách phòng ban
  Future<Map<String, dynamic>> getListDepartment([String? idCongTy]) async {
    List<PhongBan> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final response = await get(
        EndPointAPI.PHONG_BAN,
        queryParameters: {'idcongty': idCongTy ?? 'ct001'},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = ResponseParser.parseToList<PhongBan>(
        response.data,
        PhongBan.fromJson,
      );
    } catch (e) {
      log("Error at getListDepartment - AssetManagementRepository: $e");
    }
    return result;
  }

  Future<Map<String, dynamic>> createAsset(AssetRequest request) async {
    AssetManagementDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.ASSET_MANAGEMENT,
        data: request.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = AssetManagementDto.fromJson(response.data);
    } catch (e) {
      log("Error at createAsset - AssetManagementRepository: $e");
    }

    return result;
  }
}
