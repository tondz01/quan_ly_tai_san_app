import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class AssetHandoverRepository extends ApiBase {
  // Path to the local JSON file for mock data
  static const String _mockDataPath = 'lib/screen/asset_handover/model/asset_handover.json';

  Future<Map<String, dynamic>> getListAssetHandover() async {
    List<AssetHandoverDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    
    try {
      final jsonString = await _loadLocalJsonData();
      if (jsonString != null) {
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
        result['data'] = ResponseParser.parseToList<AssetHandoverDto>(
          jsonString,
          AssetHandoverDto.fromJson
        );
        return result;
      }

      // Check connect internet
      // if (!await checkInternet()) {
      //   log('Error: No network connection');
      //   return result;
      // }

      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);
      final response = await get(EndPointAPI.ASSET_TRANSFER);
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      
      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetHandoverDto>(
        response.data, 
        AssetHandoverDto.fromJson
      );
    } catch (e) {
      log("Error at getListAssetHandover - AssetHandoverRepository: $e");
    }
    
    return result;
  }
  
  /// Load data from local JSON file for development/testing purposes
 Future<String?> _loadLocalJsonData() async {
    try {
      return await rootBundle.loadString(_mockDataPath);
    } catch (e) {
      // Try to load from file system directly if rootBundle fails
      try {
        final file = await File(_mockDataPath).readAsString();
        return file;
      } catch (e) {
        log('Failed to load mock data: $e');
        return null;
      }
    }
  }
}
