import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
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

      // Lấy danh sách tài sản con cho từng tài sản
      List<AssetManagementDto> assets = result['data'];
      for (var i = 0; i < assets.length; i++) {
        if (assets[i].id != null) {
          final childAssetsResult = await getListChildAssets(assets[i].id!);
          if (childAssetsResult['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
            List<ChildAssetDto> childAssets = (childAssetsResult['data'] as List<dynamic>)
                .map((e) => ChildAssetDto.fromJson(e))
                .toList();
            assets[i] = assets[i].copyWith(childAssets: childAssets);
          }
        }
      }
      result['data'] = assets;
    } catch (e) {
      log("Error at getListAssetManagement - AssetManagementRepository: $e");
    }

    return result;
  }

  //get list child assets
  Future<Map<String, dynamic>> getListChildAssets(String idTaiSan) async {
    List<ChildAssetDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.CHILD_ASSETS,
        queryParameters: {'idTaiSan': idTaiSan},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<ChildAssetDto>(
        response.data,
        ChildAssetDto.fromJson,
      );
    } catch (e) {
      log("Error at getListChildAssets - AssetManagementRepository: $e");
    }

    return result;
  }

  //get list Khau Hao
  Future<Map<String, dynamic>> getListKhauHao(String idCongTy) async {
    List<AssetDepreciationDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      String url = '${EndPointAPI.ASSET_MANAGEMENT}/khauhaotaisan/$idCongTy';
      final response = await get(url);
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetDepreciationDto>(
        response.data,
        AssetDepreciationDto.fromJson,
      );
    } catch (e) {
      log("Error at getListKhauHao - AssetManagementRepository: $e");
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

  // Future<Map<String, dynamic>> createAsset(
  //   AssetRequest request,
  //   List<ChildAssetDto> childAssets,
  // ) async {
  //   AssetManagementDto? data;
  //   Map<String, dynamic> result = {
  //     'data': data,
  //     'status_code': Numeral.STATUS_CODE_DEFAULT,
  //   };

  //   try {
  //     final response = await post(
  //       EndPointAPI.ASSET_MANAGEMENT,
  //       data: request.toJson(),
  //     );

  //     if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
  //       result['status_code'] = response.statusCode;
  //       return result;
  //     }

  //     result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
  //     final resp = response.data;
  //     if (resp is Map<String, dynamic>) {
  //       result['message'] = (resp['message'] ?? '').toString();
  //       // Prefer affectedRows if provided, fallback to data or 1
  //       if (resp.containsKey('affectedRows')) {
  //         result['data'] = resp['affectedRows'];
  //       } else if (resp.containsKey('data')) {
  //         result['data'] = resp['data'] ?? 1;
  //       } else {
  //         result['data'] = 1;
  //       }
  //     } else {
  //       result['data'] = resp ?? 1;
  //     }
  //     // result['data'] = AssetManagementDto.fromJson(response.data);
  //   } catch (e) {
  //     log("Error at createAsset - AssetManagementRepository: $e");
  //   }

  //   return result;
  // }
  Future<int> create(ChildAssetDto obj) async {
    final res = await post(EndPointAPI.CHILD_ASSETS, data: obj.toJson());
    return res.data;
  }

  Future<Map<String, dynamic>> createAsset(
    AssetRequest request,
    List<ChildAssetDto> requestDetail,
  ) async {
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

      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      final dynamic respData = response.data;

      for (var detail in requestDetail) {
        final responseDetail = await post(
          EndPointAPI.CHILD_ASSETS,
          data: detail.toJson(),
        );
        final int? statusDetail = responseDetail.statusCode;
        final bool isOkDetail =
            statusDetail == Numeral.STATUS_CODE_SUCCESS ||
            statusDetail == Numeral.STATUS_CODE_SUCCESS_CREATE ||
            statusDetail == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
        if (!isOkDetail) {
          result['status_code'] = statusDetail ?? Numeral.STATUS_CODE_DEFAULT;
          return result;
        }
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      if (respData is Map<String, dynamic>) {
        result['data'] = AssetManagementDto.fromJson(respData);
      } else {
        result['data'] = AssetManagementDto();
      }
    } catch (e) {
      log("Error at createAsset - AssetManagementRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAsset(
    String id,
    AssetRequest params,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.ASSET_MANAGEMENT}/$id',
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateAsset - UdateAsset: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAsset(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.ASSET_MANAGEMENT}/$id');

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at deleteAsset - AssetManagementRepository: $e");
    }

    return result;
  }
}
