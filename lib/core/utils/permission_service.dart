import 'package:quan_ly_tai_san_app/screen/login/auth/storage_service.dart';

class PermissionService {
  //create private constructor
  const PermissionService._privateConstructor();

  //create instance
  static const PermissionService _instance =
      PermissionService._privateConstructor();

  static PermissionService get instance => _instance;

  /// Lưu quyền (sau khi login lấy từ API)
  void saveRoles(List<String> roles) {
    StorageService.write(StorageKey.ROLES_KEY, roles);
  }

  /// Xóa quyền (khi logout)
  void clearRoles() {
    StorageService.remove(StorageKey.ROLES_KEY);
  }

  /// Kiểm tra 1 quyền
  bool hasPermission(String roleCode) {
    return StorageService.read(StorageKey.ROLES_KEY)?.contains(roleCode) ??
        false;
  }

  /// Kiểm tra có ít nhất 1 quyền trong list
  bool hasAnyPermission(List<String> roleCodes) {
    return roleCodes.any(
      (code) =>
          StorageService.read(StorageKey.ROLES_KEY)?.contains(code) ?? false,
    );
  }
}
