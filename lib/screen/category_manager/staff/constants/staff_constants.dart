class StaffConstants {
  // Pagination
  static const int defaultRowsPerPage = 10;
  static const int minPaginationThreshold = 5;
  static const int maxPaginationPages = 9999;
  
  // Web-specific pagination options
  static const List<int> webPaginationOptions = [10, 20, 50, 100];
  static const List<int> mobilePaginationOptions = [10, 20, 50];
  
  // Validation
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 11;
  
  // File upload
  static const List<String> allowedImageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp'];
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB for web
  
  // Default values
  static const String defaultCompanyId = "ct001";
  
  // Web-specific settings
  static const Duration webSnackBarDuration = Duration(seconds: 4);
  static const Duration mobileSnackBarDuration = Duration(seconds: 2);
  
  // Error messages
  static const String errorEmailFormat = 'Email không đúng định dạng';
  static const String errorPhoneFormat = 'Số điện thoại phải có 10-11 chữ số';
  static const String errorRequiredField = 'Trường này là bắt buộc';
  static const String errorSystemError = 'Lỗi hệ thống';
  static const String errorUploadSignature = 'Upload file chữ ký thất bại';
  static const String errorSelectSignatureFile = 'Vui lòng chọn file chữ ký';
  static const String errorPinRequired = 'Vui lòng nhập mã PIN để lấy Agreement UUID';
  static const String errorFileTooLarge = 'File quá lớn. Kích thước tối đa là 5MB';
  static const String errorFileReadFailed = 'Không thể đọc file. Vui lòng chọn file khác.';
}
