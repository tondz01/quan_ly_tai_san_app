import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class ToolsAndSuppliesFormRight extends StatelessWidget {
  final bool isEditing;
  final ToolsAndSuppliesDto? item;
  final TextEditingController controllerSymbol;
  final TextEditingController controllerNote;
  final TextEditingController controllerQuantity;
  final TextEditingController controllerValue;
  final TextEditingController controllerGroupCCDC;
  final List<DropdownMenuItem<CcdcGroup>> itemsGroupCCDC;
  final Function(CcdcGroup?) onGroupCCDCChanged;
  final List<CcdcGroup> listGroupCCDC;

  final Map<String, bool>? validationErrors;

  const ToolsAndSuppliesFormRight({
    super.key,
    required this.isEditing,
    required this.item,
    required this.controllerSymbol,
    required this.controllerNote,
    required this.controllerQuantity,
    required this.controllerValue,
    required this.controllerGroupCCDC,
    required this.itemsGroupCCDC,
    required this.onGroupCCDCChanged,
    required this.validationErrors,
    required this.listGroupCCDC,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CmFormDropdownObject<CcdcGroup>(
          label: 'Nhóm ccdc',
          controller: controllerGroupCCDC,
          isEditing: isEditing,
          items: itemsGroupCCDC,
          defaultValue: getGroupCCDC(
            listCcdcGroup: listGroupCCDC,
            id: item?.idNhomCCDC ?? '',
          ),
          onChanged: onGroupCCDCChanged,
          fieldName: 'idNhomCcdc',
          validationErrors: validationErrors,
          isRequired: true
        ),
        CommonFormInput(
          label: 'tas.quantity'.tr,
          controller: controllerQuantity,
          isEditing: false,
          textContent: item?.soLuong.toString() ?? '0',
          inputType: TextInputType.number,
          fieldName: 'soLuong',
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'tas.value'.tr,
          controller: controllerValue,
          isEditing: isEditing,
          textContent: item?.giaTri.toString() ?? '0.0',
          inputType: TextInputType.number,
          fieldName: 'giaTri',
          validationErrors: validationErrors,
          isRequired: true
        ),
        CommonFormInput(
          label: 'tas.symbol'.tr,
          controller: controllerSymbol,
          isEditing: isEditing,
          textContent: item?.kyHieu ?? '',
          fieldName: 'kyHieu',
          validationErrors: validationErrors,
        ),
        CommonFormInput(
          label: 'tas.note'.tr,
          controller: controllerNote,
          isEditing: isEditing,
          textContent: item?.ghiChu ?? '',
          fieldName: 'ghiChu',
          validationErrors: validationErrors,
        ),
      ],
    );
  }
}

CcdcGroup? getGroupCCDC({
  required List<CcdcGroup> listCcdcGroup,
  required String id,
}) {
  final found = listCcdcGroup.where((item) => item.id == id);
  return found.firstOrNull;
}
