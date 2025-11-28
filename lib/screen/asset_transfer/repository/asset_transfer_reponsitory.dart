import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/signatory_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/chi_tiet_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferRepository extends ApiBase {
  final SignatoryRepository _signatoryRepository = SignatoryRepository();
  // Get danh sách tài sản
  Future<Map<String, dynamic>> getListDieuDongTaiSan({int? type = -1}) async {
    final userInfo = AccountHelper.instance.getUserInfo();
    final idCongTy = userInfo?.idCongTy;
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

      List<DieuDongTaiSanDto> dieuDongTaiSans =
          ResponseParser.parseToList<DieuDongTaiSanDto>(
            response.data,
            DieuDongTaiSanDto.fromJson,
          );
      AccountHelper.instance.clearAssetTransfer();
      AccountHelper.instance.setAssetTransfer(dieuDongTaiSans);
      AccountHelper.refreshAllCounts();
      if (type != null && type != -1) {
        dieuDongTaiSans = dieuDongTaiSans.where((e) => e.loai == type).toList();
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      await Future.wait(
        dieuDongTaiSans.map((dieuDongTaiSan) async {
          Map<String, dynamic> result = await getChiTietDieuDongTaiSan(
            dieuDongTaiSan.id.toString(),
          );
          dieuDongTaiSan.chiTietDieuDongTaiSans = result['data'];
        }),
      );
      await Future.wait(
        dieuDongTaiSans.map((dieuDongTaiSan) async {
          try {
            final signatories = await _signatoryRepository.getAll(
              dieuDongTaiSan.id.toString(),
            );
            // Đảm bảo listSignatory được khởi tạo
            dieuDongTaiSan.listSignatory = signatories;
          } catch (e) {
            log("Error loading signatories for ${dieuDongTaiSan.id}: $e");
            dieuDongTaiSan.listSignatory = [];
          }
        }),
      );
      result['data'] = dieuDongTaiSans;
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> createAssetTransfer(
    LenhDieuDongRequest request,
    List<ChiTietDieuDongRequest> requestDetail,
    List<SignatoryDto> listSignatory,
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

  //Cập nhập trạng thái phiếu ký nội sinh
  Future<Map<String, dynamic>> updateState(String id, String idNhanVien) async {
    Map<String, dynamic> result = {
      'data': <DieuDongTaiSanDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.DIEU_DONG_TAI_SAN}/capnhattrangthai?id=$id&userId=$idNhanVien',
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
    } catch (e) {
      log("Error at getListDieuDongTaiSan - AssetTransferRepository: $e");
    }

    return result;
  }

  //Hủy phiếu ký nội sinh
  Future<Map<String, dynamic>> cancelDieuDongTaiSan(String id) async {
    Map<String, dynamic> result = {
      'data': <DieuDongTaiSanDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await post(
        '${EndPointAPI.DIEU_DONG_TAI_SAN}/huy?id=$id',
      );
      unawaited(delete('/api/chuky/$id'));

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        MessageServiceRealtime().pushJsonMessage(
          typeFunc: FunctionType.ALL_FUNCTION,
          typeAction: ActionType.DELETE,
          idNeedToDo: 'admin',
        );
      });
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
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType('application', 'pdf'),
        ),
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

  Future<Map<String, dynamic>> getChiTietDieuDongTaiSan(
    String idTaiLieu,
  ) async {
    List<ChiTietDieuDongTaiSan> data = [];
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.CHI_TIET_DIEU_DONG_TAI_SAN,
        queryParameters: {'iddieudongtaisan': idTaiLieu},
      );
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
        result['data'] = ResponseParser.parseToList<ChiTietDieuDongTaiSan>(
          response.data,
          ChiTietDieuDongTaiSan.fromJson,
        );
      }
    } catch (e) {
      log("Error at getDataDropdown - DropdownItemReponsitory: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> sendToSigner(
    List<DieuDongTaiSanDto> items,
  ) async {
    Map<String, dynamic> result = {
      'data': '',
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final allIds = <String>{};
      for (var item in items) {
        final id1 = item.idDonViGiao;
        final id2 = item.idDonViNhan;
        final id3 = item.idNguoiKyNhay;
        final id4 = item.idTrinhDuyetGiamDoc;

        if (id1 != null && id1.isNotEmpty) allIds.add(id1);
        if (id2 != null && id2.isNotEmpty) allIds.add(id2);
        if (id3 != null && id3.isNotEmpty) allIds.add(id3);
        if (id4 != null && id4.isNotEmpty) allIds.add(id4);
        final signatories = item.listSignatory;
        if (signatories != null) {
          for (var s in signatories) {
            final sigId = s.idNguoiKy;
            if (sigId != null && sigId.isNotEmpty) allIds.add(sigId);
          }
        }
        LenhDieuDongRequest lenhDieuDongRequest = LenhDieuDongRequest(
          soQuyetDinh: item.soQuyetDinh ?? '',
          tenPhieu: item.tenPhieu ?? '',
          idDonViGiao: item.idDonViGiao ?? '',
          idDonViNhan: item.idDonViNhan ?? '',
          idNguoiKyNhay: item.idNguoiKyNhay ?? '',
          trangThaiKyNhay: item.trangThaiKyNhay ?? false,
          nguoiLapPhieuKyNhay: item.nguoiLapPhieuKyNhay ?? false,
          idDonViDeNghi: item.idDonViDeNghi ?? '',
          tgGnTuNgay: item.tggnTuNgay ?? '',
          tgGnDenNgay: item.tggnDenNgay ?? '',
          idTrinhDuyetCapPhong: item.idTrinhDuyetCapPhong ?? '',
          trinhDuyetCapPhongXacNhan: item.trinhDuyetCapPhongXacNhan ?? false,
          idTrinhDuyetGiamDoc: item.idTrinhDuyetGiamDoc ?? '',
          trinhDuyetGiamDocXacNhan: item.trinhDuyetGiamDocXacNhan ?? false,
          diaDiemGiaoNhan: item.diaDiemGiaoNhan ?? '',
          idPhongBanXemPhieu: item.idPhongBanXemPhieu ?? '',
          noiNhan: item.noiNhan ?? '',
          trangThai: item.trangThai ?? 0,
          idCongTy: item.idCongTy ?? '',
          ngayTao: item.ngayTao ?? '',
          ngayCapNhat: item.ngayCapNhat ?? '',
          nguoiTao: item.nguoiTao ?? '',
          nguoiCapNhat: item.nguoiCapNhat ?? '',
          coHieuLuc: item.coHieuLuc ?? 1,
          loai: item.loai ?? 0,
          trichYeu: item.trichYeu ?? '',
          duongDanFile: item.duongDanFile ?? '',
          tenFile: item.tenFile ?? '',
          ngayKy: item.ngayKy ?? '',
          share: true,
          daBanGiao: item.daBanGiao ?? false,
          byStep: item.byStep ?? false,
        );
        final response = await put(
          '${EndPointAPI.DIEU_DONG_TAI_SAN}/${item.id}',
          data: lenhDieuDongRequest.toJson(),
        );
        if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
          result['data'] = response.data;
        } else {
          result['status_code'] = response.statusCode;
        }
      }
      if (allIds.isNotEmpty) {
        final recipients = {
          ...allIds.where((id) => id.trim().isNotEmpty),
          'admin',
        };
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          MessageServiceRealtime().pushJsonMessage(
            typeFunc: FunctionType.ASSET_TRANSFER,
            typeAction: ActionType.CREATE,
            idNeedToDo: recipients.join(','),
          );
        });
      }
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
    } catch (e) {
      log("Error at getDataDropdown - DropdownItemReponsitory: $e");
    }

    return result;
  }

  //get data with pagination
  Future<Map<String, dynamic>> getDataWithPagination(
    int page,
    int size,
    int type,
    String search,
    int trangThai,
  ) async {
    Map<String, dynamic> result = {
      'data': <DieuDongTaiSanDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'totalPages': 0,
      'currentPage': 0,
      'totalItems': 0,
      'totalAll': 0,
      'totalDraft': 0,
      'totalApprove': 0,
      'totalCancel': 0,
      'totalComplete': 0,
    };
    final userInfo = AccountHelper.instance.getUserInfo();

    try {
      String userid =
          userInfo?.tenDangNhap == 'admin' ? '' : userInfo?.tenDangNhap ?? '';
      final response = await get(
        // Đổi từ post thành get
        '${EndPointAPI.DIEU_DONG_TAI_SAN}/paged?idcongty=ct001&page=$page&size=$size&loai=$type&search=$search&userid=$userid&trangThai=${trangThai == -1 ? '' : trangThai}',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<DieuDongTaiSanDto>(
          itemsData,
          DieuDongTaiSanDto.fromJson,
        );
      } else {
        result['data'] = <DieuDongTaiSanDto>[];
      }
      result['totalPages'] = response.data['totalPages'] ?? 0;
      result['currentPage'] = response.data['currentPage'] ?? 0;
      result['totalItems'] = response.data['totalItems'] ?? 0;

      // Xử lý groupCounts với null-safety
      final groupCounts = response.data['groupCounts'];
      if (groupCounts is Map<String, dynamic>) {
        // Helper function để parse giá trị từ groupCounts
        int parseGroupCount(String key, [String? altKey]) {
          final value = groupCounts[key] ?? groupCounts[altKey];
          if (value is int) return value;
          if (value is num) return value.toInt();
          if (value == null) return 0;
          return int.tryParse(value.toString()) ?? 0;
        }

        result['totalAll'] = parseGroupCount('-1', 'all');
        result['totalDraft'] = parseGroupCount('0', 'draft');
        result['totalApprove'] = parseGroupCount('1', 'approve');
        result['totalCancel'] = parseGroupCount('2', 'cancel');
        result['totalComplete'] = parseGroupCount('3', 'complete');
      } else {
        // Nếu groupCounts không tồn tại hoặc không phải Map, set về 0
        result['totalAll'] = 0;
        result['totalDraft'] = 0;
        result['totalApprove'] = 0;
        result['totalCancel'] = 0;
        result['totalComplete'] = 0;
      }
    } catch (e) {
      log("Error at updateState - ToolAndMaterialTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getAssetByCurrentUnit(
    String idDonViHienthoi,
  ) async {
    Map<String, dynamic> result = {
      'data': [],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      if (idDonViHienthoi.isEmpty) {
        result['message'] = 'Thiếu id đơn vị hiện thời.';
        return result;
      }
      final userInfo = AccountHelper.instance.getUserInfo();
      final idCongTy = userInfo?.idCongTy;
      if (idCongTy == null || idCongTy.isEmpty) {
        result['message'] = 'Không tìm thấy thông tin công ty.';
        return result;
      }

      final response = await get(
        '${EndPointAPI.ASSET_MANAGEMENT}/by-donvi-hienthoi/paged',
        queryParameters: {
          'idcongty': idCongTy,
          'iddonvihienthoi': idDonViHienthoi,
          'page': 0,
          'size': 9999,
        },
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<AssetManagementDto>(
          itemsData,
          AssetManagementDto.fromJson,
        );
      } else {
        result['data'] = <AssetManagementDto>[];
      }
      log("message result: ${result['data']}");
    } catch (e) {
      log("Error at getAssetByCurrentUnit - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getAssetByUnit(String idDonViBandau) async {
    Map<String, dynamic> result = {
      'data': [],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };
    try {
      if (idDonViBandau.isEmpty) {
        result['message'] = 'Thiếu id đơn vị ban đầu.';
        return result;
      }
      final userInfo = AccountHelper.instance.getUserInfo();
      final idCongTy = userInfo?.idCongTy;
      if (idCongTy == null || idCongTy.isEmpty) {
        result['message'] = 'Không tìm thấy thông tin công ty.';
        return result;
      }

      final response = await get(
        '${EndPointAPI.ASSET_MANAGEMENT}/by-donvi-bandau/paged',
        queryParameters: {
          'idcongty': idCongTy,
          'iddonvibandau': idDonViBandau,
          'page': 0,
          'size': 9999,
        },
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<AssetManagementDto>(
          itemsData,
          AssetManagementDto.fromJson,
        );
      } else {
        result['data'] = <AssetManagementDto>[];
      }
      log("message result: ${result['data']}");
    } catch (e) {
      log("Error at getAssetByUnit - AssetTransferRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> updateSignatory(
    String idTaiLieu,
    List<SignatoryDto> listSignatory,
  ) async {
    Map<String, dynamic> result = {
      'data': <SignatoryDto>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await put(
        '${EndPointAPI.SIGNATORY}/update/$idTaiLieu',
        data: listSignatory,
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<SignatoryDto>(
        response.data,
        SignatoryDto.fromJson,
      );
    } catch (e) {
      log("Error at updateSignatory - AssetTransferRepository: $e");
    }

    return result;
  }
}
