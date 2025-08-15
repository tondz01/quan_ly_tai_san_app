import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

import '../../../core/utils/response_parser.dart';

class AssetCategoryRepository extends ApiBase {
  Future<Map<String, dynamic>> getListAssetCategory(String idCongTy) async {
    List<AssetCategoryDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      log(
        'Calling API: ${EndPointAPI.ASSET_CATEGORY} with idCongTy: $idCongTy',
      );

      // Request API
      final response = await get(
        EndPointAPI.ASSET_CATEGORY,
        queryParameters: {'idcongty': idCongTy},
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Data: ${response.data}');

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['error_message'] = 'API trả về lỗi: ${response.statusCode}';
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetCategoryDto>(
        response.data,
        AssetCategoryDto.fromJson,
      );

      log('Parsed data count: ${result['data'].length}');
    } catch (e) {
      log("Error at getListAssetCategory - AssetCategoryRepository: $e");
      result['status_code'] = 0;
      result['error_message'] = 'Lỗi khi gọi API: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> createAssetCategory(
    AssetCategoryDto params,
  ) async {
    AssetCategoryDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.ASSET_CATEGORY,
        data: params.toJson(),
      );

      final int? status = response.statusCode;
      final bool isOk = status == Numeral.STATUS_CODE_SUCCESS ||
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
      log("Error at createAssetCategory - AssetCategoryRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAssetCategory(
    AssetCategoryDto params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.ASSET_CATEGORY}/$id',
        data: params.toJson(),
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateAssetCategory - AssetCategoryRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAssetCategory(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.ASSET_CATEGORY}/$id');

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at deleteAssetCategory - AssetCategoryRepository: $e");
    }

    return result;
  }
}
