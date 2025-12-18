import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_form_controllers.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';

class AssetHandoverDetailSection extends StatelessWidget {
  final AssetHandoverFormControllers controllers;
  final bool isEditing;
  final AssetHandoverDto? item;
  final AssetHandoverProvider provider;
  final List<NhanVien> listNhanVienDonViGiao;
  final List<NhanVien> listNhanVienDonViNhan;
  final List<DropdownMenuItem<NhanVien>> itemsNhanVien;
  final List<NhanVien> listNhanVien;
  final List<PhongBan> listPhongBan;
  final NhanVien? nguoiDaiDienBenGiao;
  final NhanVien? nguoiDaiDienBenNhan;
  final NhanVien? nguoiKyGiamDoc;
  final List<AdditionalSignerData> additionalSignersDetailed;
  final Map<String, bool> validationErrors;
  final Function(NhanVien?) onDelivererChanged;
  final Function(NhanVien?) onReceiverChanged;
  final Function(NhanVien?) onGiamDocChanged;
  final Function(List<AdditionalSignerData>) onAdditionalSignersChanged;

  const AssetHandoverDetailSection({
    super.key,
    required this.controllers,
    required this.isEditing,
    required this.item,
    required this.provider,
    required this.listNhanVienDonViGiao,
    required this.listNhanVienDonViNhan,
    required this.itemsNhanVien,
    required this.listNhanVien,
    required this.listPhongBan,
    required this.nguoiDaiDienBenGiao,
    required this.nguoiDaiDienBenNhan,
    required this.nguoiKyGiamDoc,
    required this.additionalSignersDetailed,
    required this.validationErrors,
    required this.onDelivererChanged,
    required this.onReceiverChanged,
    required this.onGiamDocChanged,
    required this.onAdditionalSignersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CmFormDropdownObject<NhanVien>(
          label: 'Đơn vị giao',
          controller: controllers.delivererRepresentative,
          isEditing: isEditing,
          defaultValue: item?.idDaiDienBenGiao != null
              ? provider.getNhanVien(idNhanVien: item!.idDaiDienBenGiao!)
              : null,
          fieldName: 'delivererRepresentative',
          items: listNhanVienDonViGiao
              .map(
                (e) => DropdownMenuItem<NhanVien>(
                  value: e,
                  child: Text('${e.hoTen ?? ''} - ${e.id ?? ''}'),
                ),
              )
              .toList(),
          onChanged: onDelivererChanged,
          validationErrors: validationErrors,
          isRequired: true,
        ),
        CmFormDropdownObject<NhanVien>(
          label: 'Đơn vị bên nhận',
          controller: controllers.receiverRepresentative,
          isEditing: isEditing,
          defaultValue: item?.idDaiDienBenNhan != null
              ? provider.getNhanVien(idNhanVien: item!.idDaiDienBenNhan!)
              : null,
          fieldName: 'receiverRepresentative',
          items: listNhanVienDonViNhan
              .map(
                (e) => DropdownMenuItem<NhanVien>(
                  value: e,
                  child: Text('${e.hoTen ?? ''} - ${e.id ?? ''}'),
                ),
              )
              .toList(),
          onChanged: onReceiverChanged,
          validationErrors: validationErrors,
          isRequired: true,
        ),
        AdditionalSignersSelector(
          addButtonText: "Thêm người đại diện",
          labelDepartment: "Người đại diện",
          isEditing: isEditing,
          itemsNhanVien: itemsNhanVien,
          phongBan: provider.dataDepartment,
          listNhanVien: listNhanVien,
          initialSigners: const [],
          onChanged: (_) {},
          initialSignerData: additionalSignersDetailed,
          onChangedDetailed: onAdditionalSignersChanged,
        ),
        const SizedBox(height: 10),
        CmFormDropdownObject<NhanVien>(
          label: 'Giám đốc ký xác nhận',
          controller: controllers.giamDocKy,
          isEditing: isEditing,
          value: nguoiKyGiamDoc,
          defaultValue: item?.idGiamDoc != null
              ? provider.getNhanVien(idNhanVien: item!.idGiamDoc!)
              : null,
          fieldName: 'giamDocXacNhan',
          items: AppUtility.getNhanVienLanhDao(
                nhanViens: listNhanVien,
                phongBans: listPhongBan,
              )
              .map(
                (e) => DropdownMenuItem<NhanVien>(
                  value: e,
                  child: Text('${e.hoTen ?? ''} - ${e.id ?? ''}'),
                ),
              )
              .toList(),
          onChanged: onGiamDocChanged,
          validationErrors: validationErrors,
          isRequired: true,
        ),
      ],
    );
  }
}

