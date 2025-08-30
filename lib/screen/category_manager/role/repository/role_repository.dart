// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:async';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class RoleRepository extends ApiBase {
  // Path to the local JSON file for mock data
  // static const String _mockDataPath =
  //     'lib/screen/tools_and_supplies/model/tools_and_supplies_data.json';

  Future<Map<String, dynamic>> getListRole(String idCongTy) async {
    List<ChucVu> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get('${EndPointAPI.CHUC_VU}/congty/$idCongTy');
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      log('Raw response data: ${response.data}');
      
      // Lấy phần data từ response
      final List<dynamic> dataList = response.data['data'] ?? [];
      log('Data list from response: $dataList');
      
      // Parse từng item trong data list
      result['data'] = dataList.map((item) => ChucVu.fromJson(item)).toList();
      
      log('Parsed data: ${result['data']}');
      log('response.data: ${response.data}');
      log('response.dat result: ${result['data']}');
    } catch (e) {
      log("Error at getListRole - RoleRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createRole(ChucVu params) async {
    ChucVu? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final jsonData = params.toJson();
      log('createRole params.toJson(): $jsonData');
      final response = await post(EndPointAPI.CHUC_VU, data: jsonData);

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at createRole - RoleRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateRole(ChucVu params) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final jsonData = params.toJson();
      log('updateRole params.toJson(): $jsonData');
      final response = await put(
        '${EndPointAPI.CHUC_VU}/${params.id}',
        data: jsonData,
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at updateRole - RoleRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteRole(String id) async {
    Map<String, dynamic>? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await delete('${EndPointAPI.CHUC_VU}/$id');

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = response.data;
    } catch (e) {
      log("Error at deleteRole - RoleRepository: $e");
    }

    return result;
  }
}
