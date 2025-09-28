class AssetCategoryConstants {
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
  static const String errorLoadAssetCategories = 'Không thể tải danh sách mô hình tài sản';
  static const String errorAddAssetCategory = 'Thêm mô hình tài sản thất bại';
  static const String errorUpdateAssetCategory = 'Cập nhật mô hình tài sản thất bại';
  static const String errorDeleteAssetCategory = 'Xóa mô hình tài sản thất bại';
  static const String errorImportData = 'Import dữ liệu thất bại';
  static const String errorExportData = 'Export dữ liệu thất bại';
  
  // Success messages
  static const String successAddAssetCategory = 'Thêm mô hình tài sản thành công';
  static const String successUpdateAssetCategory = 'Cập nhật mô hình tài sản thành công';
  static const String successDeleteAssetCategory = 'Xóa mô hình tài sản thành công';
  static const String successImportData = 'Import dữ liệu thành công';
  
  // Validation messages
  static const String validationAssetCategoryIdRequired = 'Nhập mã mô hình tài sản';
  static const String validationAssetCategoryNameRequired = 'Nhập tên mô hình tài sản';
  static const String validationAssetCategoryIdExists = 'Mã mô hình tài sản đã tồn tại';
  
  // UI messages
  static const String confirmDeleteTitle = 'Xác nhận xóa';
  static const String confirmDeleteMessage = 'Bạn có chắc chắn muốn xóa mô hình tài sản này?';
  static const String cancelText = 'Hủy';
  static const String deleteText = 'Xóa';
  static const String saveText = 'Lưu';
  static const String editText = 'Chỉnh sửa mô hình tài sản';
}
