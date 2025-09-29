class ProjectConstants {
  // Pagination
  static const int defaultRowsPerPage = 10;
  static const int minPaginationThreshold = 5;
  static const int maxPaginationPages = 9999;
  
  // Web-specific pagination options
  static const List<int> mobilePaginationOptions = [10, 20, 50];
  
  // Default values
  static const String defaultCompanyId = "ct001";
  static const bool defaultIsActive = true;
  static const bool defaultHieuLuc = true;
  
  // Web-specific settings
  static const Duration webSnackBarDuration = Duration(seconds: 4);
  static const Duration mobileSnackBarDuration = Duration(seconds: 2);
  
  // Error messages
  static const String errorRequiredField = 'Trường này là bắt buộc';
  static const String errorSystemError = 'Lỗi hệ thống';
  static const String errorLoadProjects = 'Không thể tải danh sách dự án';
  static const String errorCreateProject = 'Tạo dự án thất bại';
  static const String errorCreateProjectBatch = 'Tạo danh sách dự án thất bại';
  static const String errorUpdateProject = 'Cập nhật dự án thất bại';
  static const String errorDeleteProject = 'Xóa dự án thất bại';
  static const String errorDeleteProjectBatch = 'Xóa danh sách dự án thất bại';
  static const String errorImportData = 'Import dữ liệu thất bại';
  static const String errorExportData = 'Export dữ liệu thất bại';
  
  // Success messages
  static const String successCreateProject = 'Thêm dự án thành công';
  static const String successUpdateProject = 'Cập nhật dự án thành công';
  static const String successDeleteProject = 'Xóa dự án thành công';
  static const String successDeleteProjectBatch = 'Xóa danh sách dự án thành công';
  static const String successImportData = 'Import dữ liệu thành công';
  
  // Validation messages
  static const String validationProjectIdRequired = 'Nhập mã dự án';
  static const String validationProjectNameRequired = 'Nhập tên dự án';
  static const String validationProjectIdExists = 'Mã dự án đã tồn tại';
  static const String validationFormIncomplete = 'Vui lòng điền đầy đủ thông tin bắt buộc';
  
  // UI messages
  static const String confirmDeleteTitle = 'Xác nhận xóa';
  static const String confirmDeleteMessage = 'Bạn có chắc chắn muốn xóa dự án này?';
  static const String cancelText = 'Hủy';
  static const String deleteText = 'Xóa';
  static const String saveText = 'Lưu';
  static const String editText = 'Chỉnh sửa dự án';
  
  // Section titles
  static const String sectionProjectInfo = 'Thông tin dự án';
  
  // Form labels
  static const String labelProjectId = 'Mã dự án';
  static const String labelProjectName = 'Tên dự án';
  static const String labelProjectNote = 'Ghi chú';
  static const String labelIsActive = 'Có hiệu lực';
  
  // Export
  static const String exportFileName = "du_an";
  static const String exportProjectId = 'Mã dự án';
  static const String exportProjectName = 'Tên dự án';
  static const String exportProjectNote = 'Ghi chú';
  static const String exportIsActive = 'Hiệu lực';
}
