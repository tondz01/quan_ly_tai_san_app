import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/common/model/permission_dto.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/core/utils/permission_service.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/repository/asset_category_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/repository/asset_group_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/request/auth/auth_request.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/repository/type_asset_repository.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/repository/type_ccdc_repository.dart';
import 'package:quan_ly_tai_san_app/screen/unit/repository/unit_repository.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AuthRepository extends ApiBase {
  Future<Map<String, dynamic>> login(AuthRequest params) async {
    UserInfoDTO? data;
    Map<String, dynamic> result = {
      'data': data,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };

    try {
      final response = await post(
        EndPointAPI.LOGIN,
        queryParameters: {
          'tenDangNhap': params.tenDangNhap,
          'matKhau': params.matKhau,
        },
        options: Options(
          // Cho phép nhận response kể cả khi 400/500 thay vì ném exception
          validateStatus: (status) => true,
          receiveDataWhenStatusError: true,
        ),
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        final data = response.data;
        if (data is Map<String, dynamic>) {
          result['message'] =
              (data['message'] ?? data['error'] ?? data['detail'] ?? '')
                  .toString();
        } else if (data is String) {
          try {
            final parsed = jsonDecode(data);
            if (parsed is Map<String, dynamic>) {
              result['message'] =
                  (parsed['message'] ??
                          parsed['error'] ??
                          parsed['detail'] ??
                          '')
                      .toString();
            } else {
              result['message'] = data;
            }
          } catch (_) {
            result['message'] = data;
          }
        }
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      final raw = response.data;
      final rawData = raw is Map<String, dynamic> ? raw['data'] : raw;
      final userMap =
          rawData is String
              ? (jsonDecode(rawData) as Map<String, dynamic>)
              : (rawData as Map<String, dynamic>);
      final user = UserInfoDTO.fromJson(userMap['taiKhoan']);
      AccountHelper.instance.setUserInfo(user);

      // Gọi các API phụ trợ

      List<String> roles = onGetPermission(user.tenDangNhap);
      PermissionService.instance.saveRoles(roles);

      result['data'] = user;
      result['message'] = '';
    } catch (e) {
      if (e is DioException) {
        final resp = e.response;
        result['status_code'] = resp?.statusCode ?? Numeral.STATUS_CODE_DEFAULT;
        final data = resp?.data;
        if (data is Map<String, dynamic>) {
          final msg = data['message'] ?? data['error'] ?? data['detail'];
          if (msg != null) {
            result['message'] = msg.toString();
          }
        } else if (data is String) {
          try {
            final parsed = jsonDecode(data);
            if (parsed is Map<String, dynamic>) {
              final msg =
                  parsed['message'] ?? parsed['error'] ?? parsed['detail'];
              if (msg != null) {
                result['message'] = msg.toString();
              }
            } else {
              result['message'] = data;
            }
          } catch (_) {
            result['message'] = data;
          }
        }
        if ((result['message'] as String).isEmpty) {
          result['message'] = e.message ?? 'Đã xảy ra lỗi khi đăng nhập';
        }
      } else {
        result['message'] = 'Đã xảy ra lỗi khi đăng nhập';
      }
    }

    return result;
  }

  //------LOAD DATA------------------------------------------------------------------------------------///
  Future<void> loadData(String idCongTy) async {
    await Future.wait([
      loadUserDepartments(idCongTy),
      loadUserEmployee(idCongTy),
      loadAssetGroup(idCongTy),
      loadCCDCGroup(idCongTy),
      loadReasonIncrease(),
      _loadChucVu(idCongTy),
      _loadTypeAsset(idCongTy),
      _loadTypeCcdc(idCongTy),
      _loadAssetCategory(idCongTy),
      loadUnit(idCongTy),
    ]);
  }

  /// Load danh sách phòng ban của user và lưu vào AccountHelper
  Future<void> loadUserDepartments(String idCongTy) async {
    try {
      final response = await get(
        EndPointAPI.PHONG_BAN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final List<dynamic> rawData = response.data;
        final List<PhongBan> departments =
            rawData
                .map((json) => PhongBan.fromJson(json as Map<String, dynamic>))
                .toList();
        AccountHelper.instance.setDepartment(departments);
      }
    } catch (e) {
      log('Error calling API PHONG_BAN: $e');
    }
  }

  /// Load thông tin nhân viên của user và lưu vào AccountHelper
  Future<void> loadUserEmployee(String idCongTy) async {
    try {
      final response = await get(
        EndPointAPI.NHAN_VIEN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final rawNhanVien = response.data;

        // API trả về mảng JSON luôn
        final nhanVienList =
            (rawNhanVien as List<dynamic>)
                .map((e) => NhanVien.fromJson(e as Map<String, dynamic>))
                .toList();

        AccountHelper.instance.setNhanVien(nhanVienList);
        SGLog.info('_loadData', 'loadUserEmployee');
      }
    } catch (e) {
      log('Error calling API NHAN_VIEN: $e');
    }
  }

  /// Load thông tin nhóm tài sản của user và lưu vào AccountHelper
  Future<void> loadAssetGroup(String idCongTy) async {
    try {
      await AssetGroupRepository().getListAssetGroup();
      SGLog.info('_loadData', 'loadAssetGroup');
    } catch (e) {
      log('Error calling API ASSET_GROUP: $e');
    }
  }

  /// Load thông tin nhóm CCDC của user và lưu vào AccountHelper
  Future<void> loadCCDCGroup(String idCongTy) async {
    try {
      final response = await get(
        EndPointAPI.CCDC_GROUP,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final rawCCDCGroup = response.data;

        // API trả về mảng JSON luôn
        final ccdcGroupList =
            (rawCCDCGroup as List<dynamic>)
                .map((e) => CcdcGroup.fromJson(e as Map<String, dynamic>))
                .toList();

        AccountHelper.instance.setCcdcGroup(ccdcGroupList);
        SGLog.info('_loadData', 'loadCCDCGroup');
      }
    } catch (e) {
      log('Error calling API CCDC_GROUP: $e');
    }
  }

  Future<void> loadReasonIncrease() async {
    try {
      final response = await get(EndPointAPI.REASON_INCREASE);
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final rawReasonIncrease = response.data;

        // Handle both direct array and object with data field
        List<dynamic> reasonIncreaseList;
        if (rawReasonIncrease is List) {
          // Direct array response
          reasonIncreaseList = rawReasonIncrease;
        } else if (rawReasonIncrease is Map<String, dynamic>) {
          // Object response - try to get data field
          if (rawReasonIncrease.containsKey('data') &&
              rawReasonIncrease['data'] is List) {
            reasonIncreaseList = rawReasonIncrease['data'] as List<dynamic>;
          } else {
            SGLog.info(
              '_loadData',
              'Error: API response format not recognized for REASON_INCREASE',
            );
            return;
          }
        } else {
          SGLog.info(
            '_loadData',
            'Error: Unexpected response type for REASON_INCREASE: ${rawReasonIncrease.runtimeType}',
          );
          return;
        }

        final parsedReasonIncrease =
            reasonIncreaseList
                .map((e) => ReasonIncrease.fromJson(e as Map<String, dynamic>))
                .toList();
        AccountHelper.instance.setReasonIncrease(parsedReasonIncrease);
        SGLog.info('_loadData', 'loadReasonIncrease');
      }
    } catch (e) {
      log('Error calling API REASON_INCREASE: $e');
    }
  }

  /// Load thông tin chức vụ của user và lưu vào AccountHelper
  Future<void> _loadChucVu(String idCongTy) async {
    try {
      final response = await get('${EndPointAPI.CHUC_VU}/congty/$idCongTy');
      if (response.statusCode == Numeral.STATUS_CODE_SUCCESS) {
        final rawChucVu = response.data;
        // Lấy ra list trong field "data"
        final data = rawChucVu['data'] as List<dynamic>;
        final chucVuList =
            data
                .map((e) => ChucVu.fromJson(e as Map<String, dynamic>))
                .toList();

        AccountHelper.instance.setChucVu(chucVuList);
        SGLog.info('_loadData', 'loadChucVu');
      }
    } catch (e) {
      log('Error calling API CHUC_VU: $e');
    }
  }

  Future<void> _loadTypeAsset(String idCongTy) async {
    try {
      final response = await TypeAssetRepository().getListTypeAssetRepository(
        idCongTy,
      );
      if (response['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        final typeAssetList = response['data'] as List<TypeAsset>;
        AccountHelper.instance.setTypeAsset(typeAssetList);
        SGLog.info('_loadData', 'loadTypeAsset');
      }
    } catch (e) {
      log('Error calling API TYPE_ASSET: $e');
    }
  }

  Future<void> _loadTypeCcdc(String idCongTy) async {
    try {
      final response = await TypeCcdcRepository().getListTypeCcdcRepository(
        idCongTy,
      );
      if (response['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        final typeCcdcList = response['data'] as List<TypeCcdc>;
        AccountHelper.instance.setTypeCcdc(typeCcdcList);
        SGLog.info('_loadData', 'loadTypeCcdc');
      }
    } catch (e) {
      log('Error calling API TYPE_CCDC: $e');
    }
  }

  Future<void> _loadAssetCategory(String idCongTy) async {
    try {
      final response = await AssetCategoryRepository().getListAssetCategory(
        idCongTy,
      );
      if (response['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        final assetCategoryList = response['data'] as List<AssetCategoryDto>;
        AccountHelper.instance.setAssetCategory(assetCategoryList);
        SGLog.info('_loadData', 'loadAssetCategory');
      }
    } catch (e) {
      log('Error calling API ASSET_CATEGORY: $e');
    }
  }

  Future<void> loadUnit(String idCongTy) async {
    try {
      final response = await UnitRepository().getListUnit();
      if (response['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        AccountHelper.instance.setUnit(response['data']);
        log('message test: loadUnit: ${response['data'].length}');
        SGLog.info('_loadData', 'loadUnit');
      }
    } catch (e) {
      log('Error calling API ASSET_CATEGORY: $e');
    }
  }

  //------------------------------------------------------------------------------------------///
  Future<Map<String, dynamic>> createAccount(UserInfoDTO params) async {
    Map<String, dynamic> result = {
      'data': null,
      'idUser': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    bool isSuccess(int? status) {
      return status == Numeral.STATUS_CODE_SUCCESS ||
          status == Numeral.STATUS_CODE_SUCCESS_CREATE ||
          status == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT;
    }

    dynamic extractResponseData(dynamic resp) {
      if (resp is Map<String, dynamic>) {
        if (resp.containsKey('affectedRows')) return resp['affectedRows'];
        if (resp.containsKey('data')) return resp['data'] ?? 1;
        return 1;
      }
      return resp ?? 1;
    }

    Future<void> tryLoginAndApplyPermissions() async {
      try {
        final responseLogin = await post(
          EndPointAPI.LOGIN,
          queryParameters: {
            'tenDangNhap': params.username,
            'matKhau': params.matKhau,
          },
          options: Options(
            validateStatus: (status) => true,
            receiveDataWhenStatusError: true,
          ),
        );
        if (responseLogin.statusCode == Numeral.STATUS_CODE_SUCCESS) {
          final raw = responseLogin.data;
          final rawData = raw is Map<String, dynamic> ? raw['data'] : raw;
          final Map<String, dynamic> userMap =
              rawData is String
                  ? (jsonDecode(rawData) as Map<String, dynamic>)
                  : (rawData as Map<String, dynamic>);
          final user = UserInfoDTO.fromJson(userMap['taiKhoan']);
          await AuthRepository().setPermissionsForNhanVien(user);
        }
      } catch (_) {}
    }

    try {
      final response = await post(EndPointAPI.ACCOUNT, data: params.toJson());
      final int? status = response.statusCode;

      if (!isSuccess(status)) {
        result['status_code'] = status ?? Numeral.STATUS_CODE_DEFAULT;
        if (response.data is Map<String, dynamic>) {
          result['message'] = (response.data['message'] ?? '').toString();
        }
        return result;
      }

      // Normalize to success for bloc check
      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
      await tryLoginAndApplyPermissions();
      result['data'] = extractResponseData(response.data);
    } catch (e) {
      log("Error at createAccount - AuthRepository: $e");
    }
    return result;
  }

  Future<Response<UserInfoDTO>> updateUser(String id, UserInfoDTO user) async {
    try {
      final response = await put(
        '${EndPointAPI.ACCOUNT}/$id',
        data: user.toJson(),
      );
      final userUpdated = UserInfoDTO.fromJson(
        Map<String, dynamic>.from(response.data),
      );
      return Response<UserInfoDTO>(
        data: userUpdated,
        statusCode: response.statusCode,
        requestOptions: response.requestOptions,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<Response<void>> deleteUser(String id) async {
    try {
      final response = await delete('${EndPointAPI.ACCOUNT}/$id');
      // Don't try to parse response.data if it's empty
      return Response<void>(
        data: null,
        statusCode: response.statusCode,
        requestOptions: response.requestOptions,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<Response<void>> deleteUserBatch(List<String> ids) async {
    try {
      final response = await delete('${EndPointAPI.ACCOUNT}/batch', data: ids);
      // Don't try to parse response.data if it's empty
      return Response<void>(
        data: null,
        statusCode: response.statusCode,
        requestOptions: response.requestOptions,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getListUser() async {
    List<UserInfoDTO> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(EndPointAPI.ACCOUNT);
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Chuẩn hóa dữ liệu trả về sang danh sách UserInfoDTO
      final raw = response.data;
      dynamic normalized = raw;
      if (raw is Map && raw.containsKey('data')) {
        normalized = raw['data'];
      }
      final users = ResponseParser.parseToList<UserInfoDTO>(
        normalized,
        UserInfoDTO.fromJson,
      );
      result['data'] = users;
    } catch (e) {
      log("Error at getListUser - AuthRepository: $e");
    }
    return result;
  }

  Future<Map<String, dynamic>> getListNhanVien(String idCongTy) async {
    List<NhanVien> list = [];
    Map<String, dynamic> result = {
      'data': list,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
    };

    try {
      final response = await get(
        EndPointAPI.NHAN_VIEN,
        queryParameters: {'idcongty': idCongTy},
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the common ResponseParser utility
      result['data'] = ResponseParser.parseToList<NhanVien>(
        response.data,
        NhanVien.fromJson,
      );
    } catch (e) {
      log("Error at getListNhanVien - AuthRepository: $e");
    }
    return result;
  }

  List<String> onGetPermission(String idUser) {
    List<String> roles = [];
    if (idUser.toLowerCase() == 'admin') {
      roles = [
        RoleCode.NHANVIEN,
        RoleCode.PHONGBAN,
        RoleCode.DUAN,
        RoleCode.NGUONVON,
        RoleCode.MOHINHTAISAN,
        RoleCode.NHOMTAISAN,
        RoleCode.TAISAN,
        RoleCode.CCDCVT,
        RoleCode.DIEUDONG_TAISAN,
        RoleCode.DIEUDONG_CCDC,
        RoleCode.BANGIAO_TAISAN,
        RoleCode.BANGIAO_CCDC,
        RoleCode.BAOCAO,
      ];
    } else {
      final nhanVien = AccountHelper.instance.getNhanVienById(idUser);
      log(
        "[check onGetPermission] 1 - check nhanVien: ${jsonEncode(nhanVien)}",
      );
      if (nhanVien == null || nhanVien.chucVuId == null) return [];
      log(
        "[check onGetPermission] 2 - check nhanVien: ${jsonEncode(nhanVien)}",
      );
      final chucVu = AccountHelper.instance.getChucVuById(nhanVien.chucVuId!);
      log('[check onGetPermission] 3 - chucVu: ${jsonEncode(chucVu)}');
      log("[check onGetPermission] 4 - check chucVu: ${jsonEncode(chucVu)}");
      if (chucVu == null) return [];
      log("[check onGetPermission] 5 - check chucVu2: ${jsonEncode(chucVu)}");
      final List<MapEntry<bool, String>> permissionMap = [
        MapEntry(chucVu.quanLyNhanVien, RoleCode.NHANVIEN),
        MapEntry(chucVu.quanLyPhongBan, RoleCode.PHONGBAN),
        MapEntry(chucVu.quanLyDuAn, RoleCode.DUAN),
        MapEntry(chucVu.quanLyNguonVon, RoleCode.NGUONVON),
        MapEntry(chucVu.quanLyMoHinhTaiSan, RoleCode.MOHINHTAISAN),
        MapEntry(chucVu.quanLyNhomTaiSan, RoleCode.NHOMTAISAN),
        MapEntry(chucVu.quanLyTaiSan, RoleCode.TAISAN),
        MapEntry(chucVu.quanLyCCDCVatTu, RoleCode.CCDCVT),
        MapEntry(chucVu.dieuDongTaiSan, RoleCode.DIEUDONG_TAISAN),
        MapEntry(chucVu.dieuDongCCDCVatTu, RoleCode.DIEUDONG_CCDC),
        MapEntry(chucVu.banGiaoTaiSan, RoleCode.BANGIAO_TAISAN),
        MapEntry(chucVu.banGiaoCCDCVatTu, RoleCode.BANGIAO_CCDC),
        MapEntry(chucVu.baoCao, RoleCode.BAOCAO),
      ];
      roles = permissionMap.where((e) => e.key).map((e) => e.value).toList();
    }
    log("check roles11: ${jsonEncode(roles)}");
    if (roles.isNotEmpty) {
      return roles;
    }
    log("check roles: ${jsonEncode(roles)}");
    return roles;
  }

  Future<void> setPermissionsForNhanVien(UserInfoDTO user) async {
    final List<String> permissionCodes = onGetPermission(user.tenDangNhap);
    final List<PermissionDto> userPermissions =
        permissionCodes
            .map(
              (code) => PermissionDto(
                userId: user.id,
                permissionCode: code,
                canCreate: true,
                canRead: true,
                canUpdate: true,
                canDelete: true,
              ),
            )
            .toList();
    await PermissionRepository().setPermissionBatch(userPermissions);
  }

  Future<Map<String, dynamic>> getDataWithPagination(
    int page,
    int size,
    String search,
  ) async {
    Map<String, dynamic> result = {
      'data': <UserInfoDTO>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'totalPages': 0,
      'currentPage': 0,
      'totalItems': 0,
    };
    try {
      final response = await get(
        // Đổi từ post thành get
        '${EndPointAPI.ACCOUNT}/paged?page=$page&size=$size&search=$search',
        // '${EndPointAPI.ACCOUNT}/paged?page=$page&size=$size&search=$search&userid=$userid',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<UserInfoDTO>(
          itemsData,
          UserInfoDTO.fromJson,
        );
      } else {
        result['data'] = <UserInfoDTO>[];
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
      log("Error at getDataWithPagination - AuthRepository: $e");
    }

    return result;
  }

  Future<Map<String, dynamic>> getDataStaffWithPagination(
    int page,
    int size,
    String search,
  ) async {
    Map<String, dynamic> result = {
      'data': <NhanVien>[],
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'totalPages': 0,
      'currentPage': 0,
      'totalItems': 0,
    };
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (search.isNotEmpty) {
        queryParams['search'] = search;
      }
      final response = await get(
        // Đổi từ post thành get
        '${EndPointAPI.NHAN_VIEN}/paged?idcongty=ct001&page=$page&size=$size&search=$search',
        // '${EndPointAPI.ACCOUNT}/paged?page=$page&size=$size&search=$search&userid=$userid',
      );
      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        return result;
      }

      result['status_code'] = Numeral.STATUS_CODE_SUCCESS;

      // Parse response data using the correct key 'items', chỉ parse nếu là List
      final itemsData = response.data['items'];
      if (itemsData is List) {
        result['data'] = ResponseParser.parseToList<NhanVien>(
          itemsData,
          NhanVien.fromJson,
        );
      } else {
        result['data'] = <NhanVien>[];
      }
      result['totalPages'] = response.data['totalPages'] ?? 0;
      result['currentPage'] = response.data['page'] ?? 0;
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
      log("Error at getDataStaffWithPagination - AuthRepository: $e");
    }

    return result;
  }
}
