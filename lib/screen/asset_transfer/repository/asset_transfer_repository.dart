import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class AssetTransferRepository extends ApiBase {
  // Path to the local JSON file for mock data
  static const String _mockDataAssetAllocationPath = 'lib/screen/asset_transfer/model/asset_allocation_data.json';
  static const String _mockDataAssetRecoveryPath = 'lib/screen/asset_transfer/model/asset_recovery_data.json';
  static const String _mockDataAssetMovementPath = 'lib/screen/asset_transfer/model/asset_movement_data.json';

  Future<Map<String, dynamic>> getListAssetTransfer(int typeAssetTransfer) async {
    List<AssetTransferDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    
    try {
      final jsonString = await _loadLocalJsonData(typeAssetTransfer);
      if (jsonString != null) {
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
        result['data'] = ResponseParser.parseToList<AssetTransferDto>(
          jsonString,
          AssetTransferDto.fromJson
        );
        return result;
      }


      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);
      final response = await get(EndPointAPI.ASSET_TRANSFER);
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }
      
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      
      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetTransferDto>(
        response.data, 
        AssetTransferDto.fromJson
      );
    } catch (e) {
      log("Error at getListAssetTransfer - AssetTransferRepository: $e");
    }
    
    return result;
  }
  
  /// Load data from local JSON file for development/testing purposes
  Future<String?> _loadLocalJsonData(int typeAssetTransfer) async {
    try {
      return await rootBundle.loadString(typeAssetTransfer == 1 ? _mockDataAssetAllocationPath : typeAssetTransfer == 2 ? _mockDataAssetRecoveryPath : _mockDataAssetMovementPath);
    } catch (e) {
      // Try to load from file system directly if rootBundle fails
      try {
        final file = await File(typeAssetTransfer == 1 ? _mockDataAssetAllocationPath : typeAssetTransfer == 2 ? _mockDataAssetRecoveryPath : _mockDataAssetMovementPath).readAsString();
        return file;
      } catch (e) {
        log('Failed to load mock data: $e');
        return null;
      }
    }
  }
}
