import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';

class AssetTransferValidation {
  final Map<String, bool> _validationErrors = {};

  Map<String, bool> get validationErrors => _validationErrors;

  bool validateForm({
    required TextEditingController soChungTuController,
    required TextEditingController documentNameController,
    required TextEditingController subjectController,
    required TextEditingController deliveringUnitController,
    required TextEditingController receivingUnitController,
    required TextEditingController effectiveDateController,
    required TextEditingController effectiveDateToController,
    required TextEditingController requesterController,
    required TextEditingController approverController,
    required TextEditingController controllerDepartmentApproval,
    required NhanVien? nguoiKyNhay,
    required NhanVien? nguoiDeNghi,
    required NhanVien? nguoiDaiDienBanHanhQD,
    required DieuDongTaiSanDto? item,
    required String? selectedFileName,
  }) {
    Map<String, bool> newValidationErrors = {};

    if (soChungTuController.text.isEmpty) {
      newValidationErrors['soChungTu'] = true;
    }

    if (documentNameController.text.isEmpty) {
      newValidationErrors['documentName'] = true;
    }

    if (subjectController.text.isEmpty) {
      newValidationErrors['subject'] = true;
    }

    if (deliveringUnitController.text.isEmpty) {
      newValidationErrors['deliveringUnit'] = true;
    }

    if (receivingUnitController.text.isEmpty) {
      newValidationErrors['receivingUnit'] = true;
    }

    if (effectiveDateController.text.isEmpty) {
      newValidationErrors['effectiveDate'] = true;
    }

    if (effectiveDateToController.text.isEmpty) {
      newValidationErrors['effectiveDateTo'] = true;
    }

    if (nguoiKyNhay == null || requesterController.text.isEmpty) {
      newValidationErrors['requester'] = true;
    }

    if (nguoiDeNghi == null || controllerDepartmentApproval.text.isEmpty) {
      newValidationErrors['departmentApproval'] = true;
    }

    if (nguoiDaiDienBanHanhQD == null || approverController.text.isEmpty) {
      newValidationErrors['approver'] = true;
    }
    // If it's a new item, document is required
    if (item == null && selectedFileName == null) {
      newValidationErrors['document'] = true;
    }

    // Only update state if validation errors have changed
    bool hasChanges = !mapEquals(_validationErrors, newValidationErrors);
    if (hasChanges) {
      _validationErrors.clear();
      _validationErrors.addAll(newValidationErrors);
    }

    return newValidationErrors.isEmpty;
  }

  void clearValidationErrors() {
    _validationErrors.clear();
  }

  void removeValidationError(String fieldName) {
    _validationErrors.remove(fieldName);
  }

  bool hasValidationError(String fieldName) {
    return _validationErrors.containsKey(fieldName);
  }
}
