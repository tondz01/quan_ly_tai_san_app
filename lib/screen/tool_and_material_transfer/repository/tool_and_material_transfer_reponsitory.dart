import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/signatory_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/detail_tool_and_material_transfer_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/request/tool_and_material_transfer_request.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolAndMaterialTransferRepository extends ApiBase {
  late final DetailToolAndMaterialTransferRepository _detailCcdcVt;
  late final SignatoryRepository _signatoryRepository;

  ToolAndMaterialTransferRepository() {
    _detailCcdcVt = DetailToolAndMaterialTransferRepository();
    _signatoryRepository = SignatoryRepository();
  }

  Future<Map<String, dynamic>> createToolAndMaterialTransfer(
    ToolAndMaterialTransferRequest request,
    List<DetailToolAndMaterialTransferDto> requestDetail,
    List<SignatoryDto> listSignatory,
  ) async {
    ToolAndMaterialTransferDto? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        EndPointAPI.TOOL_AND_MATERIAL_TRANSFER,
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
      log('message test1 requestDetail: ${jsonEncode(requestDetail)}');
      for (var detail in requestDetail) {
        final responseDetail = await post(
          EndPointAPI.DETAIL_TOOL_AND_MATERIAL_TRANSFER,
          data: detail.toJson(),
        );
        log('message test1 responseDetail: ${jsonEncode(responseDetail.data)}');
        final int? statusDetail = responseDetail.statusCode;
        final bool isOkDetail =
            statusDetail == Numeral.STATUS_CODE_SUCCESS ||
            statusDetail == Numeral.STATUS_CODE_SUCCESS_CREATE ||
            statusDetail == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
        if (!isOkDetail) {
          result['status_code'] = statusDetail ?? Numeral.STATUS_CODE_DEFAULT;
          log('❌ DETAIL REQUEST ${detail.toJson()} FAILED - Status: $statusDetail');
          log('Failed detail data: ${jsonEncode(detail.toJson())}');
          return result;
        }
        log('✅ DETAIL REQUEST ${detail.toJson()} SUCCESS');
      }

      for (var signatory in listSignatory) {
        final signatoryCopy = signatory.copyWith(
          idTaiLieu: request.id.toString(),
        );
        final responseSignatory = await post(
          EndPointAPI.SIGNATORY,
          data: signatoryCopy.toJson(),
        );
        final int? statusSignatory = responseSignatory.statusCode;
        final bool isOkSignatory =
            statusSignatory == Numeral.STATUS_CODE_SUCCESS ||
            statusSignatory == Numeral.STATUS_CODE_SUCCESS_CREATE ||
            statusSignatory == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
        if (!isOkSignatory) {
          result['status_code'] =
              statusSignatory ?? Numeral.STATUS_CODE_DEFAULT;
          return result;
        }
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      if (respData is Map<String, dynamic>) {
        result['data'] = ToolAndMaterialTransferDto.fromJson(respData);
      } else {
        result['data'] = ToolAndMaterialTransferDto();
      }
    } catch (e) {
      log("Error at createAsset - AssetManagementRepository: $e");
    }

    return result;
  }

  //Update trạng thái biên bản
  Future<Map<String, dynamic>> updateState(String id, String idNhanVien) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/capnhattrangthai?id=$id&userId=$idNhanVien',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<ToolAndMaterialTransferDto>(
        response.data,
        ToolAndMaterialTransferDto.fromJson,
      );
    } catch (e) {
      log("Error at updateState - ToolAndMaterialTransferRepository: $e");
    }

    return result;
  }

  //Hủy phiếu ký nội sinh
  Future<Map<String, dynamic>> cancelToolAndMaterialTransfer(String id) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/huy?id=$id',
      );
      unawaited(delete('/api/chuky/$id'));
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<ToolAndMaterialTransferDto>(
        response.data,
        ToolAndMaterialTransferDto.fromJson,
      );
      log('response.data điều động: ${result['data']}');
    } catch (e) {
      log(
        "Error at cancelToolAndMaterialTransfer - ToolAndMaterialTransferRepository: $e",
      );
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

  Future<List<ToolAndMaterialTransferDto>> getAllToolAndMeterialTransfer(
    int type,
  ) async {
    UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;

    final res = await get(
      '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/getbyuserid/${userInfo.tenDangNhap}',
    );
    List<ToolAndMaterialTransferDto> toolAndMaterialTransfers =
        (res.data as List)
            .map((e) => ToolAndMaterialTransferDto.fromJson(e))
            .where((e) => e.loai == type)
            .toList();

    await Future.wait(
      toolAndMaterialTransfers.map((toolAndMaterialTransfer) async {
        toolAndMaterialTransfer.detailToolAndMaterialTransfers =
            await _detailCcdcVt.getAll(toolAndMaterialTransfer.id.toString());
      }),
    );
    await Future.wait(
      toolAndMaterialTransfers.map((toolAndMaterialTransfer) async {
        try {
          final signatories = await _signatoryRepository.getAll(
            toolAndMaterialTransfer.id.toString(),
          );
          toolAndMaterialTransfer.listSignatory = signatories;
        } catch (e) {
          log(
            "Error loading signatories for ${toolAndMaterialTransfer.id}: $e",
          );
          toolAndMaterialTransfer.listSignatory = [];
        }
      }),
    );

    return toolAndMaterialTransfers;
  }

  Future<ToolAndMaterialTransferDto> getById(String id) async {
    String url = '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/$id';
    final res = await get(url);
    ToolAndMaterialTransferDto toolAndMaterialTransfer =
        ToolAndMaterialTransferDto.fromJson(res.data);
    List<DetailToolAndMaterialTransferDto> chiTietDieuDongTS =
        await _detailCcdcVt.getAll(toolAndMaterialTransfer.id.toString());
    toolAndMaterialTransfer.detailToolAndMaterialTransfers = chiTietDieuDongTS;
    return toolAndMaterialTransfer;
  }

  Future<int> create(ToolAndMaterialTransferDto obj) async {
    final res = await post(
      EndPointAPI.TOOL_AND_MATERIAL_TRANSFER,
      data: obj.toJson(),
    );
    return res.data;
  }

  Future<int> update(String id, ToolAndMaterialTransferRequest obj) async {
    String url = '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/$id';
    final res = await put(url, data: obj.toJson());
    final data = res.data;
    if (data is int) return data;
    if (data is Map<String, dynamic>) {
      final code = data['status_code'] ?? data['statusCode'] ?? data['code'];
      if (code is int) return code;
      if (code is String) return int.tryParse(code) ?? (res.statusCode ?? 0);
    }
    return res.statusCode ?? 0;
  }

  Future<int> deleteToolAndMaterialTransfer(String id) async {
    String url = '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/$id';
    final res = await delete(url);
    final data = res.data;
    if (data is int) return data;
    if (data is Map<String, dynamic>) {
      final code = data['status_code'] ?? data['statusCode'] ?? data['code'];
      if (code is int) return code;
      if (code is String) return int.tryParse(code) ?? (res.statusCode ?? 0);
    }
    return res.statusCode ?? 0;
  }

  Future<Map<String, dynamic>> sendToSigner(
    List<ToolAndMaterialTransferDto> items,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      for (var item in items) {
        ToolAndMaterialTransferDto toolAndMaterialTransfer =
            ToolAndMaterialTransferDto(
              soQuyetDinh: item.soQuyetDinh ?? '',
              tenPhieu: item.tenPhieu ?? '',
              idDonViGiao: item.idDonViGiao ?? '',
              idDonViNhan: item.idDonViNhan ?? '',
              idNguoiDeNghi: item.idNguoiDeNghi ?? '',
              nguoiLapPhieuKyNhay: item.nguoiLapPhieuKyNhay ?? false,
              quanTrongCanXacNhan: item.quanTrongCanXacNhan ?? false,
              phoPhongXacNhan: item.phoPhongXacNhan ?? false,
              idDonViDeNghi: item.idDonViDeNghi ?? '',
              tggnTuNgay: item.tggnTuNgay ?? '',
              tggnDenNgay: item.tggnDenNgay ?? '',
              idTruongPhongDonViGiao: item.idTruongPhongDonViGiao ?? '',
              truongPhongDonViGiaoXacNhan:
                  item.truongPhongDonViGiaoXacNhan ?? false,
              idPhoPhongDonViGiao: item.idPhoPhongDonViGiao ?? '',
              phoPhongDonViGiaoXacNhan: item.phoPhongDonViGiaoXacNhan ?? false,
              idTrinhDuyetCapPhong: item.idTrinhDuyetCapPhong ?? '',
              trinhDuyetCapPhongXacNhan:
                  item.trinhDuyetCapPhongXacNhan ?? false,
              idTrinhDuyetGiamDoc: item.idTrinhDuyetGiamDoc ?? '',
              trinhDuyetGiamDocXacNhan: item.trinhDuyetGiamDocXacNhan ?? false,
              diaDiemGiaoNhan: item.diaDiemGiaoNhan ?? '',
              idPhongBanXemPhieu: item.idPhongBanXemPhieu ?? '',
              idNhanSuXemPhieu: item.idNhanSuXemPhieu ?? '',
              noiNhan: item.noiNhan ?? '',
              trangThai: item.trangThai ?? 0,
              idCongTy: item.idCongTy ?? '',
              ngayTao: item.ngayTao ?? '',
              ngayCapNhat: item.ngayCapNhat ?? '',
              nguoiTao: item.nguoiTao ?? '',
              nguoiCapNhat: item.nguoiCapNhat ?? '',
              coHieuLuc: item.coHieuLuc ?? 1,
              loai: item.loai ?? 0,
              isActive: item.isActive ?? false,
              trichYeu: item.trichYeu ?? '',
              duongDanFile: item.duongDanFile ?? '',
              tenFile: item.tenFile ?? '',
              ngayKy: item.ngayKy ?? '',
              share: true,
              idNguoiKyNhay: item.idNguoiKyNhay ?? '',
              trangThaiKyNhay: item.trangThaiKyNhay ?? false,
            );
        final response = await put(
          '${EndPointAPI.TOOL_AND_MATERIAL_TRANSFER}/${item.id}',
          data: toolAndMaterialTransfer.toJson(),
        );
        if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
          result['data'] = response.data;
        } else {
          result['status_code'] = response.statusCode;
        }
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
    } catch (e) {
      log("Error at getDataDropdown - DropdownItemReponsitory: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getListOwnershipUnit() async {
    Map<String, dynamic> result = {
      'data': [],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      final res = await get(EndPointAPI.OWNERSHIP_UNIT_DETAIL);
      result['data'] = res.data['data'];
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
    } catch (e) {
      result['status_code'] = Numeral.STATUS_CODE_DEFAULT;
    }

    return result;
  }
}
