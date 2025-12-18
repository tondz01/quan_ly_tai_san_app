import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_form_controllers.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';

class AssetHandoverFormValidator {
  final Map<String, bool> _errors = {};

  Map<String, bool> get errors => _errors;

  bool validate(
    AssetHandoverFormControllers controllers,
    NhanVien? nguoiKyGiamDoc,
    String? selectedFileName,
    String? selectedFilePath,
    void Function(VoidCallback) setState,
  ) {
    final newErrors = <String, bool>{};

    if (nguoiKyGiamDoc == null || controllers.giamDocKy.text.isEmpty) {
      newErrors['giamDocXacNhan'] = true;
    }
    if (controllers.documentName.text.isEmpty) {
      newErrors['documentName'] = true;
    }
    if (controllers.order.text.isEmpty) {
      newErrors['order'] = true;
    }
    if (controllers.senderUnit.text.isEmpty) {
      newErrors['senderUnit'] = true;
    }
    if (controllers.receiverUnit.text.isEmpty) {
      newErrors['receiverUnit'] = true;
    }
    if (controllers.transferDate.text.isEmpty) {
      newErrors['transferDate'] = true;
    }
    if (controllers.documentCreationDate.text.isEmpty) {
      newErrors['documentCreationDate'] = true;
    }
    if (controllers.decisionNumber.text.isEmpty) {
      newErrors['decisionNumber'] = true;
    }
    if (controllers.decisionLocation.text.isEmpty) {
      newErrors['decisionLocation'] = true;
    }
    if (controllers.decisionDate.text.isEmpty) {
      newErrors['decisionDate'] = true;
    }
    if (controllers.delivererRepresentative.text.isEmpty) {
      newErrors['delivererRepresentative'] = true;
    }
    if (controllers.receiverRepresentative.text.isEmpty) {
      newErrors['receiverRepresentative'] = true;
    }
    if ((selectedFileName ?? '').isEmpty ||
        (selectedFilePath ?? '').isEmpty) {
      newErrors['document'] = true;
    }

    final hasChanges = !mapEquals(_errors, newErrors);
    if (hasChanges) {
      setState(() {
        _errors.clear();
        _errors.addAll(newErrors);
      });
    }

    return newErrors.isEmpty;
  }

  void removeError(String field, void Function(VoidCallback) setState) {
    if (_errors.containsKey(field)) {
      setState(() {
        _errors.remove(field);
      });
    }
  }
}

