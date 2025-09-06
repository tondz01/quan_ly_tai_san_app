import 'dart:convert';
import 'dart:developer';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetManagementDetailRepository extends ApiBase {
  Future<Map<String, dynamic>> createAssetDetail(String params) async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    SGLog.debug("_saveItem 2", params);
    try {
      UserInfoDTO? userInfo = AccountHelper.instance.getUserInfo();
      List<DetailAssetDto> newRequestDetailAsset = DetailAssetDto.decode(
        params,
      );
      List<OwnershipUnitDetailDto> newRequestOwnershipUnit =
          newRequestDetailAsset
              .map(
                (e) => OwnershipUnitDetailDto(
                  id: '',
                  idCCDCVT: e.idTaiSan ?? '',
                  idTsCon: e.id ?? '',
                  idDonViSoHuu: newRequestDetailAsset.first.idDonVi ?? '',
                  soLuong: e.soLuong ?? 0,
                  thoiGianBanGiao: DateTime.now().toIso8601String(),
                  ngayTao: DateTime.now().toIso8601String(),
                  nguoiTao: userInfo?.tenDangNhap ?? '',
                ),
              )
              .toList();

      final response = await post(EndPointAPI.CHI_TIET_TAI_SAN, data: params);

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data?['message'] ?? 'Unknown error';
        return result;
      }

      final responseOwnershipUnit = await post(
        '${EndPointAPI.OWNERSHIP_UNIT_DETAIL}/batch',
        data: jsonEncode(newRequestOwnershipUnit),
      );

      if (checkStatusCodeFailed(responseOwnershipUnit.statusCode ?? 0)) {
        result['status_code'] = responseOwnershipUnit.statusCode;
        result['message'] = responseOwnershipUnit.data?['message'] ?? 'Unknown error';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      result['status_code'] = 500;
      result['message'] = e.toString();
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAssetDetail(String params) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(EndPointAPI.CHI_TIET_TAI_SAN, data: params);

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data?['message'] ?? 'Unknown error';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateToolsAndSupplies - ToolsAndSuppliesRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAssetDetail(String params) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(EndPointAPI.CHI_TIET_TAI_SAN, data: params);

      if (checkStatusCodeFailed(response.statusCode ?? 0)) {
        result['status_code'] = response.statusCode;
        result['message'] = response.data?['message'] ?? 'Unknown error';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      result['status_code'] = 500;
      result['message'] = e.toString();
    }

    return result;
  }
}
