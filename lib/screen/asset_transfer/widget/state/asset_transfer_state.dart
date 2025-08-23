import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class AssetTransferState {
  bool isEditing = false;
  bool isNguoiLapPhieuKyNhay = false;
  bool isQuanTrongCanXacNhan = false;
  bool isPhoPhongXacNhan = false;
  bool _isUploading = false;
  bool isRefreshing = false;
  bool isNew = false;
  bool _controllersInitialized = false;

  String? proposingUnit;
  String? _selectedFileName;
  String? _selectedFilePath;
  String? messageEditing;

  int typeTransfer = 1;
  List<ChiTietDieuDongTaiSan> listNewDetails = [];
  List<ChiTietDieuDongTaiSan> _initialDetails = [];
  List<NhanVien> listStaffByDepartment = [];

  UserInfoDTO? nguoiLapPhieu;
  PhongBan? donViGiao;
  PhongBan? donViNhan;
  PhongBan? donViDeNghi;
  NhanVien? nguoiDeNghi;
  NhanVien? tPDonViGiao;
  NhanVien? pPDonViGiao;
  NhanVien? nguoiKyCapPhong;
  NhanVien? nguoiKyGiamDoc;

  DieuDongTaiSanDto? item;
  DieuDongTaiSanDto? itemPreview;

  // Getters
  bool get isUploading => _isUploading;
  bool get controllersInitialized => _controllersInitialized;
  String? get selectedFileName => _selectedFileName;
  String? get selectedFilePath => _selectedFilePath;
  List<ChiTietDieuDongTaiSan> get initialDetails => _initialDetails;

  // Setters
  set isUploading(bool value) => _isUploading = value;
  set controllersInitialized(bool value) => _controllersInitialized = value;
  set selectedFileName(String? value) => _selectedFileName = value;
  set selectedFilePath(String? value) => _selectedFilePath = value;
  set initialDetails(List<ChiTietDieuDongTaiSan> value) => _initialDetails = value;


    void reset() {
    isEditing = false;
    isNguoiLapPhieuKyNhay = false;
    isQuanTrongCanXacNhan = false;
    isPhoPhongXacNhan = false;
    _isUploading = false;
    isRefreshing = false;
    isNew = false;
    
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
    tPDonViGiao = null;
    pPDonViGiao = null;
    nguoiKyCapPhong = null;
    nguoiKyGiamDoc = null;
    
    item = null;
    itemPreview = null;
  }
} 