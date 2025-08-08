import 'dart:developer';
import 'dart:async'; // Add this import for unawaited

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/request/asset_group_request.dart';
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
      final response = await post(
        EndPointAPI.ASSET_GROUP,
        data: params.toJson(),
      );

      unawaited(
        post(
          EndPointAPI.ASSET_GROUP_V2,
          data: {
            'action': 'create_asset_group',
            'timestamp': DateTime.now().toIso8601String(),
            'params': params.toJson(),
          },
        ),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = AssetGroupDto.fromJson(response.data);
    } catch (e) {
      log("Error at createAssetGroup - AssetGroupRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAssetGroup(
    AssetGroupRequest params,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.ASSET_GROUP}/${params.id}',
        data: params.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateAssetGroup - AssetGroupRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAssetGroup(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.ASSET_GROUP}/$id');

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at deleteAssetGroup - AssetGroupRepository: $e");
    }

    return result;
  }
}
