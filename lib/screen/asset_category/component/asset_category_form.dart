import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';

Widget buildAssetCategoryForm({
  required BuildContext context,
  required bool isEditing,
  required AssetCategoryDto? data,
  required TextEditingController ctrlIdMohinh,
  required TextEditingController ctrlTenMoHinh,
  required TextEditingController ctrlPhuongPhapKhauHao,
  required TextEditingController ctrlKyKhauHao,
  required TextEditingController ctrlLoaiKyKhauHao,
  required TextEditingController ctrlTaiKhoanTaiSan,
  required TextEditingController ctrlTaiKhoanKhauHao,
  required TextEditingController ctrlTaiKhoanChiPhi,
  required Function(String)? onChangedPhuongPhapKhauHaos,
  required Function(String)? onChangedLoaiKyKhauHaos,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      spacing: 30,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonFormInput(
                label: 'Mã mô hình tài sản',
                controller: ctrlIdMohinh,
                isEditing: isEditing,
                textContent: ctrlIdMohinh.text,
                onChanged: (value) {
                  // _checkForChanges();
                },
              ),
              CommonFormInput(
                label: 'Tên mô hình tài sản',
                controller: ctrlTenMoHinh,
                isEditing: isEditing,
                textContent: ctrlTenMoHinh.text,
                onChanged: (value) {
                  // _checkForChanges();
                },
              ),
              CmFormDropdownObject<String>(
                label: 'Phương pháp khấu hao',
                controller: ctrlPhuongPhapKhauHao,
                isEditing: isEditing,
                items: AppUtility.phuongPhapKhauHaos,
                defaultValue:
                    ctrlPhuongPhapKhauHao.text.isNotEmpty
                        ? ctrlPhuongPhapKhauHao.text == '1'
                            ? 'Đường thảng'
                            : ''
                        : null,
                onChanged: onChangedPhuongPhapKhauHaos,
                fieldName: 'phuongPhapKhauHao',
              ),

              CommonFormInput(
                label: 'Kỳ khấu hao',
                controller: ctrlKyKhauHao,
                isEditing: isEditing,
                textContent: ctrlKyKhauHao.text,
                inputType: TextInputType.number,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CmFormDropdownObject<String>(
                label: 'Loại kỳ khấu hao',
                controller: ctrlLoaiKyKhauHao,
                isEditing: isEditing,
                items: AppUtility.loaiKyKhauHaos,
                defaultValue:
                    ctrlLoaiKyKhauHao.text.isNotEmpty
                        ? ctrlLoaiKyKhauHao.text == '1'
                            ? 'Tháng'
                            : ctrlLoaiKyKhauHao.text == '2'
                                ? 'Năm'
                            : ''
                        : null,
                onChanged: onChangedLoaiKyKhauHaos,
                fieldName: 'loaiKyKhauHao',
              ),
              
              CommonFormInput(
                label: 'Tài khoản tài sản',
                controller: ctrlTaiKhoanTaiSan,
                isEditing: isEditing,
                textContent: ctrlTaiKhoanTaiSan.text,
                inputType: TextInputType.number,
              ),
              CommonFormInput(
                label: 'Tài khoản khấu hao',
                controller: ctrlTaiKhoanKhauHao,
                isEditing: isEditing,
                textContent: ctrlTaiKhoanKhauHao.text,
                inputType: TextInputType.number,
              ),
              CommonFormInput(
                label: 'Tài khoản chi phí',
                controller: ctrlTaiKhoanChiPhi,
                isEditing: isEditing,
                textContent: ctrlTaiKhoanChiPhi.text,
                inputType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
