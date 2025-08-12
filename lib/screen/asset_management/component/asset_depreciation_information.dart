// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';

Widget buildDepreciationInformation(
  BuildContext context, {
  required TextEditingController ctrlButToanKhauHao,
  required TextEditingController ctrlTaiSan,
  required TextEditingController ctrlTaiSanKhauHao,
  required TextEditingController ctrlTaiSanChiPhi,
  required TextEditingController ctrlGiaTriKhauHao,
  required TextEditingController ctrlKyKhauHao,
  required TextEditingController ctrlTrangThaiButToan,
  Map<String, bool>? validationErrors,
  required AssetManagementProvider provider,
}) {
  return Column(
    children: [
      CommonFormInput(
        label: 'Bút toán khấu hao',
        controller: ctrlButToanKhauHao,
        isEditing: false,
        textContent: ctrlButToanKhauHao.text,
        fieldName: 'butToanKhauHao',
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Tài sản',
        controller: ctrlTaiSan,
        isEditing: false,
        textContent: ctrlTaiSan.text,
        fieldName: 'taiSan',
        // inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Tài sản khấu hao',
        controller: ctrlTaiSanKhauHao,
        isEditing: false,
        textContent: ctrlTaiSanKhauHao.text,
        fieldName: 'taiSanKhauHao',
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Tài sản chi phí',
        controller: ctrlTaiSanChiPhi,
        isEditing: false,
        textContent: ctrlTaiSanChiPhi.text,
        fieldName: 'taiSanChiPhi',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Giá trị khấu hao',
        controller: ctrlGiaTriKhauHao,
        isEditing: false,
        textContent: ctrlGiaTriKhauHao.text,
        fieldName: 'giaTriKhauHao',
        inputType: TextInputType.number,
        isMoney: true,
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Kỳ khấu hao',
        controller: ctrlKyKhauHao,
        isEditing: false,
        textContent: ctrlKyKhauHao.text,
        fieldName: 'donViTinh',
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Trạng thái bút toán',
        controller: ctrlTrangThaiButToan,
        isEditing: false,
        textContent: ctrlTrangThaiButToan.text,
        fieldName: 'ghiChu',
        validationErrors: validationErrors,
      ),
    ],
  );
}