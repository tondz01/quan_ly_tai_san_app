import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class AssetHandoverFormControllers {
  final TextEditingController handoverNumber = TextEditingController();
  final TextEditingController documentName = TextEditingController();
  final TextEditingController order = TextEditingController();
  final TextEditingController senderUnit = TextEditingController();
  final TextEditingController receiverUnit = TextEditingController();
  final TextEditingController transferDate = TextEditingController();
  final TextEditingController decisionDate = TextEditingController();
  final TextEditingController decisionNumber = TextEditingController();
  final TextEditingController decisionLocation = TextEditingController();
  final TextEditingController documentCreationDate = TextEditingController();
  final TextEditingController delivererRepresentative = TextEditingController();
  final TextEditingController receiverRepresentative = TextEditingController();
  final TextEditingController giamDocKy = TextEditingController();

  DateTime? ngayBanGiao;
  DateTime? ngayTaoChungTu;
  DateTime? ngayQuyetDinh;

  void setDates({
    DateTime? ngayBanGiao,
    DateTime? ngayTaoChungTu,
    DateTime? ngayQuyetDinh,
  }) {
    this.ngayBanGiao = ngayBanGiao;
    this.ngayTaoChungTu = ngayTaoChungTu;
    this.ngayQuyetDinh = ngayQuyetDinh;
  }

  void setDate(String type, DateTime? date) {
    switch (type) {
      case 'ngayBanGiao':
        ngayBanGiao = date;
        if (date != null) {
          transferDate.text = AppUtility.formatDateString(date);
        }
        break;
      case 'ngayTaoChungTu':
        ngayTaoChungTu = date;
        if (date != null) {
          documentCreationDate.text = AppUtility.formatDateString(date);
        }
        break;
      case 'ngayQuyetDinh':
        ngayQuyetDinh = date;
        if (date != null) {
          decisionDate.text = AppUtility.formatDateString(date);
        }
        break;
    }
  }

  void dispose() {
    handoverNumber.dispose();
    documentName.dispose();
    order.dispose();
    senderUnit.dispose();
    receiverUnit.dispose();
    transferDate.dispose();
    decisionDate.dispose();
    decisionNumber.dispose();
    decisionLocation.dispose();
    documentCreationDate.dispose();
    delivererRepresentative.dispose();
    receiverRepresentative.dispose();
    giamDocKy.dispose();
  }
}

