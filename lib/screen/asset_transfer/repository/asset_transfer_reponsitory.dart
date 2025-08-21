import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/chi_tiet_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferRepository extends ApiBase {
  // Get danh sách tài sản
  Future<Map<String, dynamic>> getListDieuDongTaiSan(String idCongTy) async {
    List<DieuDongTaiSanDto> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.DIEU_DONG_TAI_SAN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<DieuDongTaiSanDto>(
        response.data,
        DieuDongTaiSanDto.fromJson,
      );
      log('response.data điều động: ${result['data']}');
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createAssetTransfer(
    LenhDieuDongRequest request,
    List<ChiTietDieuDongRequest> requestDetail,
  ) async {
    DieuDongTaiSanDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.DIEU_DONG_TAI_SAN,
        data: request.toJson(),
      );

      final int? status = response.statusCode;
      final bool isOk =
          status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
      if (!isOk) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        return result;
      }

      final dynamic respData = response.data;

      for (var detail in requestDetail) {
        final responseDetail = await post(
          EndPointAPI.CHI_TIET_DIEU_DONG_TAI_SAN,
          data: detail.toJson(),
        );
        final int? statusDetail = responseDetail.statusCode;
        final bool isOkDetail =
            statusDetail == Numeral.STATUS_CODE_SUCCESS ||
            statusDetail == Numeral.STATUS_CODE_SUCCESS_CREATE ||
            statusDetail == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
        if (!isOkDetail) {
          result['status_code'] = statusDetail ?? Numeral.STATUS_CODE_DEFAULT;
          return result;
        }
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      if (respData is Map<String, dynamic>) {
        result['data'] = DieuDongTaiSanDto.fromJson(respData);
      } else {
        result['data'] = DieuDongTaiSanDto();
      }
    } catch (e) {
      log("Error at createAsset - AssetManagementRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> uploadFile(String filePath) async {
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
        EndPointAPI.UPLOAD_FILE,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetTransferRepository",
        "Error at uploadFile - AssetTransferRepository: $e",
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> updateState(String idDieuDong) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        '${EndPointAPI.DIEU_DONG_TAI_SAN}/capnhattrangthai//$idDieuDong',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<DieuDongTaiSanDto>(
        response.data,
        DieuDongTaiSanDto.fromJson,
      );
      log('response.data điều động: ${result['data']}');
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> uploadFileBytes(
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
        EndPointAPI.UPLOAD_FILE,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      result['status_code'] = response.statusCode;
      result['data'] = response.data;
    } catch (e) {
      SGLog.error(
        "AssetTransferRepository",
        "Error at uploadFileBytes - AssetTransferRepository: $e",
      );
    }
    return result;
  }

  Future<Map<String, dynamic>> getDataDropdown(String idCongTy) async {
    List<PhongBan> listPb = [];
    List<NhanVien> listNv = [];
    Map<String, dynamic> result = {
      'data_pb': listPb,
      'data_nv': listNv,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final responsePBFuture = get(
        EndPointAPI.PHONG_BAN,
        queryParameters: {'idcongty': idCongTy},
      );
      final responseNVFuture = get(
        EndPointAPI.NHAN_VIEN,
        queryParameters: {'idcongty': idCongTy},
      );

      final responsePB = await responsePBFuture;
      final responseNV = await responseNVFuture;

      if (responsePB.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['data_pb'] = ResponseParser.parseToList<PhongBan>(
          responsePB.data,
          PhongBan.fromJson,
        );
      }
      if (responseNV.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['data_nv'] = ResponseParser.parseToList<NhanVien>(
          responseNV.data,
          NhanVien.fromJson,
        );
      }

      if (responsePB.statusCode == Numeral.STATUS_CODE_SUCCESS &&
          responseNV.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      } else {
        result['status_code'] =
            responsePB.statusCode == Numeral.STATUS_CODE_SUCCESS
                ? responseNV.statusCode
                : responsePB.statusCode;
      }
    } catch (e) {
      log("Error at getDataDropdown - DropdownItemReponsitory: $e");
    }

    return result;
  }
}
