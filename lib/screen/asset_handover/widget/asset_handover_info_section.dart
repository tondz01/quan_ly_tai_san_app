import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_form_controllers.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';

class AssetHandoverInfoSection extends StatelessWidget {
  final AssetHandoverFormControllers controllers;
  final bool isEditing;
  final AssetHandoverDto? item;
  final bool isFindNew;
  final List<DieuDongTaiSanDto> listAssetTransfer;
  final List<DropdownMenuItem<DieuDongTaiSanDto>> itemsAssetTransfer;
  final List<PhongBan> listPhongBan;
  final List<DropdownMenuItem<PhongBan>> itemsPhongBan;
  final DieuDongTaiSanDto? dieuDongTaiSan;
  final PhongBan? donViGiao;
  final PhongBan? donViNhan;
  final Map<String, bool> validationErrors;
  final Function(DieuDongTaiSanDto?) onOrderChanged;
  final Function(PhongBan?) onDonViGiaoChanged;
  final Function(PhongBan?) onDonViNhanChanged;
  final Function(String, DateTime?) onDateChanged;

  const AssetHandoverInfoSection({
    super.key,
    required this.controllers,
    required this.isEditing,
    required this.item,
    required this.isFindNew,
    required this.listAssetTransfer,
    required this.itemsAssetTransfer,
    required this.listPhongBan,
    required this.itemsPhongBan,
    required this.dieuDongTaiSan,
    required this.donViGiao,
    required this.donViNhan,
    required this.validationErrors,
    required this.onOrderChanged,
    required this.onDonViGiaoChanged,
    required this.onDonViNhanChanged,
    required this.onDateChanged,
  });

  DieuDongTaiSanDto _getAssetTransfer(String? id) {
    if (id == null) return DieuDongTaiSanDto();
    return listAssetTransfer
            .where((item) => item.id == id)
            .firstOrNull ??
        DieuDongTaiSanDto();
  }

  PhongBan _getPhongBan(String? id) {
    if (id == null) return PhongBan();
    return listPhongBan.where((item) => item.id == id).firstOrNull ??
        PhongBan();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Visibility(
          visible: !(isEditing && item == null) && !isFindNew,
          child: CommonFormInput(
            label: 'Số phiếu bàn giao',
            controller: controllers.handoverNumber,
            isEditing: (isEditing && item == null),
            fieldName: 'handoverNumber',
            textContent: item?.id ?? '',
            validationErrors: validationErrors,
            isRequired: true,
          ),
        ),
        CommonFormInput(
          label: 'Tên biên bản bàn giao tài sản',
          controller: controllers.documentName,
          isEditing: isEditing,
          textContent: item?.banGiaoTaiSan ?? '',
          fieldName: 'documentName',
          validationErrors: validationErrors,
          isRequired: true,
        ),
        CmFormDropdownObject<DieuDongTaiSanDto>(
          label: 'Lệnh điều động',
          controller: controllers.order,
          isEditing: isEditing,
          value: dieuDongTaiSan,
          defaultValue: item?.lenhDieuDong != null
              ? _getAssetTransfer(item!.quyetDinhDieuDongSo)
              : null,
          fieldName: 'order',
          items: itemsAssetTransfer,
          onChanged: onOrderChanged,
          validationErrors: validationErrors,
          isRequired: true,
        ),
        CmFormDropdownObject<PhongBan>(
          label: 'Đơn vị giao',
          controller: controllers.senderUnit,
          isEditing: false,
          value: donViGiao,
          defaultValue: item?.idDonViGiao != null
              ? _getPhongBan(item!.idDonViGiao)
              : null,
          fieldName: 'senderUnit',
          items: itemsPhongBan,
          onChanged: onDonViGiaoChanged,
          validationErrors: validationErrors,
        ),
        CmFormDropdownObject<PhongBan>(
          label: 'Đơn vị nhận',
          controller: controllers.receiverUnit,
          isEditing: false,
          value: donViNhan,
          defaultValue:
              item?.idDonViNhan != null ? _getPhongBan(item!.idDonViNhan) : null,
          fieldName: 'receiverUnit',
          items: itemsPhongBan,
          onChanged: onDonViNhanChanged,
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'Số quyết định',
          controller: controllers.decisionNumber,
          isEditing: isEditing,
          textContent: item?.soQuyetDinh ?? '',
          fieldName: 'decisionNumber',
          validationErrors: validationErrors,
          isRequired: true,
        ),
        CommonFormInput(
          label: 'Địa điểm bàn giao',
          controller: controllers.decisionLocation,
          isEditing: isEditing,
          textContent: item?.diaDiemQuyetDinh ?? '',
          fieldName: 'decisionLocation',
          validationErrors: validationErrors,
          isRequired: true,
        ),
        CmFormDate(
          label: 'Ngày quyết định',
          controller: controllers.decisionDate,
          isEditing: isEditing,
          value: controllers.ngayQuyetDinh,
          onChanged: (dt) => onDateChanged('ngayQuyetDinh', dt),
          validationErrors: validationErrors,
          fieldName: 'decisionDate',
          isRequired: true,
        ),
        CmFormDate(
          label: 'Ngày bàn giao',
          controller: controllers.transferDate,
          isEditing: isEditing,
          value: controllers.ngayBanGiao,
          onChanged: (dt) => onDateChanged('ngayBanGiao', dt),
          validationErrors: validationErrors,
          fieldName: 'transferDate',
          isRequired: true,
        ),
        CmFormDate(
          label: 'Ngày tạo chứng từ',
          controller: controllers.documentCreationDate,
          isEditing: isEditing,
          value: controllers.ngayTaoChungTu,
          onChanged: (dt) => onDateChanged('ngayTaoChungTu', dt),
          validationErrors: validationErrors,
          fieldName: 'documentCreationDate',
          isRequired: true,
        ),
      ],
    );
  }
}

