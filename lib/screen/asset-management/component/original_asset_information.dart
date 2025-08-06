// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/model/asset_management_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget originalAssetInfomation(
  AssetManagementDto item,
  // List
  Map<String, TextEditingController> controllers,
  Map<String, bool> validationErrors,
  bool isEditing,
) {
  return Column(
    children: [
      SGText(text: 'Thông tin tài sản gôc', size: 14),
      Divider(color: ColorValue.darkGrey.withOpacity(0.6)),
      SizedBox(height: 8),

      CommonFormInput(
        label: 'Mã tài sản',
        controller: controllers['id']!,
        isEditing: isEditing,
        textContent: '',
        fieldName: 'id',
        validationErrors: validationErrors,
      ),
      CommonFormInput(
        label: 'Nguyên giá tài sản',
        controller: controllers['nguyenGia']!,
        isEditing: isEditing,
        textContent: '',
        fieldName: 'nguyenGia',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),
      CommonFormInput(
        label: 'Giá trị Khấu hao ban đầu',
        controller: controllers['giaTriKhauHaoBanDau']!,
        isEditing: isEditing,
        textContent: '',
        fieldName: 'giaTriKhauHaoBanDau',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),
      CommonFormInput(
        label: 'Kỳ khấu hao ban đầu',
        controller: controllers['kyKhauHaoBanDau']!,
        isEditing: isEditing,
        textContent: '',
        fieldName: 'kyKhauHaoBanDau',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),
      CommonFormInput(
        label: 'Giá trị thanh lý',
        controller: controllers['kyKhauHaoBanDau']!,
        isEditing: isEditing,
        textContent: '',
        fieldName: 'kyKhauHaoBanDau',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),
      CommonFormInput(
        label: 'Mô hình tài sản',
        controller: controllers['tenMoHinh']!,
        isEditing: isEditing,
        textContent: '',
        fieldName: 'tenMoHinh',
        validationErrors: validationErrors,
      ),
    ],
  );
}
