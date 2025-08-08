import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class ToolsAndSuppliesForm extends StatelessWidget {
  final bool isEditing;
  final ToolsAndSuppliesDto? item;

  final TextEditingController controllerImportUnit;
  final TextEditingController controllerName;
  final TextEditingController controllerCode;
  final TextEditingController controllerImportDate;
  final TextEditingController controllerUnit;
  final TextEditingController controllerQuantity;
  final TextEditingController controllerValue;
  final TextEditingController controllerReferenceNumber;
  final TextEditingController controllerSymbol;
  final TextEditingController controllerCapacity;
  final TextEditingController controllerCountryOfOrigin;
  final TextEditingController controllerYearOfManufacture;
  final TextEditingController controllerNote;

  final bool isNameValid;
  final bool isImportUnitValid;
  final bool isCodeValid;
  final bool isImportDateValid;
  final bool isUnitValid;
  final bool isQuantityValid;
  final bool isValueValid;
  final bool isYearOfManufactureValid;

  const ToolsAndSuppliesForm({
    super.key,
    required this.isEditing,
    required this.item,
    required this.controllerImportUnit,
    required this.controllerName,
    required this.controllerCode,
    required this.controllerImportDate,
    required this.controllerUnit,
    required this.controllerQuantity,
    required this.controllerValue,
    required this.controllerReferenceNumber,
    required this.controllerSymbol,
    required this.controllerCapacity,
    required this.controllerCountryOfOrigin,
    required this.controllerYearOfManufacture,
    required this.controllerNote,
    required this.isNameValid,
    required this.isImportUnitValid,
    required this.isCodeValid,
    required this.isImportDateValid,
    required this.isUnitValid,
    required this.isQuantityValid,
    required this.isValueValid,
    required this.isYearOfManufactureValid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonFormInput(
            label: 'tas.unit'.tr,
            controller: controllerImportUnit,
            isEditing: isEditing,
            textContent: item?.idDonVi ?? '',
            isDropdown: true,
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
          CommonFormInput(
            label: 'tas.import_date'.tr,
            controller: controllerImportDate,
            isEditing: isEditing,
            textContent: item?.ngayNhap.toString() ?? '',
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
            textContent: item?.namSanXuat.toString() ?? DateTime.now().year.toString(),
            inputType: TextInputType.number,
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
      ),
    );
  }
} 