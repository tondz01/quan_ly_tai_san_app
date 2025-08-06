import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/network/check_internet.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/repository/request/asset_group_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

import '../../../core/utils/response_parser.dart';

class AssetGroupRepository extends ApiBase {
  Future<Map<String, dynamic>> getListAssetGroup() async {
    List<AssetGroupDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      // Check connect internet
      if (!await checkInternet()) {
        log('Error: No network connection');
        return result;
      }

      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);
      final response = await get(
        EndPointAPI.ASSET_GROUP,
        queryParameters: {'idcongty': 'ct001'},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetGroupDto>(
        response.data,
        AssetGroupDto.fromJson,
      );
    } catch (e) {
      log("Error at getListAssetTransfer - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createAssetGroup(
    AssetGroupRequest params,
  ) async {
    AssetGroupDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      // Check connect internet
      if (!await checkInternet()) {
        log('Error: No network connection');
        return result;
      }

      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);
      final response = await post(EndPointAPI.ASSET_CATEGORY, data: params.toJson());
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = AssetGroupDto.fromJson(response.data);
    } catch (e) {
      log("Error at getListAssetTransfer - AssetTransferRepository: $e");
    }

    return result;
  }
}
