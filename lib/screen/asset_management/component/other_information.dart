// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget buildOtherInformation(
  BuildContext context, {
  required TextEditingController ctrlDuAn,
  required TextEditingController ctrlNguonKinhPhi,
  required TextEditingController ctrlVonNS,
  required TextEditingController ctrlVonVay,
  required TextEditingController ctrlVonKhac,
  required TextEditingController ctrlKyHieu,
  required TextEditingController ctrlSoKyHieu,
  required TextEditingController ctrlCongSuat,
  required TextEditingController ctrlNuocSanXuat,
  required TextEditingController ctrlNamSanXuat,
  required TextEditingController ctrlLyDoTang,
  required TextEditingController ctrlHienTrang,
  required TextEditingController ctrlSoLuong,
  required TextEditingController ctrlDonViTinh,
  required TextEditingController ctrlGhiChu,
  required TextEditingController ctrlDonViBanDau,
  required TextEditingController ctrlDonViHienThoi,
  required bool valueKhoiTaoDonVi,
  Map<String, bool>? validationErrors,
  bool isEditing = false,
  Function(String)? onDepreciationMethodChanged,
  Function(PhongBan)? onChangeInitialUsage,
  Function(PhongBan)? onChangeCurrentUnit,
  Function(DuAn)? onDuAnChanged,
  Function(ReasonIncrease)? onLyDoTangChanged,
  Function(HienTrang)? onHienTrangChanged,
  Function(NguonKinhPhi)? onNguonKinhPhiChanged,
  Function(bool)? onKhoiTaoDonViChanged,
  Function(UnitDto)? onUnitChanged,
  required List<PhongBan> listPhongBan,
  required List<DuAn> listDuAn,
  required List<ReasonIncrease> listLyDoTang,
  required List<DropdownMenuItem<PhongBan>> itemsPhongBan,
  required List<DropdownMenuItem<DuAn>> itemsDuAn,
  required List<DropdownMenuItem<ReasonIncrease>> itemsLyDoTang,
  required List<DropdownMenuItem<UnitDto>> itemsUnit,
  required Function(Country)? onNuocSanXuatChanged,
  Function(double)? onTotalCapitalChanged,
  required AssetManagementProvider provider,
  DuAn? duAn,
  HienTrang? hienTrang,
  Country? country,
  PhongBan? phongBanBanDau,
  PhongBan? phongBanHienThoi,
  UnitDto? unit,
  ReasonIncrease? lyDoTang,
}) {
  // Function to calculate total capital
  void calculateTotalCapital() {
    // Clean text by removing all non-numeric characters except decimal point
    // Handle money format with thousand separators (dots)
    String cleanText(String text) {
      if (text.isEmpty) return '';

      String cleaned = text.replaceAll(RegExp(r'[^\d.]'), '');

      List<String> parts = cleaned.split('.');
      if (parts.length > 2) {
        // For numbers like "1.111.111", we need to treat dots as thousand separators
        // So "1.111.111" should become "1111111" (no decimal part)
        String integerPart = parts.join('');
        cleaned = integerPart;
      }
      return cleaned;
    }

    final vonNSText = cleanText(ctrlVonNS.text);
    final vonVayText = cleanText(ctrlVonVay.text);
    final vonKhacText = cleanText(ctrlVonKhac.text);

    final vonNS = double.tryParse(vonNSText) ?? 0.0;
    final vonVay = double.tryParse(vonVayText) ?? 0.0;
    final vonKhac = double.tryParse(vonKhacText) ?? 0.0;

    // Round to avoid floating point precision issues
    final total = (vonNS + vonVay + vonKhac).roundToDouble();
    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onTotalCapitalChanged?.call(total);
    });
  }

  return Column(
    children: [
      SGText(text: 'Thông tin khác', size: 16, fontWeight: FontWeight.w600),
      const SizedBox(height: 10),
      Divider(color: ColorValue.darkGrey.withOpacity(0.6)),
      SizedBox(height: 8),

      CmFormDropdownObject<DuAn>(
        label: 'Dự án',
        value: duAn,
        controller: ctrlDuAn,
        isEditing: isEditing,
        items: itemsDuAn,
        defaultValue:
            ctrlNguonKinhPhi.text.isNotEmpty
                ? getDuAn(
                  listAssetGroup: listDuAn,
                  idAssetGroup: ctrlNguonKinhPhi.text,
                )
                : null,
        onChanged: onDuAnChanged,
        fieldName: 'duAn',
        validationErrors: validationErrors,
      ),
      CommonFormInput(
        label: 'Vốn NS',
        controller: ctrlVonNS,
        isEditing: isEditing,
        textContent: ctrlVonNS.text,
        fieldName: 'vonNS',
        inputType: TextInputType.number,
        isMoney: true,
        validationErrors: validationErrors,
        onChanged: (value) {
          calculateTotalCapital();
        },
      ),
      CommonFormInput(
        label: 'Vốn vay',
        controller: ctrlVonVay,
        isEditing: isEditing,
        textContent: ctrlVonVay.text,
        fieldName: 'vonVay',
        inputType: TextInputType.number,
        isMoney: true,
        validationErrors: validationErrors,
        onChanged: (value) {
          calculateTotalCapital();
        },
      ),
      CommonFormInput(
        label: 'Vốn khác',
        controller: ctrlVonKhac,
        isEditing: isEditing,
        textContent: ctrlVonKhac.text,
        fieldName: 'vonKhac',
        inputType: TextInputType.number,
        isMoney: true,
        onChanged: (value) {
          log('message test [OtherInformation]: value: $value');
          calculateTotalCapital();
        },
        validationErrors: validationErrors,
      ),

      // CMObjectMultiSelectDropdownField<NguonKinhPhi>(
      //   labelText: 'Nguồn kinh phí',
      //   items: listNguonKinhPhi,
      //   readOnly: !isEditing,
      //   itemLabel: (o) => o.tenNguonKinhPhi ?? '',
      //   itemKey: (o) => o.id ?? '',
      //   initialSelected: initialSelectedNguonKinhPhi,
      //   onChanged: (list) {
      //     onChangedNguonKinhPhi?.call(list);
      //     initialSelectedNguonKinhPhi = list;
      //   },
      //   onConfirmed: (list) {
      //     onChangedNguonKinhPhi?.call(list);
      //     initialSelectedNguonKinhPhi = list;
      //   },
      // ),
      CommonFormInput(
        label: 'Ký hiệu',
        controller: ctrlKyHieu,
        isEditing: isEditing,
        textContent: ctrlKyHieu.text,
        fieldName: 'kyHieu',
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Số ký hiệu',
        controller: ctrlSoKyHieu,
        isEditing: isEditing,
        textContent: ctrlSoKyHieu.text,
        fieldName: 'soKyHieu',
        // inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Công suất',
        controller: ctrlCongSuat,
        isEditing: isEditing,
        textContent: ctrlCongSuat.text,
        fieldName: 'congSuat',
        validationErrors: validationErrors,
      ),

      CmFormDropdownObject<Country>(
        label: 'Nước sản xuất',
        value: country,
        controller: ctrlNuocSanXuat,
        isEditing: isEditing,
        items: provider.itemsCountry,
        fieldName: 'nuocSanXuat',
        defaultValue:
            ctrlNuocSanXuat.text.isNotEmpty
                ? provider.findCountryByName(ctrlNuocSanXuat.text)
                : null,
        onChanged: (value) {
          // ctrlNuocSanXuat.text = value.name;
          onNuocSanXuatChanged?.call(value);
        },
      ),

      CommonFormInput(
        label: 'Năm sản xuất',
        controller: ctrlNamSanXuat,
        isEditing: isEditing,
        textContent: ctrlNamSanXuat.text,
        fieldName: 'namSanXuat',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),

      CmFormDropdownObject<ReasonIncrease>(
        label: 'Lý do tăng',
        controller: ctrlLyDoTang,
        isEditing: isEditing,
        items: itemsLyDoTang,
        fieldName: 'lyDoTang',
        value: lyDoTang,
        onChanged: (value) {
          // ctrlLyDoTang.text = value.name;
          onLyDoTangChanged?.call(value);
        },
      ),

      CmFormDropdownObject<HienTrang>(
        label: 'Hiện trạng',
        controller: ctrlHienTrang,
        isEditing: isEditing,
        items: provider.itemsHienTrang,
        fieldName: 'hienTrang',
        value: hienTrang,
        onChanged: (value) {
          // ctrlHienTrang.text = value.name;
          onHienTrangChanged?.call(value);
        },
      ),
      const SizedBox(height: 10),
      CommonFormInput(
        label: 'Số lượng',
        controller: ctrlSoLuong,
        isEditing: false,
        textContent: ctrlSoLuong.text,
        fieldName: 'soLuong',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),
      const SizedBox(height: 5),
      CmFormDropdownObject<UnitDto>(
        label: 'tas.unit'.tr,
        controller: ctrlDonViTinh,
        isEditing: isEditing,
        items: itemsUnit,
       
        defaultValue: unit,
        onChanged: (value) {
          onUnitChanged?.call(value);
        },
        value: unit,
        fieldName: 'donViTinh',
        validationErrors: validationErrors,
        isRequired: true,
      ),

      CommonFormInput(
        label: 'Ghi chú',
        controller: ctrlGhiChu,
        isEditing: isEditing,
        textContent: ctrlGhiChu.text,
        fieldName: 'ghiChu',
        validationErrors: validationErrors,
      ),

      CommonCheckboxInput(
        label: 'Khởi tạo đơn vị',
        value: valueKhoiTaoDonVi,
        isEditing: isEditing,
        isDisabled: !isEditing,
        onChanged: onKhoiTaoDonViChanged,
      ),

      if (valueKhoiTaoDonVi)
        CmFormDropdownObject<PhongBan>(
          label: 'Đơn vị sử dụng ban đầu',
          controller: ctrlDonViBanDau,
          value: phongBanBanDau,
          isEditing: isEditing,
          items: itemsPhongBan,
          defaultValue:
              ctrlDonViBanDau.text.isNotEmpty
                  ? getPhongBan(
                    listPhongBan: listPhongBan,
                    idAssetGroup: ctrlDonViBanDau.text,
                  )
                  : null,
          onChanged: onChangeInitialUsage,
          fieldName: 'idDonViBanDau',
          validationErrors: validationErrors,
        ),

      CmFormDropdownObject<PhongBan>(
        label: 'Đơn vị hiện thời',
        controller: ctrlDonViHienThoi,
        value: phongBanHienThoi,
        isEditing: isEditing,
        items: itemsPhongBan,
        defaultValue:
            ctrlDonViHienThoi.text.isNotEmpty
                ? getPhongBan(
                  listPhongBan: listPhongBan,
                  idAssetGroup: ctrlDonViHienThoi.text,
                )
                : null,
        onChanged: onChangeCurrentUnit,
        fieldName: 'idDonViHienThoi',
        validationErrors: validationErrors,
        isRequired: true,
      ),
    ],
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

DuAn getDuAn({
  required List<DuAn> listAssetGroup,
  required String idAssetGroup,
}) {
  final found = listAssetGroup.where((item) => item.id == idAssetGroup);
  if (found.isEmpty) {
    // Trả về một AssetGroupDto mặc định nếu không tìm thấy
    return DuAn(
      id: '',
      tenDuAn: '',
      ghiChu: '',
      hieuLuc: false,
      idCongTy: '',
      nguoiTao: '',
      isActive: false,
    );
  }
  return found.first;
}

NguonKinhPhi getNguonKinhPhi({
  required List<NguonKinhPhi> listNguonKinhPhi,
  required String idAssetGroup,
}) {
  final found = listNguonKinhPhi.where((item) => item.id == idAssetGroup);
  if (found.isEmpty) {
    // Trả về một AssetGroupDto mặc định nếu không tìm thấy
    return NguonKinhPhi(
      id: '',
      tenNguonKinhPhi: '',
      ghiChu: '',
      hieuLuc: false,
      idCongTy: '',
      nguoiTao: '',
      isActive: false,
    );
  }
  return found.first;
}

PhongBan getPhongBan({
  required List<PhongBan> listPhongBan,
  required String idAssetGroup,
}) {
  final found = listPhongBan.where((item) => item.id == idAssetGroup);
  if (found.isEmpty) {
    // Trả về một AssetGroupDto mặc định nếu không tìm thấy
    return PhongBan(id: '', tenPhongBan: '', idCongTy: '', nguoiTao: '');
  }
  return found.first;
}
