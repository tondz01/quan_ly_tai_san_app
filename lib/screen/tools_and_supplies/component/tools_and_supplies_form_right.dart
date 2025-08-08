import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class ToolsAndSuppliesFormRight extends StatelessWidget {
  final bool isEditing;
  final bool isYearOfManufactureValid;
  final ToolsAndSuppliesDto? item;
  final TextEditingController controllerReferenceNumber;
  final TextEditingController controllerSymbol;
  final TextEditingController controllerCapacity;
  final TextEditingController controllerCountryOfOrigin;
  final TextEditingController controllerYearOfManufacture;
  final TextEditingController controllerNote;


  const ToolsAndSuppliesFormRight({
    super.key,
    required this.isEditing,
    required this.item,
    required this.controllerReferenceNumber,
    required this.controllerSymbol,
    required this.controllerCapacity,
    required this.controllerCountryOfOrigin,
    required this.controllerYearOfManufacture,
    required this.controllerNote,
    required this.isYearOfManufactureValid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonFormInput(
          label: 'tas.reference_number'.tr,
          controller: controllerReferenceNumber,
          isEditing: isEditing,
          textContent: item?.soKyHieu ?? '',
        ),
        CommonFormInput(
          label: 'tas.symbol'.tr,
          controller: controllerSymbol,
          isEditing: isEditing,
          textContent: item?.kyHieu ?? '',
        ),
        CommonFormInput(
          label: 'tas.capacity'.tr,
          controller: controllerCapacity,
          isEditing: isEditing,
          textContent: item?.congSuat ?? '',
        ),
        CommonFormInput(
          label: 'tas.country_of_origin'.tr,
          controller: controllerCountryOfOrigin,
          isEditing: isEditing,
          textContent: item?.nuocSanXuat ?? '',
        ),
        CommonFormInput(
          label: 'tas.year_of_manufacture'.tr,
          controller: controllerYearOfManufacture,
          isEditing: isEditing,
          textContent:
              item?.namSanXuat.toString() ?? DateTime.now().year.toString(),
          // inputType: TextInputType.number,
          validationErrors: {
            'yearOfManufacture': !isYearOfManufactureValid && isEditing,
          },
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
