import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/model/asset_management_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class AssetManagementRepository extends ApiBase {
  Future<Map<String, dynamic>> getListAssetManagement(String idCongTy) async {
    List<AssetManagementDto> list = [];
    Map<String, dynamic> result = {'data': list, 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      // Check connect internet
      // if (!await checkInternet()) {
      //   log('Error: No network connection');
      //   return result;
      // }

      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);
      final response = await get(EndPointAPI.ASSET_MANAGEMENT, queryParameters: {'idcongty': idCongTy});
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetManagementDto>(response.data, AssetManagementDto.fromJson);
    } catch (e) {
      log("Error at getListAssetManagement - AssetManagementRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getAssetManagement(String id) async {
    AssetManagementDto? assetItem;
    Map<String, dynamic> result = {'data': assetItem, 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      final response = await get("${EndPointAPI.ASSET_MANAGEMENT}/$id");

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      if (response.data != null) {
        result['data'] = AssetManagementDto.fromJson(response.data);
      }
    } catch (e) {
      log("Error at getAssetManagement - AssetManagementRepository: $e");
    }

    return result;
  }
}
