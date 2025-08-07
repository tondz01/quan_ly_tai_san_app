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

      log('Calling API: ${EndPointAPI.ASSET_CATEGORY} with idCongTy: $idCongTy');
      
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
}
