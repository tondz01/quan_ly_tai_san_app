import 'dart:convert';
import 'dart:async'; // Add this import for unawaited
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/request/asset_group_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
      SGLog.error("AssetGroupRepository", "Error at getListAssetGroup: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi lấy danh sách nhóm tài sản: $e';
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

      log('createAssetGroup: ${params.toJson()}');

      unawaited(
        post(
          EndPointAPI.ASSET_GROUP_V2,
          data: params.toLoaiTaisanJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = AssetGroupDto.fromJson(response.data);
    } catch (e) {
      SGLog.error("AssetGroupRepository", "Error at createAssetGroup: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi tạo nhóm tài sản: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAssetGroup(
    AssetGroupRequest params,
    String id,
  ) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.ASSET_GROUP}/$id',
        data: params.toJson(),
      );
      unawaited(
        put(
          '${EndPointAPI.ASSET_GROUP_V2}/$id',
          data: {
            'action': 'update_asset_group',
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
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("AssetGroupRepository", "Error at updateAssetGroup: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi cập nhật nhóm tài sản: $e';
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
      unawaited(delete('${EndPointAPI.ASSET_GROUP_V2}/$id'));
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("AssetGroupRepository", "Error at deleteAssetGroup: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi xóa nhóm tài sản: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> insertDataFile(String filePath) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final fileName = filePath.split(RegExp(r'[\\/]+')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await post(
        '${EndPointAPI.ASSET_GROUP}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetGroupRepository",
        "Error at insertDataFile - AssetGroupRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> insertDataFileBytes(
    String fileName,
    Uint8List fileBytes,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });
      final response = await post(
        '${EndPointAPI.ASSET_GROUP}/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetGroupRepository",
        "Error at insertDataFileBytes - AssetGroupRepository: $e",
      );
    }
    return result;
  }

  Future<Map<String, dynamic>> saveAssetGroupBatch(
    List<AssetGroupDto> assetGroups,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.ASSET_GROUP}/batch',
        data: jsonEncode(assetGroups),
      );

      unawaited(
        post(
          '${EndPointAPI.ASSET_GROUP_V2}/batch',
          data: jsonEncode(assetGroups.map((e) => e.toLoaiTaisanJson()).toList()),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ),
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
      SGLog.error("AssetGroupRepository", "Error at saveAssetGroupBatch: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi import nhóm tài sản: $e';
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAssetGroupBatch(List<String> ids) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete(
        '${EndPointAPI.ASSET_GROUP}/batch',
        data: ids,
      );

      unawaited(delete('${EndPointAPI.ASSET_GROUP_V2}/batch', data: ids));

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
      SGLog.error("AssetGroupRepository", "Error at deleteAssetGroupBatch: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi khi xóa danh sách nhóm tài sản: $e';
    }

    return result;
  }
}
