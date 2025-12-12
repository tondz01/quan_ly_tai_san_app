import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/model/config_dto.dart';
import 'package:quan_ly_tai_san_app/core/utils/menu_refresh_service.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/storage_service.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/auth_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/home/models/menu_data.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';

class AccountHelper {
  //create private constructor
  AccountHelper._privateConstructor();

  //create instance
  static final AccountHelper _instance = AccountHelper._privateConstructor();

  static AccountHelper get instance => _instance;

  // In-memory cache layer để tránh disk I/O liên tục - chỉ cache những data hay dùng nhất
  List<PhongBan>? _departmentCache;
  List<NhanVien>? _nhanVienCache;
  Map<String, PhongBan>? _departmentByIdCache; // O(1) lookup instead of O(n)
  Map<String, NhanVien>? _nhanVienByIdCache; // O(1) lookup instead of O(n)

  // Cache cho counts để tránh tính toán lại nhiều lần
  Map<String, int> _countCache =
      {}; // Key: "assetTransfer_1_userId", "toolMaterialTransfer_2_userId", etc.
  String? _cachedUserTenDangNhap; // Cache user để detect khi user thay đổi
  int _dataVersion = 0; // Version để invalidate cache khi data thay đổi

  // Clear all caches - gọi khi data update
  void clearAllCaches() {
    _departmentCache = null;
    _nhanVienCache = null;
    _departmentByIdCache = null;
    _nhanVienByIdCache = null;
    _clearCountCache();
  }

  // Clear count cache khi data thay đổi
  void _clearCountCache() {
    _countCache.clear();
    _dataVersion++;
  }

  // Kiểm tra và invalidate cache nếu user thay đổi
  void _checkUserChange() {
    final currentUser = getUserInfo()?.tenDangNhap;
    if (_cachedUserTenDangNhap != currentUser) {
      _cachedUserTenDangNhap = currentUser;
      _clearCountCache(); // Clear cache khi user thay đổi
    }
  }

  setUserInfo(userLogin) {
    StorageService.write(StorageKey.USER_INFO, userLogin);
  }

  setAuthInfo(userLogin) {
    StorageService.write(StorageKey.AUTH_INFO, userLogin);
  }

  UserInfoDTO? getUserInfo() {
    final raw = StorageService.read(StorageKey.USER_INFO);
    if (raw == null) return null;
    if (raw is UserInfoDTO) return raw;
    if (raw is Map) return UserInfoDTO.fromJson(Map<String, dynamic>.from(raw));
    return null;
  }

  AuthDTO? getAuthInfo() {
    final raw = StorageService.read(StorageKey.AUTH_INFO);
    if (raw == null) return null;
    if (raw is AuthDTO) return raw;
    if (raw is Map) return AuthDTO.fromJson(Map<String, dynamic>.from(raw));
    return null;
  }

  String getUserId() {
    UserInfoDTO? user = StorageService.read(StorageKey.USER_INFO);
    if (user != null) {
      return user.id;
    }
    return '';
  }

  setToken(String token) {
    StorageService.write(StorageKey.TOKEN, token);
  }

  String? getToken() {
    return StorageService.read(StorageKey.TOKEN);
  }

  setRememberLogin(bool status) {
    StorageService.write(StorageKey.REMEMBER_LOGIN, status);
  }

  bool? getRememberLogin() {
    return StorageService.read(StorageKey.REMEMBER_LOGIN);
  }

  //PHÒNG BAN
  setDepartment(department) {
    StorageService.write(StorageKey.DEPARTMENT, department);
    _departmentCache = null; // Clear cache khi update
    _departmentByIdCache = null;
  }

  void clearDepartment() {
    StorageService.remove(StorageKey.DEPARTMENT);
    _departmentCache = null;
    _departmentByIdCache = null;
  }

  List<PhongBan>? getDepartment() {
    // Return from cache if available
    if (_departmentCache != null) return _departmentCache;

    final raw = StorageService.read(StorageKey.DEPARTMENT);
    if (raw == null) return null;

    try {
      List<PhongBan>? result;
      if (raw is List<PhongBan>) {
        result = raw;
      } else if (raw is List) {
        result =
            raw
                .map((e) {
                  if (e is PhongBan) return e;
                  if (e is Map<String, dynamic>) return PhongBan.fromJson(e);
                  if (e is Map) {
                    return PhongBan.fromJson(Map<String, dynamic>.from(e));
                  }
                  return null;
                })
                .whereType<PhongBan>()
                .toList();
      }

      // Cache the result
      _departmentCache = result;
      return result;
    } catch (e) {
      print('Error parsing department data: $e');
      return null;
    }
  }

  List<PhongBan>? getDepartmentWithOptionAllCompany() {
    final allCompany = PhongBan(
      id: 'all',
      idNhomDonVi: '',
      tenPhongBan: 'Toàn công ty',
      idQuanLy: '',
      idCongTy: 'ct001',
      phongCapTren: '',
      mauSac: '',
      nguoiTao: 'admin',
      nguoiCapNhat: 'admin',
      ngayTao: null,
      ngayCapNhat: null,
      isActive: null,
    );
    final raw = StorageService.read(StorageKey.DEPARTMENT);
    if (raw == null) return [allCompany];

    try {
      List<PhongBan> departments = [];

      if (raw is List<PhongBan>) {
        departments = List<PhongBan>.from(raw);
      } else if (raw is List) {
        departments =
            raw
                .map((e) {
                  if (e is PhongBan) return e;
                  if (e is Map<String, dynamic>) return PhongBan.fromJson(e);
                  if (e is Map) {
                    return PhongBan.fromJson(Map<String, dynamic>.from(e));
                  }
                  return null;
                })
                .whereType<PhongBan>()
                .toList();
      }

      // Thêm "Toàn công ty" vào đầu danh sách
      departments.insert(0, allCompany);
      return departments;
    } catch (e) {
      print('Error parsing department data: $e');
      return [allCompany];
    }
  }

  PhongBan? getDepartmentById(String id) {
    // Build Map cache for O(1) lookup if not exists
    if (_departmentByIdCache == null) {
      final departments = getDepartment();
      if (departments == null) return null;

      _departmentByIdCache = {
        for (var dept in departments)
          if (dept.id != null) dept.id!: dept,
      };
    }

    // O(1) lookup instead of O(n) loop
    return _departmentByIdCache?[id];
  }

  //NHÂN VIÊN
  setNhanVien(nhanVien) {
    StorageService.write(StorageKey.NHAN_VIEN, nhanVien);
    _nhanVienCache = null; // Clear cache khi update
    _nhanVienByIdCache = null;
  }

  void clearNhanVien() {
    StorageService.remove(StorageKey.NHAN_VIEN);
    _nhanVienCache = null;
    _nhanVienByIdCache = null;
  }

  List<NhanVien>? getNhanVien() {
    // Return from cache if available
    if (_nhanVienCache != null) return _nhanVienCache;

    final raw = StorageService.read(StorageKey.NHAN_VIEN);
    if (raw == null) return null;

    List<NhanVien>? result;
    if (raw is List<NhanVien>) {
      result = raw;
    } else if (raw is List) {
      try {
        result =
            raw
                .map(
                  (e) =>
                      e is NhanVien
                          ? e
                          : NhanVien.fromJson(e as Map<String, dynamic>),
                )
                .toList();
      } catch (e) {
        log('Error at getNhanVien: $e');
        return null;
      }
    }

    // Cache the result
    _nhanVienCache = result;
    return result;
  }

  NhanVien? getNhanVienById(String id) {
    // Build Map cache for O(1) lookup if not exists
    if (_nhanVienByIdCache == null) {
      final nhanVienList = getNhanVien();
      if (nhanVienList == null) return null;

      _nhanVienByIdCache = {
        for (var nv in nhanVienList)
          if (nv.id != null) nv.id!: nv,
      };
    }

    // O(1) lookup instead of O(n) firstWhere
    return _nhanVienByIdCache?[id];
  }

  //CHỨC VỤ
  setChucVu(chucVu) {
    StorageService.write(StorageKey.CHUC_VU, chucVu);
  }

  void clearChucVu() {
    StorageService.remove(StorageKey.CHUC_VU);
  }

  List<ChucVu>? getChucVu() {
    final raw = StorageService.read(StorageKey.CHUC_VU);
    if (raw == null) return null;
    if (raw is List<ChucVu>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map((e) => ChucVu.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (e) {
        log('Error at getChucVu: $e');
        return null;
      }
    }
    log('Error at getChucVu: $raw');
    return null;
  }

  ChucVu? getChucVuById(String id) {
    final list = getChucVu();
    if (list == null) return null;
    return list.firstWhere(
      (chucVu) => chucVu.id == id,
      orElse: () => ChucVu.empty(),
    );
  }

  //ASSET GROUP
  setAssetGroup(List<AssetGroupDto> assetGroups) {
    StorageService.write(
      StorageKey.ASSET_GROUP,
      assetGroups.map((e) => e.toJson()).toList(),
    );
  }

  void clearAssetGroup() {
    StorageService.remove(StorageKey.ASSET_GROUP);
  }

  List<AssetGroupDto>? getAssetGroup() {
    final raw = StorageService.read(StorageKey.ASSET_GROUP);
    if (raw == null) return null;
    if (raw is List<AssetGroupDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map(
              (e) =>
                  AssetGroupDto.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      } catch (e) {
        log('Error at getAssetGroup: $e');
        return null;
      }
    }
    log('Error at getAssetGroup: $raw');
    return null;
  }

  AssetGroupDto? getAssetGroupById(String id) {
    final list = getAssetGroup();
    if (list == null) return null;
    return list.firstWhere(
      (assetGroup) => assetGroup.id == id,
      orElse: () => AssetGroupDto(),
    );
  }

  //CCDC GROUP
  setCcdcGroup(List<CcdcGroup> ccdcGroups) {
    StorageService.write(
      StorageKey.CCDC_GROUP,
      ccdcGroups.map((e) => e.toJson()).toList(),
    );
  }

  void clearCcdcGroup() {
    StorageService.remove(StorageKey.CCDC_GROUP);
  }

  List<CcdcGroup>? getCcdcGroup() {
    final raw = StorageService.read(StorageKey.CCDC_GROUP);
    if (raw == null) return null;
    if (raw is List<CcdcGroup>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map((e) => CcdcGroup.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  //REASON INCREASE
  setReasonIncrease(List<ReasonIncrease> reasonIncrease) {
    StorageService.write(
      StorageKey.REASON_INCREASE,
      reasonIncrease.map((e) => e.toJson()).toList(),
    );
  }

  void clearReasonIncrease() {
    StorageService.remove(StorageKey.REASON_INCREASE);
  }

  List<ReasonIncrease>? getReasonIncrease() {
    final raw = StorageService.read(StorageKey.REASON_INCREASE);
    if (raw == null) return null;
    if (raw is List<ReasonIncrease>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map(
              (e) =>
                  ReasonIncrease.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  //ASSET TRANSFER
  setAssetTransfer(assetTransfer) {
    StorageService.write(StorageKey.ASSET_TRANSFER, assetTransfer);
    _clearCountCache(); // Clear cache khi data thay đổi
    // Ensure menu badges refresh whenever dataset is updated
    refreshAllCounts();
  }

  List<DieuDongTaiSanDto>? getAssetTransfer() {
    final raw = StorageService.read(StorageKey.ASSET_TRANSFER);
    if (raw == null) return null;
    if (raw is List<DieuDongTaiSanDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map(
              (e) => DieuDongTaiSanDto.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  //  THÊM: Clear Asset Transfer
  void clearAssetTransfer() {
    StorageService.remove(StorageKey.ASSET_TRANSFER);
    _clearCountCache(); // Clear cache khi data thay đổi
    refreshAllCounts();
  }

  // ASSET CATEGORY
  setAssetCategory(List<AssetCategoryDto> assetCategory) {
    StorageService.write(
      StorageKey.ASSET_CATEGORY,
      assetCategory.map((e) => e.toJson()).toList(),
    );
  }

  List<AssetCategoryDto>? getAssetCategory() {
    final raw = StorageService.read(StorageKey.ASSET_CATEGORY);
    if (raw == null) return null;
    if (raw is List<AssetCategoryDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map(
              (e) => AssetCategoryDto.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  ReasonIncrease? getReasonIncreaseById(String id) {
    final list = getReasonIncrease();
    if (list == null) return null;
    return list.firstWhere(
      (reasonIncrease) => reasonIncrease.id == id,
      orElse: () => ReasonIncrease(),
    );
  }

  void clearAssetCategory() {
    StorageService.remove(StorageKey.ASSET_CATEGORY);
  }

  AssetCategoryDto? getAssetCategoryById(String id) {
    return StorageService.read(StorageKey.ASSET_CATEGORY).firstWhere(
      (assetCategory) => assetCategory.id == id,
      orElse: () => AssetCategoryDto(),
    );
  }

  int getAssetTransferCount(int type) {
    _checkUserChange(); // Kiểm tra user có thay đổi không

    // Cache key: type + user + dataVersion
    final userTenDangNhap = getUserInfo()?.tenDangNhap ?? '';
    final cacheKey = 'assetTransfer_${type}_${userTenDangNhap}_v$_dataVersion';

    // Trả về cached count nếu có
    if (_countCache.containsKey(cacheKey)) {
      return _countCache[cacheKey]!;
    }

    final assetTransfer = getAssetTransfer();
    if (assetTransfer == null || assetTransfer.isEmpty) {
      _countCache[cacheKey] = 0;
      return 0;
    }

    // Cache userTenDangNhap để tránh gọi getUserInfo() nhiều lần
    final userTenDangNhapCached = userTenDangNhap;

    // Tối ưu: combine tất cả filters thành một where() duy nhất
    final listAssetTransfer =
        assetTransfer.where((item) {
          // Filter 1: share hoặc người tạo
          if (item.share != true && item.nguoiTao != userTenDangNhapCached) {
            return false;
          }

          // Filter 2: loại
          if (item.loai != type) {
            return false;
          }

          // Filter 3: signature check (chỉ check nếu cần)
          // Tối ưu: chỉ build signature group khi cần thiết
          // Thứ tự người ký: 1. Người lập phiếu ký nhảy (nếu có) -> 2. Trình duyệt cấp phòng -> 3. Danh sách người ký (sort theo id) -> 4. Trình duyệt giám đốc
          final idSignatureGroup = <Map<String, dynamic>>[];

          // 1. Người lập phiếu ký nhảy (nếu có)
          if (item.nguoiLapPhieuKyNhay == true) {
            idSignatureGroup.add({
              "id": item.idNguoiKyNhay,
              "signed": item.trangThaiKyNhay == true,
            });
          }

          // 2. Trình duyệt cấp phòng
          idSignatureGroup.add({
            "id": item.idTrinhDuyetCapPhong,
            "signed": item.trinhDuyetCapPhongXacNhan == true,
          });

          // 3. Danh sách người ký (sort theo id để đảm bảo thứ tự đúng)
          if (item.listSignatory != null && item.listSignatory!.isNotEmpty) {
            final sortedSignatories = List<SignatoryDto>.from(item.listSignatory!)
              ..sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
            for (var signatory in sortedSignatories) {
              idSignatureGroup.add({
                "id": signatory.idNguoiKy,
                "signed": signatory.trangThai == 1,
              });
            }
          }

          // 4. Trình duyệt giám đốc
          idSignatureGroup.add({
            "id": item.idTrinhDuyetGiamDoc,
            "signed": item.trinhDuyetGiamDocXacNhan == true,
          });

          final userSignature = idSignatureGroup.firstWhere(
            (e) => e["id"] == userTenDangNhapCached,
            orElse: () => {"id": null, "signed": false},
          );

          return userSignature["id"] != null &&
              userSignature["signed"] == false;
        }).toList();

    final count = listAssetTransfer.length;
    _countCache[cacheKey] = count; // Cache kết quả
    return count;
  }

  /// Tổng số phiếu điều động theo loại (không lọc theo quyền ký)
  int getTotalAssetTransferByType(int type) {
    final list = getAssetTransfer();
    if (list == null) return 0;
    return list.where((e) => e.loai == type).length;
  }

  //TOOL AND SUPPLIES
  setToolAndMaterialTransfer(toolAndSupplies) {
    StorageService.write(
      StorageKey.TOOL_AND_MATERIAL_TRANSFER,
      toolAndSupplies,
    );
    _clearCountCache(); // Clear cache khi data thay đổi
    // Keep menu counts in sync after updates
    refreshAllCounts();
  }

  List<ToolAndMaterialTransferDto>? getToolAndMaterialTransfer() {
    final raw = StorageService.read(StorageKey.TOOL_AND_MATERIAL_TRANSFER);
    if (raw == null) return null;
    if (raw is List<ToolAndMaterialTransferDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map(
              (e) => ToolAndMaterialTransferDto.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // 🔥 THÊM: Clear Tool and Material Transfer
  void clearToolAndMaterialTransfer() {
    StorageService.remove(StorageKey.TOOL_AND_MATERIAL_TRANSFER);
    _clearCountCache(); // Clear cache khi data thay đổi
    refreshAllCounts();
  }

  int getToolAndMaterialTransferCount(int type) {
    _checkUserChange(); // Kiểm tra user có thay đổi không

    // Cache key: type + user + dataVersion
    final userTenDangNhap = getUserInfo()?.tenDangNhap ?? '';
    final cacheKey =
        'toolMaterialTransfer_${type}_${userTenDangNhap}_v$_dataVersion';

    // Trả về cached count nếu có
    if (_countCache.containsKey(cacheKey)) {
      return _countCache[cacheKey]!;
    }

    final toolAndSupplies = getToolAndMaterialTransfer();
    if (toolAndSupplies == null || toolAndSupplies.isEmpty) {
      _countCache[cacheKey] = 0;
      return 0;
    }

    // Cache userTenDangNhap để tránh gọi getUserInfo() nhiều lần
    final userTenDangNhapCached = userTenDangNhap;

    // Tối ưu: combine tất cả filters thành một where() duy nhất
    final listToolAndSupplies =
        toolAndSupplies.where((item) {
          // Filter 1: loại
          if (item.loai != type) {
            return false;
          }

          // Filter 2: share hoặc người tạo
          if (item.share != true && item.nguoiTao != userTenDangNhapCached) {
            return false;
          }

          // Filter 3: signature check (chỉ build khi cần)
          // Thứ tự người ký: 1. Người lập phiếu ký nhảy (nếu có) -> 2. Trình duyệt cấp phòng -> 3. Danh sách người ký (sort theo id) -> 4. Trình duyệt giám đốc
          final idSignatureGroup = <Map<String, dynamic>>[];

          // 1. Người lập phiếu ký nhảy (nếu có)
          if (item.nguoiLapPhieuKyNhay == true) {
            idSignatureGroup.add({
              "id": item.idNguoiKyNhay,
              "signed": item.trangThaiKyNhay == true,
            });
          }

          // 2. Trình duyệt cấp phòng
          idSignatureGroup.add({
            "id": item.idTrinhDuyetCapPhong,
            "signed": item.trinhDuyetCapPhongXacNhan == true,
          });

          // 3. Danh sách người ký (sort theo id để đảm bảo thứ tự đúng)
          if (item.listSignatory != null && item.listSignatory!.isNotEmpty) {
            final sortedSignatories = List<SignatoryDto>.from(item.listSignatory!)
              ..sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
            for (var signatory in sortedSignatories) {
              idSignatureGroup.add({
                "id": signatory.idNguoiKy,
                "signed": signatory.trangThai == 1,
              });
            }
          }

          // 4. Trình duyệt giám đốc
          idSignatureGroup.add({
            "id": item.idTrinhDuyetGiamDoc,
            "signed": item.trinhDuyetGiamDocXacNhan == true,
          });

          final userSignature = idSignatureGroup.firstWhere(
            (e) => e["id"] == userTenDangNhapCached,
            orElse: () => {"id": null, "signed": false},
          );

          return userSignature["id"] != null &&
              userSignature["signed"] == false;
        }).toList();

    final count = listToolAndSupplies.length;
    _countCache[cacheKey] = count; // Cache kết quả
    return count;
  }

  //ASSET HANDOVER
  setAssetHandover(assetHandover) {
    StorageService.write(StorageKey.ASSET_HANDOVER, assetHandover);
    _clearCountCache(); // Clear cache khi data thay đổi
    // Trigger global counts refresh
    refreshAllCounts();
  }

  List<AssetHandoverDto>? getAssetHandover() {
    final raw = StorageService.read(StorageKey.ASSET_HANDOVER);
    if (raw == null) return null;
    if (raw is List<AssetHandoverDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map(
              (e) => AssetHandoverDto.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  //  THÊM: Clear Asset Handover
  void clearAssetHandover() {
    StorageService.remove(StorageKey.ASSET_HANDOVER);
    _clearCountCache(); // Clear cache khi data thay đổi
    refreshAllCounts();
  }

  int getAssetHandoverCount() {
    _checkUserChange(); // Kiểm tra user có thay đổi không

    // Cache key: user + dataVersion
    final userTenDangNhap = getUserInfo()?.tenDangNhap ?? '';
    final cacheKey = 'assetHandover_${userTenDangNhap}_v$_dataVersion';

    // Trả về cached count nếu có
    if (_countCache.containsKey(cacheKey)) {
      return _countCache[cacheKey]!;
    }

    final assetHandover = getAssetHandover();
    if (assetHandover == null || assetHandover.isEmpty) {
      _countCache[cacheKey] = 0;
      return 0;
    }

    // Cache userTenDangNhap để tránh gọi getUserInfo() nhiều lần
    final userTenDangNhapCached = userTenDangNhap;

    // Tối ưu: combine tất cả filters thành một where() duy nhất
    final listAssetHandover =
        assetHandover.where((item) {
          // Filter 1: share hoặc người tạo
          if (item.share != true && item.nguoiTao != userTenDangNhapCached) {
            return false;
          }

          // Filter 2: signature check (chỉ build khi cần)
          final idSignatureGroup = <Map<String, dynamic>>[];

          idSignatureGroup.add({
            "id": item.idDaiDienBenGiao,
            "signed": item.daiDienBenGiaoXacNhan == true,
          });

          idSignatureGroup.add({
            "id": item.idDaiDienBenNhan,
            "signed": item.daiDienBenNhanXacNhan == true,
          });

          // Danh sách người ký (sort theo id để đảm bảo thứ tự đúng)
          if (item.listSignatory != null && item.listSignatory!.isNotEmpty) {
            final sortedSignatories = List<SignatoryDto>.from(item.listSignatory!)
              ..sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
            for (var signatory in sortedSignatories) {
              idSignatureGroup.add({
                "id": signatory.idNguoiKy,
                "signed": signatory.trangThai == 1,
              });
            }
          }

          idSignatureGroup.add({
            "id": item.idGiamDoc,
            "signed": item.giamDocKy == true,
          });

          final userSignature = idSignatureGroup.firstWhere(
            (e) => e["id"] == userTenDangNhapCached,
            orElse: () => {"id": null, "signed": false},
          );

          return userSignature["id"] != null &&
              userSignature["signed"] == false;
        }).toList();

    final count = listAssetHandover.length;
    _countCache[cacheKey] = count; // Cache kết quả
    return count;
  }

  //TOOL AND MATERIAL TRANSFER
  setToolAndMaterialHandover(toolAndMaterialTransfer) {
    StorageService.write(
      StorageKey.TOOL_AND_MATERIAL_TRANSFER_HANDOVER,
      toolAndMaterialTransfer,
    );
    _clearCountCache(); // Clear cache khi data thay đổi
    // Refresh menu badges
    refreshAllCounts();
  }

  List<ToolAndSuppliesHandoverDto>? getToolAndMaterialHandover() {
    final raw = StorageService.read(
      StorageKey.TOOL_AND_MATERIAL_TRANSFER_HANDOVER,
    );
    if (raw == null) return null;
    if (raw is List<ToolAndSuppliesHandoverDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map(
              (e) => ToolAndSuppliesHandoverDto.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  int getToolAndMaterialHandoverCount() {
    _checkUserChange(); // Kiểm tra user có thay đổi không

    // Cache key: user + dataVersion
    final userTenDangNhap = getUserInfo()?.tenDangNhap ?? '';
    final cacheKey = 'toolMaterialHandover_${userTenDangNhap}_v$_dataVersion';

    // Trả về cached count nếu có
    if (_countCache.containsKey(cacheKey)) {
      return _countCache[cacheKey]!;
    }

    final toolAndSuppliesHandover = getToolAndMaterialHandover();
    if (toolAndSuppliesHandover == null || toolAndSuppliesHandover.isEmpty) {
      _countCache[cacheKey] = 0;
      return 0;
    }

    // Cache userTenDangNhap để tránh gọi getUserInfo() nhiều lần
    final userTenDangNhapCached = userTenDangNhap;

    // Tối ưu: combine tất cả filters thành một where() duy nhất
    final listToolAndSuppliesHandover =
        toolAndSuppliesHandover.where((item) {
          // Filter 1: share hoặc người tạo
          if (item.share != true && item.nguoiTao != userTenDangNhapCached) {
            return false;
          }

          // Filter 2: signature check (chỉ build khi cần)
          final idSignatureGroup = <Map<String, dynamic>>[];

          idSignatureGroup.add({
            "id": item.idDaiDienBenGiao,
            "signed": item.daiDienBenGiaoXacNhan == true,
          });

          idSignatureGroup.add({
            "id": item.idDaiDienBenNhan,
            "signed": item.daiDienBenNhanXacNhan == true,
          });

          // Danh sách người ký (sort theo id để đảm bảo thứ tự đúng)
          if (item.listSignatory != null && item.listSignatory!.isNotEmpty) {
            final sortedSignatories = List<SignatoryDto>.from(item.listSignatory!)
              ..sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
            for (var signatory in sortedSignatories) {
              idSignatureGroup.add({
                "id": signatory.idNguoiKy,
                "signed": signatory.trangThai == 1,
              });
            }
          }

          idSignatureGroup.add({
            "id": item.idGiamDoc,
            "signed": item.giamDocKy == true,
          });

          final userSignature = idSignatureGroup.firstWhere(
            (e) => e["id"] == userTenDangNhapCached,
            orElse: () => {"id": null, "signed": false},
          );

          return userSignature["id"] != null &&
              userSignature["signed"] == false;
        }).toList();

    final count = listToolAndSuppliesHandover.length;
    _countCache[cacheKey] = count; // Cache kết quả
    return count;
  }

  // 🔥 THÊM: Clear Tool and Supplies Handover
  void clearToolAndSuppliesHandover() {
    StorageService.remove(StorageKey.TOOL_AND_MATERIAL_TRANSFER_HANDOVER);
    _clearCountCache(); // Clear cache khi data thay đổi
    refreshAllCounts();
  }

  //  THÊM: Clear tất cả dữ liệu
  void clearAllData() {
    clearAssetTransfer();
    clearAssetHandover();
    clearToolAndMaterialTransfer();
    clearToolAndSuppliesHandover();
    refreshAllCounts();
  }

  // 🔥 THÊM: Clear dữ liệu theo loại
  void clearDataByType(String type) {
    switch (type.toLowerCase()) {
      case 'asset_transfer':
        clearAssetTransfer();
        break;
      case 'asset_handover':
        clearAssetHandover();
        break;
      case 'tool_and_material_transfer':
        clearToolAndMaterialTransfer();
        break;
      case 'tool_and_supplies_handover':
        clearToolAndSuppliesHandover();
        break;
      default:
        log('Unknown data type: $type');
    }
  }

  /// Method để refresh tất cả count values
  void refreshCounts() {
    // Trigger rebuild của menu data
    MenuRefreshService().refreshCounts();
  }

  /// Global method để refresh counts từ bất kỳ đâu trong app
  static void refreshAllCounts() {
    AppMenuData.refreshAllCounts();
  }

  //Config
  setConfigTimeExpire(ConfigDto config) {
    StorageService.write(StorageKey.CONFIG_TIME_EXPIRE, config);
  }

  ConfigDto? getConfigTimeExpire() {
    final raw = StorageService.read(StorageKey.CONFIG_TIME_EXPIRE);
    if (raw == null) return null;
    if (raw is ConfigDto) return raw;
    if (raw is Map) return ConfigDto.fromJson(Map<String, dynamic>.from(raw));
    return null;
  }

  // Global type asset
  setTypeAsset(List<TypeAsset> typeAsset) {
    if (typeAsset.isNotEmpty) {
      StorageService.write(StorageKey.TYPE_ASSET, typeAsset);
    }
  }

  // List<TypeAsset> getAllTypeAsset() {
  //   final raw = StorageService.read(StorageKey.TYPE_ASSET);
  //   if (raw == null) return [];
  //   if (raw is List<TypeAsset>) return raw;
  //   return [];
  // }
  List<TypeAsset> getAllTypeAsset() {
    final raw = StorageService.read(StorageKey.TYPE_ASSET);
    if (raw == null) return [];
    if (raw is List<TypeAsset>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map((e) => TypeAsset.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  List<TypeAsset> getTypeAsset(String idTypeAsset) {
    final List<TypeAsset> all = getAllTypeAsset();
    final List<TypeAsset> filtered =
        all.where((element) => element.idLoaiTs == idTypeAsset).toList();
    return filtered;
  }

  TypeAsset? getTypeAssetById(String idTypeAsset) {
    if (idTypeAsset.isEmpty) return null;
    final List<TypeAsset> all = getAllTypeAsset();
    for (final t in all) {
      if (t.id == idTypeAsset) return t;
    }
    return null;
  }

  TypeAsset? getTypeAssetObject(String idAssetGroup) {
    try {
      final raw = StorageService.read(StorageKey.TYPE_ASSET)?.firstWhere(
        (element) => element.id == idAssetGroup,
        orElse: () => null,
      );
      if (raw == null) return null;
      return raw is TypeAsset
          ? raw
          : TypeAsset.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  clearTypeAsset() {
    StorageService.remove(StorageKey.TYPE_ASSET);
  }

  // Global type ccdc
  setTypeCcdc(List<TypeCcdc> typeCcdc) {
    if (typeCcdc.isNotEmpty) {
      StorageService.write(StorageKey.TYPE_CCDCV, typeCcdc);
    }
  }

  List<TypeCcdc> getAllTypeCcdc() {
    final raw = StorageService.read(StorageKey.TYPE_CCDCV);
    if (raw == null) return [];
    if (raw is List<TypeCcdc>) return raw;
    return [];
  }

  List<TypeCcdc> getTypeCcdc(String idCcdcGroup) {
    final raw = StorageService.read(StorageKey.TYPE_CCDCV);
    if (raw == null) return [];
    if (raw is List<TypeCcdc>) {
      return raw.where((element) => element.idLoaiCCDC == idCcdcGroup).toList();
    }
    return [];
  }

  TypeCcdc? getTypeCcdcObject(String idCcdcGroup) {
    try {
      final raw = StorageService.read(
        StorageKey.TYPE_CCDCV,
      )?.firstWhere((element) => element.id == idCcdcGroup, orElse: () => null);
      if (raw == null) return null;
      if (raw is TypeCcdc) return raw;
      if (raw is Map) return TypeCcdc.fromJson(Map<String, dynamic>.from(raw));
      return null;
    } catch (_) {
      return null;
    }
  }

  clearTypeCcdc() {
    StorageService.remove(StorageKey.TYPE_CCDCV);
  }

  // Global unit
  setUnit(List<UnitDto> unit) {
    if (unit.isNotEmpty) {
      StorageService.write(StorageKey.UNIT, unit);
    }
  }

  clearUnit() {
    StorageService.remove(StorageKey.UNIT);
  }

  List<UnitDto> getAllUnit() {
    final raw = StorageService.read(StorageKey.UNIT);
    if (raw == null) return [];
    try {
      if (raw is List<UnitDto>) return raw;
      if (raw is List) {
        return raw
            .map((e) {
              if (e is UnitDto) return e;
              if (e is Map<String, dynamic>) return UnitDto.fromJson(e);
              if (e is Map) {
                return UnitDto.fromJson(Map<String, dynamic>.from(e));
              }
              return null;
            })
            .whereType<UnitDto>()
            .toList();
      }
    } catch (_) {}
    return [];
  }

  UnitDto? getUnitById(String idUnit) {
    final units = getAllUnit();
    if (units.isEmpty) return null;

    try {
      return units.firstWhere(
        (unit) => unit.id == idUnit,
        orElse: () => UnitDto(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> setListAsset(List<AssetManagementDto> assets) async {
    if (assets.isNotEmpty) {
      log('Setting list of assets with length: ${assets.length}');
      try {
        // Convert to List<Map> before saving to ensure GetStorage handles it correctly
        // This also helps reduce storage size and improve compatibility
        final List<Map<String, dynamic>> assetsAsMap =
            assets.map((asset) => asset.toJson()).toList();

        log('Converted ${assetsAsMap.length} assets to Map format');

        // Await write to ensure data is saved before reading
        await StorageService.write(StorageKey.ASSETS, assetsAsMap);

        // Wait a bit to ensure write is complete
        await Future.delayed(const Duration(milliseconds: 100));

        final raw = StorageService.read(StorageKey.ASSETS);
        if (raw != null) {
          log(
            'message result setListAsset: ${raw is List ? raw.length : "not a list"}',
          );
        } else {
          log(
            'WARNING: setListAsset: StorageService.read returned null after write',
          );
        }
      } catch (e) {
        log('ERROR in setListAsset: $e');
      }
    }
  }

  List<AssetManagementDto> getAllAssets() {
    final raw = StorageService.read(StorageKey.ASSETS);
    if (raw == null) return [];
    if (raw is List<AssetManagementDto>) return raw;
    if (raw is List) {
      return raw
          .map((e) {
            if (e is AssetManagementDto) return e;
            if (e is Map) {
              return AssetManagementDto.fromJson(Map<String, dynamic>.from(e));
            }
            return null;
          })
          .whereType<AssetManagementDto>()
          .toList();
    }
    return [];
  }

  setListCCDC(List<ToolsAndSuppliesDto> ccdc) {
    if (ccdc.isNotEmpty) {
      StorageService.write(StorageKey.CCDC_VT, ccdc);
    }
  }

  List<ToolsAndSuppliesDto> getAllCCDC() {
    final raw = StorageService.read(StorageKey.CCDC_VT);
    if (raw == null) return [];
    if (raw is List<ToolsAndSuppliesDto>) return raw;
    if (raw is List) {
      return raw
          .map((e) {
            if (e is ToolsAndSuppliesDto) return e;
            if (e is Map) {
              return ToolsAndSuppliesDto.fromJson(Map<String, dynamic>.from(e));
            }
            return null;
          })
          .whereType<ToolsAndSuppliesDto>()
          .toList();
    }
    return [];
  }

  void clearListCCDC() {
    StorageService.remove(StorageKey.CCDC_VT);
  }

  void clearListAsset() {
    StorageService.remove(StorageKey.ASSETS);
  }

  void setCapitalSource(List<NguonKinhPhi> capitalSource) {
    if (capitalSource.isNotEmpty) {
      StorageService.write(StorageKey.NGUON_KINH_PHI, capitalSource);
    }
  }

  List<NguonKinhPhi> getAllCapitalSource() {
    final raw = StorageService.read(StorageKey.NGUON_KINH_PHI);
    if (raw == null) return [];
    if (raw is List<NguonKinhPhi>) return raw;
    return [];
  }

  void clearCapitalSource() {
    StorageService.remove(StorageKey.NGUON_KINH_PHI);
  }

  void setProject(List<DuAn> project) {
    if (project.isNotEmpty) {
      StorageService.write(StorageKey.DU_AN, project);
    }
  }

  List<DuAn> getAllProject() {
    final raw = StorageService.read(StorageKey.DU_AN);
    if (raw == null) return [];
    if (raw is List<DuAn>) return raw;
    return [];
  }

  void clearProject() {
    StorageService.remove(StorageKey.DU_AN);
  }
}
