class CapitalSourceConstants {
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
  static const String errorLoadCapitalSources = 'Không thể tải danh sách nguồn vốn';
  static const String errorAddCapitalSource = 'Thêm nguồn vốn thất bại';
  static const String errorUpdateCapitalSource = 'Cập nhật nguồn vốn thất bại';
  static const String errorDeleteCapitalSource = 'Xóa nguồn vốn thất bại';
  static const String errorImportData = 'Import dữ liệu thất bại';
  static const String errorExportData = 'Export dữ liệu thất bại';
  
  // Success messages
  static const String successAddCapitalSource = 'Thêm nguồn vốn thành công';
  static const String successUpdateCapitalSource = 'Cập nhật nguồn vốn thành công';
  static const String successDeleteCapitalSource = 'Xóa nguồn vốn thành công';
  static const String successImportData = 'Import dữ liệu thành công';
  
  // Validation messages
  static const String validationCapitalSourceIdRequired = 'Nhập mã nguồn vốn';
  static const String validationCapitalSourceNameRequired = 'Nhập tên nguồn vốn';
  static const String validationCapitalSourceIdExists = 'Mã nguồn vốn đã tồn tại';
  
  // UI messages
  static const String confirmDeleteTitle = 'Xác nhận xóa';
  static const String confirmDeleteMessage = 'Bạn có chắc chắn muốn xóa nguồn vốn này?';
  static const String cancelText = 'Hủy';
  static const String deleteText = 'Xóa';
  static const String saveText = 'Lưu';
  static const String editText = 'Chỉnh sửa nguồn vốn';
}
