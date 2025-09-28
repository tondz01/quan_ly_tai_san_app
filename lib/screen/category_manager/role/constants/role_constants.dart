class RoleConstants {
  // Pagination
  static const int defaultRowsPerPage = 10;
  static const int minPaginationThreshold = 5;
  static const int maxPaginationPages = 9999;
  
  // Web-specific pagination options
  static const List<int> mobilePaginationOptions = [10, 20, 50];
  
  // Default values
  static const String defaultCompanyId = "ct001";
  
  // Web-specific settings
  static const Duration webSnackBarDuration = Duration(seconds: 4);
  static const Duration mobileSnackBarDuration = Duration(seconds: 2);
  
  // Error messages
  static const String errorRequiredField = 'Trường này là bắt buộc';
  static const String errorSystemError = 'Lỗi hệ thống';
  static const String errorLoadRoles = 'Không thể tải danh sách chức vụ';
  static const String errorCreateRole = 'Tạo chức vụ thất bại';
  static const String errorUpdateRole = 'Cập nhật chức vụ thất bại';
  static const String errorDeleteRole = 'Xóa chức vụ thất bại';
  static const String errorImportData = 'Import dữ liệu thất bại';
  static const String errorExportData = 'Export dữ liệu thất bại';
  
  // Success messages
  static const String successCreateRole = 'Thêm chức vụ thành công';
  static const String successUpdateRole = 'Cập nhật chức vụ thành công';
  static const String successDeleteRole = 'Xóa chức vụ thành công';
  static const String successDeleteRoleBatch = 'Xóa danh sách chức vụ thành công';
  static const String successImportData = 'Import dữ liệu thành công';
  
  // Validation messages
  static const String validationRoleIdRequired = 'Nhập mã chức vụ';
  static const String validationRoleNameRequired = 'Nhập tên chức vụ';
  static const String validationRoleIdExists = 'Mã chức vụ đã tồn tại';
  static const String validationFormIncomplete = 'Vui lòng điền đầy đủ thông tin bắt buộc';
  
  // UI messages
  static const String confirmDeleteTitle = 'Xác nhận xóa';
  static const String confirmDeleteMessage = 'Bạn có chắc chắn muốn xóa chức vụ này?';
  static const String cancelText = 'Hủy';
  static const String deleteText = 'Xóa';
  static const String saveText = 'Lưu';
  static const String editText = 'Chỉnh sửa chức vụ';
  
  // Permission labels
  static const String permissionManageStaff = 'Quản lý nhân viên';
  static const String permissionManageDepartment = 'Quản lý phòng ban';
  static const String permissionManageProject = 'Quản lý dự án';
  static const String permissionManageFund = 'Quản lý nguồn vốn';
  static const String permissionManageAssetModel = 'Quản lý mô hình tài sản';
  static const String permissionManageAssetGroup = 'Quản lý nhóm tài sản';
  static const String permissionManageAsset = 'Quản lý tài sản';
  static const String permissionManageSupplies = 'Quản lý CCDC vật tư';
  static const String permissionTransferAsset = 'Điều động tài sản';
  static const String permissionTransferSupplies = 'Điều động CCDC vật tư';
  static const String permissionHandoverAsset = 'Bàn giao tài sản';
  static const String permissionHandoverSupplies = 'Bàn giao CCDC vật tư';
  static const String permissionReport = 'Báo cáo';
  
  // Section titles
  static const String sectionRoleInfo = 'Thông tin chức vụ';
  static const String sectionPermissions = 'Phân quyền quản lý';
}
