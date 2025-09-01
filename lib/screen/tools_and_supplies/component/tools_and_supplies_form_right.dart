import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class ToolsAndSuppliesFormRight extends StatelessWidget {
  final bool isEditing;
  final ToolsAndSuppliesDto? item;
  final TextEditingController controllerSymbol;
  final TextEditingController controllerNote;
  final TextEditingController controllerQuantity;
  final TextEditingController controllerValue;
  final bool isQuantityValid;
  final bool isValueValid;

  const ToolsAndSuppliesFormRight({
    super.key,
    required this.isEditing,
    required this.item,
    required this.controllerSymbol,
    required this.controllerNote,
    required this.controllerQuantity,
    required this.controllerValue,
    required this.isQuantityValid,
    required this.isValueValid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonFormInput(
          label: 'tas.quantity'.tr,
          controller: controllerQuantity,
          isEditing: false,
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
        CommonFormInput(
          label: 'tas.symbol'.tr,
          controller: controllerSymbol,
          isEditing: isEditing,
          textContent: item?.kyHieu ?? '',
        ),
        CommonFormInput(
          label: 'tas.note'.tr,
          controller: controllerNote,
          isEditing: isEditing,
          textContent: item?.ghiChu ?? '',
        ),
      ],
    );
  }
}
