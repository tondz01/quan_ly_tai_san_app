import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';

class ToolsAndSuppliesFormLeft extends StatelessWidget {
  final bool isEditing;
  final ToolsAndSuppliesDto? item;
  final ToolsAndSuppliesProvider provider;
  final Function(PhongBan?) onPhongBanChanged;
  final Function(DateTime?) onImportDateChanged;
  final List<PhongBan> listPhongBan;
  final List<DropdownMenuItem<PhongBan>> itemsPhongBan;
  final TextEditingController controllerImportUnit;
  final TextEditingController controllerName;
  final TextEditingController controllerCode;
  final TextEditingController controllerImportDate;
  final TextEditingController controllerUnit;
  final TextEditingController controllerQuantity;
  final TextEditingController controllerValue;
  final bool isNameValid;
  final bool isImportUnitValid;
  final bool isCodeValid;
  final bool isImportDateValid;
  final bool isUnitValid;
  final bool isQuantityValid;
  final bool isValueValid;

  const ToolsAndSuppliesFormLeft({
    super.key,
    required this.isEditing,
    required this.item,
    required this.provider,
    required this.onPhongBanChanged,
    required this.onImportDateChanged,
    required this.listPhongBan,
    required this.itemsPhongBan,
    required this.controllerImportUnit,
    required this.controllerName,
    required this.controllerCode,
    required this.controllerImportDate,
    required this.controllerUnit,
    required this.controllerQuantity,
    required this.controllerValue,
    required this.isNameValid,
    required this.isImportUnitValid,
    required this.isCodeValid,
    required this.isImportDateValid,
    required this.isUnitValid,
    required this.isQuantityValid,
    required this.isValueValid,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CmFormDropdownObject<PhongBan>(
          label: 'tas.import_unit'.tr,
          controller: controllerImportUnit,
          isEditing: isEditing,
          items: itemsPhongBan,
          defaultValue:
              controllerImportUnit.text.isNotEmpty
                  ? getPhongBan(
                    listPhongBan: listPhongBan,
                    idPhongBan: controllerImportUnit.text,
                  )
                  : null,
          onChanged: onPhongBanChanged,
          fieldName: 'idPhongBan',
          validationErrors: {'importUnit': !isImportUnitValid && isEditing},
        ),
        CommonFormInput(
          label: 'tas.name'.tr,
          controller: controllerName,
          isEditing: isEditing,
          textContent: item?.ten ?? '',
          validationErrors: {'name': !isNameValid && isEditing},
        ),
        CommonFormInput(
          label: 'tas.code'.tr,
          controller: controllerCode,
          isEditing: isEditing,
          textContent: item?.soKyHieu ?? '',
          validationErrors: {'code': !isCodeValid && isEditing},
        ),
        CmFormDate(
          label: 'tas.import_date'.tr,
          controller: controllerImportDate,
          isEditing: isEditing,
          onChanged: onImportDateChanged,
          value: selected,
          validationErrors: {'importDate': !isImportDateValid && isEditing},
        ),
        CommonFormInput(
          label: 'tas.unit'.tr,
          controller: controllerUnit,
          isEditing: isEditing,
          textContent: item?.donViTinh ?? '',
          validationErrors: {'unit': !isUnitValid && isEditing},
        ),
        CommonFormInput(
          label: 'tas.quantity'.tr,
          controller: controllerQuantity,
          isEditing: isEditing,
          textContent: item?.soLuong.toString() ?? '0',
          inputType: TextInputType.number,
          validationErrors: {'quantity': !isQuantityValid && isEditing},
        ),
        CommonFormInput(
          label: 'tas.value'.tr,
          controller: controllerValue,
          isEditing: isEditing,
          textContent: item?.giaTri.toString() ?? '0.0',
          inputType: TextInputType.number,
          validationErrors: {'value': !isValueValid && isEditing},
        ),
      ],
    );
  }
}

PhongBan getPhongBan({
  required List<PhongBan> listPhongBan,
  required String idPhongBan,
}) {
  final found = listPhongBan.where((item) => item.id == idPhongBan);
  if (found.isEmpty) {
    // Trả về một AssetGroupDto mặc định nếu không tìm thấy
    return PhongBan();
  }
  return found.first;
}
