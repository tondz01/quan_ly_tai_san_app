import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferRepository extends ApiBase {
  Future<Map<String, dynamic>> createAsset(LenhDieuDongRequest request) async {
    DieuDongTaiSanDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.ASSET_MANAGEMENT,
        data: request.toJson(),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      result['data'] = DieuDongTaiSanDto.fromJson(response.data);
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
