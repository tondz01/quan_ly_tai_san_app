class DepartmentConstants {
  // Pagination
  static const int defaultRowsPerPage = 10;
  static const int minPaginationThreshold = 5;
  static const int maxPaginationPages = 9999;
  
  // Web-specific pagination options
  static const List<int> mobilePaginationOptions = [10, 20, 50];
  
  // Default values
  static const String defaultCompanyId = "ct001";
  static const bool defaultIsActive = true;
  
  // Web-specific settings
  static const Duration webSnackBarDuration = Duration(seconds: 4);
  static const Duration mobileSnackBarDuration = Duration(seconds: 2);
  
  // Error messages
  static const String errorRequiredField = 'Trường này là bắt buộc';
  static const String errorSystemError = 'Lỗi hệ thống';
  static const String errorLoadDepartments = 'Không thể tải danh sách phòng ban';
  static const String errorAddDepartment = 'Thêm phòng ban thất bại';
  static const String errorUpdateDepartment = 'Cập nhật phòng ban thất bại';
  static const String errorDeleteDepartment = 'Xóa phòng ban thất bại';
  static const String errorImportData = 'Import dữ liệu thất bại';
  static const String errorExportData = 'Export dữ liệu thất bại';
  
  // Success messages
  static const String successAddDepartment = 'Thêm phòng ban thành công';
  static const String successUpdateDepartment = 'Cập nhật phòng ban thành công';
  static const String successDeleteDepartment = 'Xóa phòng ban thành công';
  static const String successImportData = 'Import dữ liệu thành công';
  
  // Validation messages
  static const String validationDepartmentIdRequired = 'Nhập mã đơn vị';
  static const String validationDepartmentNameRequired = 'Nhập tên phòng/ban';
  static const String validationDepartmentIdExists = 'Mã đơn vị đã tồn tại';
  
  // UI messages
  static const String confirmDeleteTitle = 'Xác nhận xóa';
  static const String confirmDeleteMessage = 'Bạn có chắc chắn muốn xóa phòng ban này?';
  static const String cancelText = 'Hủy';
  static const String deleteText = 'Xóa';
  static const String saveText = 'Lưu';
  static const String editText = 'Chỉnh sửa đơn vị/phòng ban';
}
