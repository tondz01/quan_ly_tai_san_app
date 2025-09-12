import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/storage_service.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/auth_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class AccountHelper {
  //create private constructor
  const AccountHelper._privateConstructor();

  //create instance
  static const AccountHelper _instance = AccountHelper._privateConstructor();

  static AccountHelper get instance => _instance;

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
  }

  List<PhongBan>? getDepartment() {
    return StorageService.read(StorageKey.DEPARTMENT);
  }

  PhongBan? getDepartmentById(String id) {
    return StorageService.read(
      StorageKey.DEPARTMENT,
    ).firstWhere((department) => department.id == id, orElse: () => PhongBan());
  }

  //NHÂN VIÊN
  setNhanVien(nhanVien) {
    StorageService.write(StorageKey.NHAN_VIEN, nhanVien);
  }

  List<NhanVien>? getNhanVien() {
    return StorageService.read(StorageKey.NHAN_VIEN);
  }

  NhanVien? getNhanVienById(String id) {
    log('message id getNhanVienById: $id');
    return StorageService.read(
      StorageKey.NHAN_VIEN,
    ).firstWhere((nhanVien) => nhanVien.id == id, orElse: () => NhanVien());
  }

  //CHỨC VỤ
  setChucVu(chucVu) {
    StorageService.write(StorageKey.CHUC_VU, chucVu);
  }

  List<ChucVu>? getChucVu() {
    return StorageService.read(StorageKey.CHUC_VU);
  }

  ChucVu? getChucVuById(String id) {
    return StorageService.read(
      StorageKey.CHUC_VU,
    ).firstWhere((chucVu) => chucVu.id == id, orElse: () => ChucVu.empty());
  }

  //ASSET TRANSFER
  setAssetTransfer(assetTransfer) {
    StorageService.write(StorageKey.ASSET_TRANSFER, assetTransfer);
  }

  List<DieuDongTaiSanDto>? getAssetTransfer() {
    final raw = StorageService.read(StorageKey.ASSET_TRANSFER);
    if (raw == null) return null;
    if (raw is List<DieuDongTaiSanDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map((e) => DieuDongTaiSanDto.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  int getAssetTransferCount(int type) {
    final assetTransfer = getAssetTransfer();
    final listAssetTransfer = assetTransfer
        ?.where(
          (item) =>
              item.share == true || item.nguoiTao == getUserInfo()?.tenDangNhap,
        )
        .where((item) {
          final idSignatureGroup =
              [
                item.nguoiTao,
                item.idNguoiKyNhay,
                item.idTrinhDuyetCapPhong,
                item.idTrinhDuyetGiamDoc,
                if (item.listSignatory != null)
                  ...item.listSignatory!.map((e) => e.idNguoiKy),
              ].whereType<String>().toList();

          final inGroup = idSignatureGroup
              .map((e) => e.toLowerCase())
              .contains(getUserInfo()?.tenDangNhap ?? '');
          return inGroup;
        })
        .where((item) => item.loai == type)
        .toList();
    return listAssetTransfer?.length ?? 0;
  }

  //TOOL AND SUPPLIES
  setToolAndMaterialTransfer(toolAndSupplies) {
    StorageService.write(
      StorageKey.TOOL_AND_MATERIAL_TRANSFER,
      toolAndSupplies,
    );
  }

  List<ToolAndMaterialTransferDto>? getToolAndMaterialTransfer() {
    final raw = StorageService.read(StorageKey.TOOL_AND_MATERIAL_TRANSFER);
    if (raw == null) return null;
    if (raw is List<ToolAndMaterialTransferDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map((e) => ToolAndMaterialTransferDto.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  int getToolAndMaterialTransferCount(int type) {
    final toolAndSupplies = getToolAndMaterialTransfer();
    final listToolAndSupplies = toolAndSupplies
        ?.where((element) => element.loai == type)
        .where((item) {
          return item.share == true ||
              item.nguoiTao == getUserInfo()?.tenDangNhap;
        })
        .where((item) {
          final idSignatureGroup =
              [
                item.nguoiTao,
                item.idNguoiKyNhay,
                item.idTrinhDuyetCapPhong,
                item.idTrinhDuyetGiamDoc,
                if (item.listSignatory != null)
                  ...item.listSignatory!.map((e) => e.idNguoiKy),
              ].whereType<String>().toList();

          final inGroup = idSignatureGroup
              .map((e) => e.toLowerCase())
              .contains(getUserInfo()?.tenDangNhap ?? '');
          return inGroup;
        })
        .toList();
    return listToolAndSupplies?.length ?? 0;
  }

  //ASSET HANDOVER
  setAssetHandover(assetHandover) {
    StorageService.write(StorageKey.ASSET_HANDOVER, assetHandover);
  }

  List<AssetHandoverDto>? getAssetHandover() {
    final raw = StorageService.read(StorageKey.ASSET_HANDOVER);
    if (raw == null) return null;
    if (raw is List<AssetHandoverDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map((e) => AssetHandoverDto.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  int getAssetHandoverCount() {
    final assetHandover = getAssetHandover();
    final listAssetHandover = assetHandover
        ?.where((item) => item.share == true || item.nguoiTao == getUserInfo()?.tenDangNhap)
        .toList();
    return listAssetHandover?.length ?? 0;
  }

  //TOOL AND MATERIAL TRANSFER
  setToolAndMaterialHandover(toolAndMaterialTransfer) {
    StorageService.write(
      StorageKey.TOOL_AND_MATERIAL_TRANSFER_HANDOVER,
      toolAndMaterialTransfer,
    );
  }

  List<ToolAndSuppliesHandoverDto>? getToolAndMaterialHandover() {
    final raw = StorageService.read(StorageKey.TOOL_AND_MATERIAL_TRANSFER_HANDOVER);
    if (raw == null) return null;
    if (raw is List<ToolAndSuppliesHandoverDto>) return raw;
    if (raw is List) {
      try {
        return raw
            .whereType()
            .map((e) => ToolAndSuppliesHandoverDto.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  int getToolAndMaterialHandoverCount() {
    final toolAndSuppliesHandover = getToolAndMaterialHandover();
    final listToolAndSuppliesHandover = toolAndSuppliesHandover
        ?.where((item) => item.share == true || item.nguoiTao == getUserInfo()?.tenDangNhap)
        .toList();
    return listToolAndSuppliesHandover?.length ?? 0;
  }
}
