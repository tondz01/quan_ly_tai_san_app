// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget buildOtherInformation(
  BuildContext context, {
  required TextEditingController ctrlDuAn,
  required TextEditingController ctrlNguonKinhPhi,
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
  Function(LyDoTang)? onLyDoTangChanged,
  Function(HienTrang)? onHienTrangChanged,
  Function(NguonKinhPhi)? onNguonKinhPhiChanged,
  Function(bool)? onKhoiTaoDonViChanged,
  required List<PhongBan> listPhongBan,
  required List<DuAn> listDuAn,
  required List<NguonKinhPhi> listNguonKinhPhi,
  required List<DropdownMenuItem<PhongBan>> itemsPhongBan,
  required List<DropdownMenuItem<DuAn>> itemsDuAn,
  required List<DropdownMenuItem<NguonKinhPhi>> itemsNguonKinhPhi,
  required Function(Country)? onNuocSanXuatChanged,
  required AssetManagementProvider provider,
  DuAn? duAn,
  HienTrang? hienTrang,
  LyDoTang? lyDoTang,
  Country? country,
  PhongBan? phongBanBanDau,
  PhongBan? phongBanHienThoi,
}) {
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

      CmFormDropdownObject<NguonKinhPhi>(
        label: 'Nguồn kinh phí',
        controller: ctrlNguonKinhPhi,
        isEditing: isEditing,
        items: itemsNguonKinhPhi,
        defaultValue:
            ctrlNguonKinhPhi.text.isNotEmpty
                ? getNguonKinhPhi(
                  listNguonKinhPhi: listNguonKinhPhi,
                  idAssetGroup: ctrlNguonKinhPhi.text,
                )
                : null,
        onChanged: onNguonKinhPhiChanged,
        fieldName: 'nguonKinhPhi',
        validationErrors: validationErrors,
      ),

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

      CmFormDropdownObject<LyDoTang>(
        label: 'Lý do tăng',
        controller: ctrlLyDoTang,
        isEditing: isEditing,
        items: provider.itemsLyDoTang,
        fieldName: 'lyDoTang',
        defaultValue:
            ctrlLyDoTang.text.isNotEmpty &&
                    int.tryParse(ctrlLyDoTang.text) != null
                ? provider.getLyDoTang(int.parse(ctrlLyDoTang.text))
                : null,
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
        defaultValue:
            ctrlHienTrang.text.isNotEmpty &&
                    int.tryParse(ctrlHienTrang.text) != null
                ? provider.getHienTrang(int.parse(ctrlHienTrang.text))
                : null,
        onChanged: (value) {
          // ctrlHienTrang.text = value.name;
          onHienTrangChanged?.call(value);
        },
      ),

      CommonFormInput(
        label: 'Số lượng',
        controller: ctrlSoLuong,
        isEditing: isEditing,
        textContent: ctrlSoLuong.text,
        fieldName: 'soLuong',
        inputType: TextInputType.number,
        validationErrors: validationErrors,
      ),

      CommonFormInput(
        label: 'Đơn vị tính',
        controller: ctrlDonViTinh,
        isEditing: isEditing,
        textContent: ctrlDonViTinh.text,
        fieldName: 'donViTinh',
        validationErrors: validationErrors,
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
