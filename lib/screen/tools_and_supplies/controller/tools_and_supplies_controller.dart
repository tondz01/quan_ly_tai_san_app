import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

/// Controller xử lý logic nghiệp vụ cho Tools and Supplies Detail
class ToolsAndSuppliesController {
  // Callback để update UI
  final VoidCallback? onStateChanged;

  ToolsAndSuppliesController({
    this.onStateChanged,
  });

  /// Kiểm tra những item nào đã bị xóa so với danh sách cũ
  /// Trả về danh sách các item đã bị xóa
  List<DetailAssetDto> getDeletedItems({
    required List<DetailAssetDto> oldList,
    required List<DetailAssetDto> newList,
  }) {
    List<DetailAssetDto> deletedItems = [];

    // Tạo set chứa tất cả ID từ danh sách mới để tìm kiếm nhanh
    final Set<String> newListIds =
        newList
            .where((item) => item.id?.isNotEmpty == true)
            .map((item) => item.id!)
            .toSet();

    // Kiểm tra từng item trong danh sách cũ
    for (var oldItem in oldList) {
      final oldItemId = oldItem.id;

      // Nếu item cũ có ID và ID này không có trong danh sách mới
      if (oldItemId?.isNotEmpty == true && !newListIds.contains(oldItemId)) {
        deletedItems.add(oldItem);
        SGLog.debug(
          'getDeletedItems',
          'Phát hiện item đã xóa: ID=${oldItem.id}, Ký hiệu=${oldItem.soKyHieu}',
        );
      }
    }

    SGLog.info(
      'getDeletedItems',
      'Tìm thấy ${deletedItems.length} item(s) đã bị xóa',
    );

    return deletedItems;
  }

  /// Xử lý và chuẩn hóa dữ liệu từ form
  Map<String, dynamic> processFormData({
    required String importDateText,
    required String quantityText,
    required String valueText,
    PhongBan? selectedPhongBan,
    CcdcGroup? selectedGroupCCDC,
    TypeCcdc? selectedTypeCCDC,
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
    // Lấy ID loại CCDC
    final idTypeCCDC = (selectedTypeCCDC?.id ?? '').trim();
    return {
      'importDate': importDate,
      'quantity': quantity,
      'value': value,
      'idDonVi': idDonVi,
      'idGroupCCDC': idGroupCCDC,
      'idTypeCCDC': idTypeCCDC,
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
      idLoaiCCDCCon: processedData['idTypeCCDC'],
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
      ngayTao: existingData?.ngayTao  ?? now,
      ngayCapNhat: now,
      nguoiTao: existingData?.nguoiTao ?? currentUser?.id ?? '',
      nguoiCapNhat: currentUser?.id ?? '',
      isActive: existingData?.isActive ?? true,
    );
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

  /// Khởi tạo dropdown items cho loại CCDC
  List<DropdownMenuItem<TypeCcdc>> buildTypeCcdcDropdownItems(
    List<TypeCcdc>? dataTypeCCDC,
  ) {
    if (dataTypeCCDC != null && dataTypeCCDC.isNotEmpty) {
      return [
        for (var element in dataTypeCCDC)
          DropdownMenuItem<TypeCcdc>(
            value: element,
            child: Text(element.tenLoai ?? ''),
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

  /// Xử lý và cập nhật ID cho DetailAssetDto
  /// Giữ nguyên ID cũ nếu có, tạo mới nếu chưa có
  void updateDetailAssetIds(
    List<DetailAssetDto> currentDetails,
    List<DetailAssetDto> originalDetails,
    String assetCode,
  ) {
    for (int i = 0; i < currentDetails.length; i++) {
      final currentDetail = currentDetails[i];

      // Nếu có dữ liệu gốc và index còn trong phạm vi
      if (originalDetails.isNotEmpty && i < originalDetails.length) {
        final originalDetail = originalDetails[i];

        // Giữ nguyên ID từ dữ liệu gốc nếu có
        if (originalDetail.id?.isNotEmpty == true) {
          currentDetail.id = originalDetail.id;
        } else {
          currentDetail.id = _generateDetailAssetId(assetCode, i);
        }
      } else {
        // Item mới thêm - tạo ID mới
        currentDetail.id = _generateDetailAssetId(assetCode, i);
      }

      // Luôn cập nhật idTaiSan
      currentDetail.idTaiSan = assetCode.trim();
    }
  }

  /// Tạo ID mới cho DetailAssetDto
  String _generateDetailAssetId(String assetCode, int index) {
    return "${assetCode.trim()}-${DateTime.now().millisecondsSinceEpoch}-$index";
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
  bool isTypeCCDCValid = true;
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
    isTypeCCDCValid = true;
    isCodeValid = true;
    isImportDateValid = true;
    isUnitValid = true;
    isQuantityValid = true;
    isValueValid = true;
  }
}
