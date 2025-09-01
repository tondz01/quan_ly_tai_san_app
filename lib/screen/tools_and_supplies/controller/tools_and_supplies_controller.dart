import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

/// Controller xử lý logic nghiệp vụ cho Tools and Supplies Detail
class ToolsAndSuppliesController {
  // Callback để update UI
  final VoidCallback? onStateChanged;
  final Function(String, List<String>)? onShowValidationErrors;
  final Function(String)? onShowErrorMessage;

  ToolsAndSuppliesController({
    this.onStateChanged,
    this.onShowValidationErrors,
    this.onShowErrorMessage,
  });

  /// Validate chi tiết tài sản và trả về danh sách lỗi
  List<String> validateDetailAssets(
    List<DetailAssetDto> detailAssets,
    String assetCode,
  ) {
    List<String> errors = [];

    for (int i = 0; i < detailAssets.length; i++) {
      final detail = detailAssets[i];
      final stt = i + 1;

      // Gán ID và idTaiSan trước khi validate
      detail.id =
          "${DateTime.now().millisecondsSinceEpoch}-${assetCode.trim()}-$i";
      detail.idTaiSan = assetCode.trim();

      // Validate các trường bắt buộc với null safety
      if ((detail.soKyHieu?.trim().isEmpty ?? true)) {
        errors.add('STT $stt: Số ký hiệu không được để trống');
      }

      if ((detail.congSuat?.trim().isEmpty ?? true)) {
        errors.add('STT $stt: Công suất không được để trống');
      }

      if ((detail.nuocSanXuat?.trim().isEmpty ?? true)) {
        errors.add('STT $stt: Nước sản xuất không được để trống');
      }

      // Validate số lượng
      if ((detail.soLuong ?? 0) <= 0) {
        errors.add('STT $stt: Số lượng phải lớn hơn 0');
      }

      // Validate năm sản xuất nếu có
      final currentYear = DateTime.now().year;
      if (detail.namSanXuat != null && detail.namSanXuat! > currentYear) {
        errors.add(
          'STT $stt: Năm sản xuất không được lớn hơn năm hiện tại ($currentYear)',
        );
      }

      // Validate năm sản xuất không quá cũ
      if (detail.namSanXuat != null &&
          detail.namSanXuat! > 0 &&
          detail.namSanXuat! < 1900) {
        errors.add('STT $stt: Năm sản xuất không hợp lệ (phải >= 1900)');
      }
    }

    return errors;
  }

  /// Xử lý và chuẩn hóa dữ liệu từ form
  Map<String, dynamic> processFormData({
    required String importDateText,
    required String quantityText,
    required String valueText,
    PhongBan? selectedPhongBan,
    CcdcGroup? selectedGroupCCDC,
  }) {
    // Parse ngày nhập
    DateTime importDate = DateTime.now();
    try {
      if (importDateText.trim().isNotEmpty) {
        importDate = DateFormat(
          'dd/MM/yyyy',
        ).parseStrict(importDateText.trim());
      }
    } catch (e) {
      SGLog.warning('processFormData', 'Invalid date format: $importDateText');
    }

    // Parse số lượng
    final sanitizedQuantity = quantityText.replaceAll(RegExp(r'[^0-9]'), '');
    final quantity = int.tryParse(sanitizedQuantity) ?? 0;
    SGLog.debug('processFormData', 'Parsed quantity: $quantity');
    // Parse giá trị
    final rawValue = valueText.trim();
    final sanitizedValue = rawValue.replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(sanitizedValue) ?? 0.0;

    // Lấy ID đơn vị
    final idDonVi = (selectedPhongBan?.id ?? '').trim();
    // Lấy ID nhóm CCDC
    final idGroupCCDC = (selectedGroupCCDC?.id ?? '').trim();

    return {
      'importDate': importDate,
      'quantity': quantity,
      'value': value,
      'idDonVi': idDonVi,
      'idGroupCCDC': idGroupCCDC,
    };
  }

  /// Tạo ToolsAndSuppliesRequest object
  ToolsAndSuppliesRequest buildToolsAndSuppliesRequest({
    required Map<String, dynamic> processedData,
    required String nameText,
    required String codeText,
    required String unitText,
    required String symbolText,
    required String noteText,
    ToolsAndSuppliesDto? existingData,
  }) {
    final currentUser = AccountHelper.instance.getUserInfo();
    final now = DateTime.now();

    return ToolsAndSuppliesRequest(
      id: existingData?.id ?? codeText.trim(),
      idDonVi: processedData['idDonVi'],
      idNhomCCDC: processedData['idGroupCCDC'],
      ten: nameText.trim(),
      ngayNhap: processedData['importDate'],
      donViTinh: unitText.trim(),
      soLuong: processedData['quantity'],
      giaTri: processedData['value'],
      soKyHieu: '',
      kyHieu: symbolText.trim(),
      congSuat: '',
      nuocSanXuat: '',
      namSanXuat: 0,
      ghiChu: noteText.trim(),
      idCongTy: existingData?.idCongTy ?? currentUser?.idCongTy ?? "CT001",
      ngayTao: existingData?.ngayTao ?? now,
      ngayCapNhat: now,
      nguoiTao: existingData?.nguoiTao ?? currentUser?.id ?? '',
      nguoiCapNhat: currentUser?.id ?? '',
      isActive: existingData?.isActive ?? true,
    );
  }

  /// Validate form và trả về kết quả
  FormValidationResult validateForm({
    required String nameText,
    required String codeText,
    required String importDateText,
    required String unitText,
    required String quantityText,
    required String valueText,
    PhongBan? selectedPhongBan,
    required String importUnitText,
  }) {
    List<String> errors = [];

    final validationStates = FormValidationStates();

    // Validate tên công cụ dụng cụ
    validationStates.isNameValid = nameText.trim().isNotEmpty;
    if (!validationStates.isNameValid) {
      errors.add('Tên công cụ dụng cụ không được để trống');
    }

    // Validate đơn vị nhập
    final String idDonVi = (selectedPhongBan?.id ?? importUnitText).trim();
    validationStates.isImportUnitValid = idDonVi.isNotEmpty;
    if (!validationStates.isImportUnitValid) {
      errors.add('Đơn vị nhập không được để trống');
    }

    // Validate nhóm CCDC
    final String idGroupCCDC = (selectedPhongBan?.id ?? importUnitText).trim();
    validationStates.isGroupCCDCValid = idGroupCCDC.isNotEmpty;
    if (!validationStates.isGroupCCDCValid) {
      errors.add('Nhóm CCDC không được để trống');
    }

    // Validate mã công cụ dụng cụ
    final String code = codeText.trim();
    validationStates.isCodeValid = code.isNotEmpty && !code.contains(' ');
    if (code.isEmpty) {
      errors.add('Mã công cụ dụng cụ không được để trống');
    } else if (code.contains(' ')) {
      errors.add('Mã công cụ dụng cụ không được chứa khoảng trắng');
    }

    // Validate ngày nhập
    validationStates.isImportDateValid = _validateImportDate(importDateText);
    if (!validationStates.isImportDateValid) {
      errors.add('Ngày nhập không hợp lệ (định dạng: dd/MM/yyyy)');
    }

    // Validate đơn vị tính
    validationStates.isUnitValid = unitText.trim().isNotEmpty;
    if (!validationStates.isUnitValid) {
      errors.add('Đơn vị tính không được để trống');
    }

    // Validate số lượng
    validationStates.isQuantityValid = _validateQuantity(quantityText);
    if (!validationStates.isQuantityValid) {
      errors.add(
        'Số lượng phải là số nguyên dương và lớn hơn 0 (tối đa 999,999)',
      );
    }

    // Validate giá trị
    validationStates.isValueValid = _validateValue(valueText);
    if (!validationStates.isValueValid) {
      errors.add(
        'Giá trị phải là số nguyên dương và lớn hơn 0 (tối đa 999,999,999,999)',
      );
    }

    return FormValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      validationStates: validationStates,
    );
  }

  /// Validate ngày nhập
  bool _validateImportDate(String dateText) {
    if (dateText.trim().isEmpty) {
      return false;
    }

    final formats = [
      DateFormat('dd/MM/yyyy'),
      DateFormat('dd/MM/yyyy HH:mm:ss'),
    ];

    for (var format in formats) {
      try {
        final date = format.parseStrict(dateText.trim());
        // Kiểm tra ngày không được trong tương lai quá xa
        if (date.isAfter(DateTime.now().add(Duration(days: 365)))) {
          return false;
        }
        // Kiểm tra ngày không được quá cũ
        if (date.isBefore(DateTime(1900))) {
          return false;
        }
        return true;
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  /// Validate số lượng
  bool _validateQuantity(String quantityText) {
    if (quantityText.trim().isEmpty) {
      return false;
    }

    final sanitized = quantityText.replaceAll(RegExp(r'[^0-9]'), '');
    final quantity = int.tryParse(sanitized);
    return quantity != null && quantity > 0 && quantity <= 999999;
  }

  /// Validate giá trị
  bool _validateValue(String valueText) {
    final trimmed = valueText.trim();
    if (trimmed.isEmpty || trimmed.replaceAll('.', '').isEmpty) {
      return false;
    }

    final sanitized = trimmed.replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(sanitized);
    return value != null && value >= 0 && value <= 999999999999;
  }

  /// Khởi tạo dropdown items cho phòng ban
  List<DropdownMenuItem<PhongBan>> buildPhongBanDropdownItems(
    List<PhongBan>? dataPhongBan,
  ) {
    if (dataPhongBan != null && dataPhongBan.isNotEmpty) {
      return [
        for (var element in dataPhongBan)
          DropdownMenuItem<PhongBan>(
            value: element,
            child: Text(element.tenPhongBan ?? ''),
          ),
      ];
    }
    return [];
  }

  /// Khởi tạo dropdown items cho phòng ban
  List<DropdownMenuItem<CcdcGroup>> buildGroupCcdcDropdownItems(
    List<CcdcGroup>? dataGroupCCDC,
  ) {
    if (dataGroupCCDC != null && dataGroupCCDC.isNotEmpty) {
      return [
        for (var element in dataGroupCCDC)
          DropdownMenuItem<CcdcGroup>(
            value: element,
            child: Text(element.ten ?? ''),
          ),
      ];
    }
    return [];
  }

  /// Format dữ liệu hiển thị
  String formatDisplayValue(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// Format ngày hiển thị
  String formatDateDisplay(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Kiểm tra dữ liệu có thay đổi không
  bool hasDataChanged({
    required ToolsAndSuppliesDto? originalData,
    required String nameText,
    required String codeText,
    required String importDateText,
    required String unitText,
    required String quantityText,
    required String valueText,
    required String symbolText,
    required String noteText,
    required List<DetailAssetDto> detailAssets,
  }) {
    if (originalData == null) return true; // Dữ liệu mới

    // So sánh các trường cơ bản
    if (originalData.ten != nameText.trim() ||
        originalData.id != codeText.trim() ||
        originalData.donViTinh != unitText.trim() ||
        originalData.kyHieu != symbolText.trim() ||
        originalData.ghiChu != noteText.trim()) {
      return true;
    }

    // So sánh số lượng
    final quantity =
        int.tryParse(quantityText.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (originalData.soLuong != quantity) {
      return true;
    }

    // So sánh giá trị
    final value =
        double.tryParse(
          valueText.trim().replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0.0;
    if (originalData.giaTri != value) {
      return true;
    }

    // So sánh ngày nhập
    try {
      final inputDate = DateFormat(
        'dd/MM/yyyy',
      ).parseStrict(importDateText.trim());
      if (originalData.ngayNhap.day != inputDate.day ||
          originalData.ngayNhap.month != inputDate.month ||
          originalData.ngayNhap.year != inputDate.year) {
        return true;
      }
    } catch (_) {
      return true; // Lỗi parse => có thay đổi
    }

    // So sánh chi tiết tài sản
    final originalDetails = originalData.chiTietTaiSanList;
    if (originalDetails.length != detailAssets.length) {
      return true;
    }

    for (int i = 0; i < originalDetails.length; i++) {
      final original = originalDetails[i];
      final current = detailAssets[i];

      if (original.soKyHieu != current.soKyHieu ||
          original.congSuat != current.congSuat ||
          original.nuocSanXuat != current.nuocSanXuat ||
          original.namSanXuat != current.namSanXuat) {
        return true;
      }
    }

    return false;
  }

  /// Tạo một DetailAssetDto với default values an toàn
  DetailAssetDto createSafeDetailAsset({
    String? id,
    String? idTaiSan,
    String? ngayVaoSo,
    String? ngaySuDung,
    String? soKyHieu,
    String? congSuat,
    int? soLuong,
    String? nuocSanXuat,
    int? namSanXuat,
  }) {
    return DetailAssetDto(
      id: id ?? '',
      idTaiSan: idTaiSan ?? '',
      ngayVaoSo: ngayVaoSo,
      ngaySuDung: ngaySuDung,
      soKyHieu: soKyHieu ?? '',
      congSuat: congSuat ?? '',
      soLuong: soLuong ?? 0,
      nuocSanXuat: nuocSanXuat ?? '',
      namSanXuat: namSanXuat ?? 0,
    );
  }

  /// Copy DetailAssetDto với null safety
  List<DetailAssetDto> safeCopyDetailAssets(List<DetailAssetDto> source) {
    return source
        .map(
          (e) => createSafeDetailAsset(
            id: e.id,
            idTaiSan: e.idTaiSan,
            ngayVaoSo: e.ngayVaoSo,
            ngaySuDung: e.ngaySuDung,
            soKyHieu: e.soKyHieu,
            congSuat: e.congSuat,
            soLuong: e.soLuong,
            nuocSanXuat: e.nuocSanXuat,
            namSanXuat: e.namSanXuat,
          ),
        )
        .toList();
  }
}

/// Kết quả validation form
class FormValidationResult {
  final bool isValid;
  final List<String> errors;
  final FormValidationStates validationStates;

  FormValidationResult({
    required this.isValid,
    required this.errors,
    required this.validationStates,
  });
}

/// States của validation cho từng field
class FormValidationStates {
  bool isNameValid = true;
  bool isImportUnitValid = true;
  bool isGroupCCDCValid = true;
  bool isCodeValid = true;
  bool isImportDateValid = true;
  bool isUnitValid = true;
  bool isQuantityValid = true;
  bool isValueValid = true;

  /// Reset tất cả về true
  void resetAll() {
    isNameValid = true;
    isImportUnitValid = true;
    isGroupCCDCValid = true;
    isCodeValid = true;
    isImportDateValid = true;
    isUnitValid = true;
    isQuantityValid = true;
    isValueValid = true;
  }
}
