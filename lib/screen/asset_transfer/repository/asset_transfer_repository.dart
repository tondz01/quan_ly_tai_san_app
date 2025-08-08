import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferRepository extends ApiBase {
  Future<Map<String, dynamic>> getListAssetTransfer(int typeAssetTransfer) async {
    List<AssetTransferDto> list = [];
    Map<String, dynamic> result = {'data': list, 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      // Request API (this part will run if loading local data fails)
      // final response = await get(EndPointAPI.TOOLS_AND_SUPPLIES);
      final response = await get(EndPointAPI.ASSET_TRANSFER, queryParameters: {'idcongty': 'ct001'});
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<AssetTransferDto>(response.data, AssetTransferDto.fromJson);
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at getListAssetTransfer - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> postFromAssetTransfer(AssetTransferDto item) async {
    Map<String, dynamic> result = {'data': '', 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      final Map<String, dynamic> payload = Map<String, dynamic>.from(item.toJson());

      String? normalizeDateToIsoT(String? ddmmyyyy) {
        if (ddmmyyyy == null || ddmmyyyy.isEmpty) return ddmmyyyy; // keep empty string if provided
        final parts = ddmmyyyy.split('/');
        if (parts.length == 3) {
          final d = parts[0].padLeft(2, '0');
          final m = parts[1].padLeft(2, '0');
          final y = parts[2];
          return '$y-$m-${d}T00:00:00';
        }
        return ddmmyyyy;
      }

      String toIsoNoMillis(DateTime dt) {
        final two = (int n) => n.toString().padLeft(2, '0');
        return '${dt.year}-${two(dt.month)}-${two(dt.day)}T${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
      }

      payload['tggnTuNgay'] = normalizeDateToIsoT(payload['tggnTuNgay']);
      payload['tggnDenNgay'] = normalizeDateToIsoT(payload['tggnDenNgay']);

      // Normalize ngayTao/ngayCapNhat
      final String? ngayTao = payload['ngayTao'];
      if (ngayTao == null || ngayTao.toString().isEmpty) {
        payload['ngayTao'] = toIsoNoMillis(DateTime.now());
      } else if (!ngayTao.toString().contains('T')) {
        // convert space format to ISO T
        final parsed = DateTime.tryParse(ngayTao.toString());
        payload['ngayTao'] = toIsoNoMillis(parsed ?? DateTime.now());
      }

      final String? ngayCapNhat = payload['ngayCapNhat'];
      if (ngayCapNhat == null || ngayCapNhat.toString().trim().isEmpty) {
        payload.remove('ngayCapNhat');
      } else if (!ngayCapNhat.toString().contains('T')) {
        final parsed = DateTime.tryParse(ngayCapNhat.toString());
        payload['ngayCapNhat'] = toIsoNoMillis(parsed ?? DateTime.now());
      }

      // Keep empty strings per backend example; only remove nulls
      payload.removeWhere((key, value) => value == null);

      final response = await post(
        EndPointAPI.ASSET_TRANSFER,
        data: payload,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
          contentType: 'application/json',
        ),
      );

      result['status_code'] = response.statusCode;
      result['data'] = response.data;

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        SGLog.error("AssetTransferRepository", "postFromAssetTransfer returned ${response.statusCode}: ${response.data}");
      }
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at getListAssetTransfer - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getListMovementDetail(String iddieudongtaisan) async {
    List<MovementDetailDto> list = [];
    Map<String, dynamic> result = {'data': list, 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      final response = await get(EndPointAPI.CHI_TIET_DIEU_DONG_TAI_SAN, queryParameters: {'iddieudongtaisan': iddieudongtaisan});
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<MovementDetailDto>(response.data, MovementDetailDto.fromJson);
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at getListMovementDetail - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<FormData> createFormDataWeb(Uint8List bytes, String filename) async {
    return FormData.fromMap({'file': MultipartFile.fromBytes(bytes, filename: filename)});
  }

  Future<Map<String, dynamic>> uploadFile(String filePath) async {
    Map<String, dynamic> result = {'data': '', 'status_code': Numeral.STATUS_CODE_DEFAULT};

    try {
      final fileName = filePath.split(RegExp(r'[\\/]+')).last;
      final formData = FormData.fromMap({'file': await MultipartFile.fromFile(filePath, filename: fileName)});

      final response = await post(EndPointAPI.UPLOAD_FILE, data: formData, options: Options(contentType: 'multipart/form-data'));
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at uploadFile - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> uploadFileBytes(String fileName, Uint8List fileBytes) async {
    Map<String, dynamic> result = {'data': '', 'status_code': Numeral.STATUS_CODE_DEFAULT};
    try {
      final formData = FormData.fromMap({'file': MultipartFile.fromBytes(fileBytes, filename: fileName)});
      final response = await post(EndPointAPI.UPLOAD_FILE, data: formData, options: Options(contentType: 'multipart/form-data'));
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error("AssetTransferRepository", "Error at uploadFileBytes - AssetTransferRepository: $e");
    }
    return result;
  }
}
