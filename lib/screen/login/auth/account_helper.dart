import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/model/config_dto.dart';
import 'package:quan_ly_tai_san_app/core/utils/menu_refresh_service.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/storage_service.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/auth_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/home/models/menu_data.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';

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

  void clearDepartment() {
    StorageService.remove(StorageKey.DEPARTMENT);
  }

  List<PhongBan>? getDepartment() {
    final raw = StorageService.read(StorageKey.DEPARTMENT);
    if (raw == null) return null;

    try {
      if (raw is List<PhongBan>) return raw;
      if (raw is List) {
        return raw
            .map((e) {
              if (e is PhongBan) return e;
              if (e is Map<String, dynamic>) return PhongBan.fromJson(e);
              if (e is Map)
                return PhongBan.fromJson(Map<String, dynamic>.from(e));
              return null;
            })
            .whereType<PhongBan>()
            .toList();
      }
      return null;
    } catch (e) {
      print('Error parsing department data: $e');
      return null;
    }
  }

  PhongBan? getDepartmentById(String id) {
    final departments = getDepartment();
    if (departments == null) return null;

    try {
      for (final d in departments) {
        if (d.id == id) return d;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  //NHÂN VIÊN
  setNhanVien(nhanVien) {
    StorageService.write(StorageKey.NHAN_VIEN, nhanVien);
  }

  void clearNhanVien() {
    StorageService.remove(StorageKey.NHAN_VIEN);
  }

  List<NhanVien>? getNhanVien() {
    final raw = StorageService.read(StorageKey.NHAN_VIEN);
    if (raw == null) return null;
    if (raw is List<NhanVien>) return raw;
    if (raw is List) {
      try {
        return raw
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
    return null;
  }

  NhanVien? getNhanVienById(String id) {
    final nhanVienList = getNhanVien();
    if (nhanVienList == null) return null;

    try {
      return nhanVienList.firstWhere(
        (nhanVien) => nhanVien.id == id,
        orElse: () => NhanVien(),
      );
    } catch (e) {
      print('Error parsing nhanVien data: $e');
      return NhanVien();
    }
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
    StorageService.write(StorageKey.ASSET_GROUP, assetGroups);
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

  //CCDC GROUP
  setCcdcGroup(List<CcdcGroup> ccdcGroups) {
    StorageService.write(StorageKey.CCDC_GROUP, ccdcGroups);
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
    refreshAllCounts();
  }

  // ASSET CATEGORY
  setAssetCategory(List<AssetCategoryDto> assetCategory) {
    StorageService.write(StorageKey.ASSET_CATEGORY, assetCategory);
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
    final assetTransfer = getAssetTransfer();
    final listAssetTransfer =
        assetTransfer
            ?.where(
              (item) =>
                  item.share == true ||
                  item.nguoiTao == getUserInfo()?.tenDangNhap,
            )
            .where((item) {
              final idSignatureGroup =
                  [
                    if (item.nguoiLapPhieuKyNhay == true)
                      {
                        "id": item.idNguoiKyNhay,
                        "signed": item.trangThaiKyNhay == true,
                        "label": "Người lập phiếu: ${item.tenNguoiKyNhay}",
                      },
                    {
                      "id": item.idTrinhDuyetCapPhong,
                      "signed": item.trinhDuyetCapPhongXacNhan == true,
                      "label": "Người duyệt: ${item.tenTrinhDuyetCapPhong}",
                    },
                    for (int i = 0; i < (item.listSignatory?.length ?? 0); i++)
                      {
                        "id": item.listSignatory![i].idNguoiKy,
                        "signed": item.listSignatory![i].trangThai == 1,
                        "label":
                            "Người ký ${i + 1}: ${item.listSignatory![i].tenNguoiKy}",
                      },
                    {
                      "id": item.idTrinhDuyetGiamDoc,
                      "signed": item.trinhDuyetGiamDocXacNhan == true,
                      "label": "Người phê duyệt: ${item.tenTrinhDuyetGiamDoc}",
                    },
                  ].toList();

              final userSignature = idSignatureGroup.firstWhere(
                (e) => e["id"] == getUserInfo()?.tenDangNhap,
                orElse: () => {"id": null, "signed": false, "label": ""},
              );

              return userSignature["id"] != null &&
                  userSignature["signed"] == false;
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
    refreshAllCounts();
  }

  int getToolAndMaterialTransferCount(int type) {
    final toolAndSupplies = getToolAndMaterialTransfer();
    final listToolAndSupplies =
        toolAndSupplies
            ?.where((element) => element.loai == type)
            .where((item) {
              return item.share == true ||
                  item.nguoiTao == getUserInfo()?.tenDangNhap;
            })
            .where((item) {
              final idSignatureGroup =
                  [
                    if (item.nguoiLapPhieuKyNhay == true)
                      {
                        "id": item.idNguoiKyNhay,
                        "signed": item.trangThaiKyNhay == true,
                        "label":
                            "Người lập phiếu: ${getNhanVienById(item.idNguoiKyNhay ?? '')?.hoTen}",
                      },
                    {
                      "id": item.idTrinhDuyetCapPhong,
                      "signed": item.trinhDuyetCapPhongXacNhan == true,
                      "label": "Người duyệt: ${item.tenTrinhDuyetCapPhong}",
                    },
                    for (int i = 0; i < (item.listSignatory?.length ?? 0); i++)
                      {
                        "id": item.listSignatory![i].idNguoiKy,
                        "signed": item.listSignatory![i].trangThai == 1,
                        "label":
                            "Người ký ${i + 1}: ${item.listSignatory![i].tenNguoiKy}",
                      },
                    {
                      "id": item.idTrinhDuyetGiamDoc,
                      "signed": item.trinhDuyetGiamDocXacNhan == true,
                      "label": "Người phê duyệt: ${item.tenTrinhDuyetGiamDoc}",
                    },
                  ].toList();

              final userSignature = idSignatureGroup.firstWhere(
                (e) => e["id"] == getUserInfo()?.tenDangNhap,
                orElse: () => {"id": null, "signed": false, "label": ""},
              );

              return userSignature["id"] != null &&
                  userSignature["signed"] == false;
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
    refreshAllCounts();
  }

  int getAssetHandoverCount() {
    final assetHandover = getAssetHandover();
    final listAssetHandover =
        assetHandover
            ?.where(
              (item) =>
                  item.share == true ||
                  item.nguoiTao == getUserInfo()?.tenDangNhap,
            )
            .where((item) {
              final idSignatureGroup =
                  [
                    {
                      "id": item.idDaiDiendonviBanHanhQD,
                      "signed": item.daXacNhan == true,
                      "label":
                          "Đại diện đơn vị đề nghị: ${item.tenDaiDienBanHanhQD}",
                    },
                    {
                      "id": item.idDaiDienBenGiao,
                      "signed": item.daiDienBenGiaoXacNhan == true,
                      "label":
                          "Đại diện đơn vị giao: ${item.tenDaiDienBenGiao}",
                    },
                    {
                      "id": item.idDaiDienBenNhan,
                      "signed": item.daiDienBenNhanXacNhan == true,
                      "label":
                          "Đại diện đơn vị nhận: ${item.tenDaiDienBenNhan}",
                    },
                    if (item.listSignatory?.isNotEmpty ?? false)
                      ...(item.listSignatory
                              ?.map(
                                (e) => {
                                  "id": e.idNguoiKy,
                                  "signed": e.trangThai == 1,
                                  "label": "Người ký: ${e.tenNguoiKy ?? ''}",
                                },
                              )
                              .toList() ??
                          []),
                  ].toList();

              final userSignature = idSignatureGroup.firstWhere(
                (e) => e["id"] == getUserInfo()?.tenDangNhap,
                orElse: () => {"id": null, "signed": false, "label": ""},
              );

              return userSignature["id"] != null &&
                  userSignature["signed"] == false;
            })
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
    final toolAndSuppliesHandover = getToolAndMaterialHandover();
    final listToolAndSuppliesHandover =
        toolAndSuppliesHandover
            ?.where(
              (item) =>
                  item.share == true ||
                  item.nguoiTao == getUserInfo()?.tenDangNhap,
            )
            .where((item) {
              final idSignatureGroup =
                  [
                    {
                      "id": item.idDaiDiendonviBanHanhQD,
                      "signed": item.daXacNhan == true,
                      "label":
                          "Đại diện đơn vị đề nghị: ${item.tenDaiDienBanHanhQD}",
                    },
                    {
                      "id": item.idDaiDienBenGiao,
                      "signed": item.daiDienBenGiaoXacNhan == true,
                      "label":
                          "Đại diện đơn vị giao: ${item.tenDaiDienBenGiao}",
                    },
                    {
                      "id": item.idDaiDienBenNhan,
                      "signed": item.daiDienBenNhanXacNhan == true,
                      "label":
                          "Đại diện đơn vị nhận: ${item.tenDaiDienBenNhan}",
                    },
                    if (item.listSignatory?.isNotEmpty ?? false)
                      ...(item.listSignatory
                              ?.map(
                                (e) => {
                                  "id": e.idNguoiKy,
                                  "signed": e.trangThai == 1,
                                  "label": "Người ký: ${e.tenNguoiKy ?? ''}",
                                },
                              )
                              .toList() ??
                          []),
                  ].toList();

              final userSignature = idSignatureGroup.firstWhere(
                (e) => e["id"] == getUserInfo()?.tenDangNhap,
                orElse: () => {"id": null, "signed": false, "label": ""},
              );

              return userSignature["id"] != null &&
                  userSignature["signed"] == false;
            })
            .toList();
    return listToolAndSuppliesHandover?.length ?? 0;
  }

  // 🔥 THÊM: Clear Tool and Supplies Handover
  void clearToolAndSuppliesHandover() {
    StorageService.remove(StorageKey.TOOL_AND_MATERIAL_TRANSFER_HANDOVER);
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
    // 🔥 SỬA LẠI: Gọi AppMenuData.refreshAllCounts() thay vì MenuRefreshService
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
    final raw = StorageService.read(
      StorageKey.TYPE_ASSET,
    )?.firstWhere((element) => element.id == idTypeAsset, orElse: () => null);
    final types =
        raw?.map((e) => TypeAsset.fromJson(e as Map<String, dynamic>)).toList();

    final TypeAsset? found = types?.firstWhere(
      (t) => t.id == idTypeAsset,
      orElse: () => null,
    );
    if (found == null) return null;
    return found;
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
    if (raw is List<UnitDto>) return raw;
    return [];
  }

  UnitDto? getUnitById(String idUnit) {
    final raw = StorageService.read(StorageKey.UNIT);
    if (raw == null) return null;
    if (raw is List<UnitDto>) {
      return raw.firstWhere(
        (unit) => unit.id == idUnit,
        orElse: () => UnitDto(),
      );
    }
    return null;
  }
}
