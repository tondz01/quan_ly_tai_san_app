import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/storage_service.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/auth_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

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
}
