import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class AssetTransferState {
  bool isEditing = false;
  bool isNguoiLapPhieuKyNhay = false;
  bool _isUploading = false;
  bool isRefreshing = false;
  bool isNew = false;
  bool _controllersInitialized = false;
  bool isByStep = false;

  String? proposingUnit;
  String? _selectedFileName;
  String? _selectedFilePath;
  String? messageEditing;

  int typeTransfer = 1;
  List<ChiTietDieuDongTaiSan> listNewDetails = [];
  List<ChiTietDieuDongTaiSan> _initialDetails = [];
  List<NhanVien> listStaffByDepartment = [];
  List<NhanVien> listNhanVien = [];

  UserInfoDTO? nguoiLapPhieu;
  PhongBan? donViGiao;
  PhongBan? donViNhan;
  PhongBan? donViDeNghi;
  NhanVien? nguoiDeNghi;
  NhanVien? nguoiKyCapPhong;
  NhanVien? nguoiKyGiamDoc;

  DieuDongTaiSanDto? item;
  DieuDongTaiSanDto? itemPreview;

  final List<NhanVien?> additionalSigners = [];
  final List<TextEditingController> additionalSignerControllers = [];
  List<AdditionalSignerData> additionalSignersDetailed = [];
  List<NhanVien> listNhanVienThamMuu = [];
  List<NhanVien> nvPhongGD = [];
  List<AdditionalSignerData> _initialSignersDetailed = [];

  // Getters
  bool get isUploading => _isUploading;
  bool get controllersInitialized => _controllersInitialized;
  String? get selectedFileName => _selectedFileName;
  String? get selectedFilePath => _selectedFilePath;
  List<ChiTietDieuDongTaiSan> get initialDetails => _initialDetails;
  List<AdditionalSignerData> get initialSignersDetailed => _initialSignersDetailed;

  // Setters
  set isUploading(bool value) => _isUploading = value;
  set controllersInitialized(bool value) => _controllersInitialized = value;
  set selectedFileName(String? value) => _selectedFileName = value;
  set selectedFilePath(String? value) => _selectedFilePath = value;
  set initialDetails(List<ChiTietDieuDongTaiSan> value) =>
      _initialDetails = value;
  set initialSignersDetailed(List<AdditionalSignerData> value) =>
      _initialSignersDetailed = value;

  void reset() {
    isEditing = false;
    isNguoiLapPhieuKyNhay = false;
    _isUploading = false;
    isRefreshing = false;
    isNew = false;
    isByStep = false;
    proposingUnit = null;
    _controllersInitialized = false;
    _selectedFileName = null;
    _selectedFilePath = null;

    listNewDetails.clear();
    _initialDetails.clear();
    listStaffByDepartment.clear();

    nguoiLapPhieu = null;
    donViGiao = null;
    donViNhan = null;
    donViDeNghi = null;
    nguoiDeNghi = null;
    nguoiKyCapPhong = null;
    nguoiKyGiamDoc = null;
    additionalSigners.clear();
    additionalSignerControllers.clear();
    additionalSignersDetailed.clear();
    listNhanVienThamMuu.clear();
    listNhanVien.clear();
    item = null;
    itemPreview = null;
    _initialSignersDetailed.clear();

    nvPhongGD.clear();
  }
}
