// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget buildOriginalAssetInfomation(
  BuildContext context, {
  required TextEditingController ctrlMaTaiSan,
  required TextEditingController ctrlIdNhomTaiSan,
  required TextEditingController ctrlNguyenGia,
  required TextEditingController ctrlGiaTriKhauHaoBanDau,
  required TextEditingController ctrlKyKhauHaoBanDau,
  required TextEditingController ctrlGiaTriThanhLy,
  required TextEditingController ctrlTenMoHinh,
  required TextEditingController ctrlPhuongPhapKhauHao,
  required TextEditingController ctrlSoKyKhauHao,
  required TextEditingController ctrlTaiKhoanTaiSan,
  required TextEditingController ctrlTaiKhoanKhauHao,
  required TextEditingController ctrlTaiKhoanChiPhi,
  required TextEditingController ctrlTenNhom,
  required TextEditingController ctrlNgayVaoSo,
  required TextEditingController ctrlNgaySuDung,
  Map<String, bool>? validationErrors,
  bool isEditing = false,
  Function(String)? onDepreciationMethodChanged,
  Function(AssetCategoryDto)? onAssetCategoryChanged,
  Function(AssetGroupDto)? onAssetGroupChanged,
  required List<AssetCategoryDto> listAssetCategory,
  required List<AssetGroupDto> listAssetGroup, 
  required List<DropdownMenuItem<AssetCategoryDto>> itemsAssetCategory,
  required List<DropdownMenuItem<AssetGroupDto>> itemsAssetGroup,
  required Function(DateTime?)? onChangedNgayVaoSo,
  required Function(DateTime?)? onChangedNgaySuDung,
}) {
  if (listAssetCategory.isEmpty) {
    try {
      final assetHandoverBloc = BlocProvider.of<AssetCategoryBloc>(context);
      assetHandoverBloc.add(GetListAssetCategoryEvent(context, 'ct001'));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lấy danh sách: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  return MultiBlocListener(
    listeners: [
      // Lắng nghe từ AssetCategoryBloc
      BlocListener<AssetCategoryBloc, AssetCategoryState>(
        listener: (context, state) {
          if (state is GetListAssetCategorySuccessState) {
            // Handle successful data loading
            Future.microtask(() {
              listAssetCategory.clear();
              listAssetCategory.addAll(state.data);
              itemsAssetCategory.clear();
              itemsAssetCategory.addAll([
                for (var element in listAssetCategory)
                  DropdownMenuItem<AssetCategoryDto>(
                    value: element,
                    child: Text(element.tenMoHinh ?? ''),
                  ),
              ]);
            });
          } else if (state is GetListAssetCategoryFailedState) {
            log('message GetListAssetCategoryFailedState');
          } else if (state is AssetCategoryLoadingState) {
            // Show loading indicator
            log('message AssetCategoryLoadingState');
          } else if (state is AssetCategoryLoadingDismissState) {
            // Hide loading indicator
            log('message AssetCategoryLoadingDismissState');
          }
        },
      ),
    ],
    child: Column(
      children: [
        SGText(
          text: 'Thông tin tài sản gôc',
          size: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        Divider(color: ColorValue.darkGrey.withOpacity(0.6)),
        SizedBox(height: 8),

        CommonFormInput(
          label: 'Mã tài sản',
          controller: ctrlMaTaiSan,
          isEditing: isEditing,
          textContent: ctrlMaTaiSan.text,
          fieldName: 'id',
          validationErrors: validationErrors,
          isRequired: true,
        ),
        CommonFormInput(
          label: 'Nguyên giá tài sản',
          controller: ctrlNguyenGia,
          isEditing: isEditing,
          textContent: ctrlNguyenGia.text,
          fieldName: 'nguyenGia',
          inputType: TextInputType.number,
          isMoney: true,
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'Giá trị Khấu hao ban đầu',
          controller: ctrlGiaTriKhauHaoBanDau,
          isEditing: isEditing,
          textContent: ctrlGiaTriKhauHaoBanDau.text,
          fieldName: 'giaTriKhauHaoBanDau',
          inputType: TextInputType.number,
          isMoney: true,
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'Kỳ khấu hao ban đầu',
          controller: ctrlKyKhauHaoBanDau,
          isEditing: isEditing,
          textContent: ctrlKyKhauHaoBanDau.text,
          fieldName: 'kyKhauHaoBanDau',
          inputType: TextInputType.number,
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'Giá trị thanh lý',
          controller: ctrlGiaTriThanhLy,
          isEditing: isEditing,
          textContent: ctrlGiaTriThanhLy.text,
          fieldName: 'kyKhauHaoBanDau',
          inputType: TextInputType.number,
          isMoney: true,
          validationErrors: validationErrors,
        ),

        CmFormDropdownObject<AssetCategoryDto>(
          label: 'Mô hình tài sản',
          controller: ctrlTenMoHinh,
          isEditing: isEditing,
          fieldName: 'idMoHinhTaiSan',
          items: itemsAssetCategory,
          defaultValue:
              ctrlTenMoHinh.text.isNotEmpty
                  ? getAssetCategory(
                    listAssetCatergory: listAssetCategory,
                    idAssetCategory: ctrlTenMoHinh.text,
                  )
                  : null,
          onChanged: onAssetCategoryChanged,
          isRequired: true,
        ),

        CommonFormInput(
          label: 'Phương pháp khấu hao',
          controller: ctrlPhuongPhapKhauHao,
          isEditing: false,
          textContent: ctrlPhuongPhapKhauHao.text,
          fieldName: 'tenMoHinh',
          isDropdown: true,
          items: AppUtility.phuongPhapKhauHaos,
          onChanged: onDepreciationMethodChanged,
          validationErrors: validationErrors,
        ),

        CommonFormInput(
          label: 'Số Kỳ khấu hao',
          controller: ctrlSoKyKhauHao,
          isEditing: false,
          textContent: ctrlSoKyKhauHao.text,
          fieldName: 'soKyKhauHao',
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'Tài khoản tài sản',
          controller: ctrlTaiKhoanTaiSan,
          isEditing: false,
          textContent: ctrlTaiKhoanTaiSan.text,
          fieldName: 'taiKhoanTaiSan',
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'Tài khoản khấu hao',
          controller: ctrlTaiKhoanKhauHao,
          isEditing: false,
          textContent: ctrlTaiKhoanKhauHao.text,
          fieldName: 'taiKhoanKhauHao',
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'Tài khoản chi phí',
          controller: ctrlTaiKhoanChiPhi,
          isEditing: false,
          textContent: ctrlTaiKhoanChiPhi.text,
          fieldName: 'taiKhoanChiPhi',
          validationErrors: validationErrors,
        ),
        CmFormDropdownObject<AssetGroupDto>(
          label: 'Nhóm tài sản',
          controller: ctrlIdNhomTaiSan,
          isEditing: isEditing,
          items: itemsAssetGroup,
          defaultValue:
              ctrlIdNhomTaiSan.text.isNotEmpty
                  ? getAssetGroup(
                    listAssetGroup: listAssetGroup,
                    idAssetGroup: ctrlIdNhomTaiSan.text,
                  )
                  : null,
          onChanged: onAssetGroupChanged,
          fieldName: 'idNhomTaiSan',
          validationErrors: validationErrors,
          isRequired: true,
        ),
        CmFormDate(
          label: 'Ngày vào sổ',
          controller: ctrlNgayVaoSo,
          isEditing: isEditing,
          enable: !isEditing,
          onChanged: onChangedNgayVaoSo,
          value:
              ctrlNgayVaoSo.text.isNotEmpty
                  ? AppUtility.parseFlexibleDateTime(ctrlNgayVaoSo.text)
                  : DateTime.now(),
        ),
        CmFormDate(
          label: 'Ngày sử dụng',
          controller: ctrlNgaySuDung,
          isEditing: isEditing,
          enable: !isEditing,
          onChanged: onChangedNgaySuDung,
          value:
              ctrlNgaySuDung.text.isNotEmpty
                  ? AppUtility.parseFlexibleDateTime(ctrlNgaySuDung.text)
                  : DateTime.now(),
        ),
      ],
    ),
  );
}

AssetCategoryDto getAssetCategory({
  required List<AssetCategoryDto> listAssetCatergory,
  required String idAssetCategory,
}) {
  final found = listAssetCatergory.where((item) => item.id == idAssetCategory);
  if (found.isEmpty) {
    // Trả về một AssetCategoryDto mặc định nếu không tìm thấy
    return AssetCategoryDto();
  }
  return found.first;
}

AssetGroupDto getAssetGroup({
  required List<AssetGroupDto> listAssetGroup,
  required String idAssetGroup,
}) {
  final found = listAssetGroup.where((item) => item.id == idAssetGroup);
  if (found.isEmpty) {
    // Trả về một AssetGroupDto mặc định nếu không tìm thấy
    return AssetGroupDto();
  }
  return found.first;
}
