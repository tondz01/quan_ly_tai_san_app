// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/utils/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_button_icon.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_input_text.dart';

class DetailAndEditView extends StatefulWidget {
  final ToolsAndSuppliesDto? item;
  final bool isEditing;

  const DetailAndEditView({super.key, this.item, this.isEditing = false});

  @override
  State<DetailAndEditView> createState() => _DetailAndEditViewState();
}

class _DetailAndEditViewState extends State<DetailAndEditView> {
  // Các controller để quản lý dữ liệu nhập liệu
  late TextEditingController controllerImportUnit = TextEditingController();
  late TextEditingController controllerName = TextEditingController();
  late TextEditingController controllerCode = TextEditingController();
  late TextEditingController controllerImportDate = TextEditingController();
  late TextEditingController controllerUnit = TextEditingController();
  late TextEditingController controllerQuantity = TextEditingController();
  late TextEditingController controllerValue = TextEditingController();
  late TextEditingController controllerReferenceNumber =
      TextEditingController();
  late TextEditingController controllerSymbol = TextEditingController();
  late TextEditingController controllerCapacity = TextEditingController();
  late TextEditingController controllerCountryOfOrigin =
      TextEditingController();
  late TextEditingController controllerYearOfManufacture =
      TextEditingController();
  late TextEditingController controllerNote = TextEditingController();
  late TextEditingController controllerDropdown = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    isEditing = widget.isEditing;
    super.initState();
  }

  final List<DropdownMenuItem<String>> itemsPhongBan = [
    const DropdownMenuItem(value: 'Ban giám đốc', child: Text('Ban giám đốc')),
    const DropdownMenuItem(
      value: 'Chưa xác định / C.Ty TNHH MTV Môi trường - Vinacomin',
      child: Text('Chưa xác định / C.Ty TNHH MTV Môi trường - Vinacomin'),
    ),
    const DropdownMenuItem(
      value: 'Công ty CP Cơ điện Uông bí - Vinacomin',
      child: Text('Công ty CP Cơ điện Uông bí - Vinacomin'),
    ),
    const DropdownMenuItem(
      value: 'Công ty TNHH Nam Hưng',
      child: Text('Công ty TNHH Nam Hưng'),
    ),
    const DropdownMenuItem(
      value: 'Phòng hành chính',
      child: Text('Phòng hành chính'),
    ),
  ];
  @override
  void dispose() {
    // Giải phóng các controller
    controllerImportUnit.dispose();
    controllerName.dispose();
    controllerCode.dispose();
    controllerImportDate.dispose();
    controllerUnit.dispose();
    controllerQuantity.dispose();
    controllerValue.dispose();
    controllerReferenceNumber.dispose();
    controllerSymbol.dispose();
    controllerCapacity.dispose();
    controllerCountryOfOrigin.dispose();
    controllerYearOfManufacture.dispose();
    controllerNote.dispose();
    super.dispose();
  }

  void findPhongBan(String? value) {
    log('message');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SGButtonIcon(
          text: isEditing ? 'tas.create_ccdc'.tr : 'common.edit'.tr,
          borderRadius: 10,
          width: Get.width * 0.12 <= 120 ? 120 : Get.width * 0.12,
          defaultBGColor:
              isEditing
                  ? SGAppColors.colorInputDisable
                  : ColorValue.oldLavender,
          colorHover: Colors.blueAccent,
          colorTextHover: Colors.white,
          isOutlined: true,
          borderWidth: 3,
          onPressed: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                label: 'tas.import_unit'.tr,
                controller: controllerImportUnit,
                isEditing: isEditing,
                textContent: widget.item!.importUnit,
                isDropdown: true,
              ),
              _buildDetailRow(
                label: 'tas.name'.tr,
                controller: controllerName,
                isEditing: isEditing,
                textContent: widget.item!.name,
              ),
              _buildDetailRow(
                label: 'tas.code'.tr,
                controller: controllerCode,
                isEditing: isEditing,
                textContent: widget.item!.code,
              ),
              _buildDetailRow(
                label: 'tas.import_date'.tr,
                controller: controllerImportDate,
                isEditing: isEditing,
                textContent: widget.item!.importDate,
              ),
              _buildDetailRow(
                label: 'tas.unit'.tr,
                controller: controllerUnit,
                isEditing: isEditing,
                textContent: widget.item!.unit,
              ),
              _buildDetailRow(
                label: 'tas.quantity'.tr,
                controller: controllerQuantity,
                isEditing: isEditing,
                textContent: widget.item!.quantity.toString(),
              ),
              _buildDetailRow(
                label: 'tas.value'.tr,
                controller: controllerValue,
                isEditing: isEditing,
                textContent: widget.item!.referenceNumber,
              ),
              _buildDetailRow(
                label: 'tas.reference_number'.tr,
                controller: controllerReferenceNumber,
                isEditing: isEditing,
                textContent: widget.item!.referenceNumber,
              ),
              _buildDetailRow(
                label: 'tas.symbol'.tr,
                controller: controllerSymbol,
                isEditing: isEditing,
                textContent: widget.item!.symbol,
              ),
              _buildDetailRow(
                label: 'tas.capacity'.tr,
                controller: controllerCapacity,
                isEditing: isEditing,
                textContent: widget.item!.capacity,
              ),
              _buildDetailRow(
                label: 'tas.country_of_origin'.tr,
                controller: controllerCountryOfOrigin,
                isEditing: isEditing,
                textContent: widget.item!.countryOfOrigin,
              ),
              _buildDetailRow(
                label: 'tas.year_of_manufacture'.tr,
                controller: controllerYearOfManufacture,
                isEditing: isEditing,
                textContent: widget.item!.yearOfManufacture,
              ),
              _buildDetailRow(
                label: 'tas.note'.tr,
                controller: controllerNote,
                isEditing: isEditing,
                textContent: widget.item!.note,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // String _formatCurrency(double value) {
  //   return value
  //       .toStringAsFixed(2)
  //       .replaceAll('.00', '')
  //       .replaceAllMapped(
  //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  //         (Match m) => '${m[1]}.',
  //       );
  // }

  Widget _buildDetailRow({
    required String label,
    required String textContent,
    required TextEditingController controller,
    required bool isEditing,
    bool isDropdown = false,
  }) {
    if (!isDropdown) {
      controller.text = textContent;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 180,
          child: Text(
            '$label :',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: 16),
        isDropdown
            ? Expanded(
              child: SGDropdownInputButton<String>(
                // width: Get.width * 0.12 <= 120 ? 120 : Get.width * 0.12,
                height: 35,
                controller: controller,
                textOverflow: TextOverflow.ellipsis,
                value: label,
                items: itemsPhongBan,
                colorBorder: SGAppColors.neutral400,
                showUnderlineBorderOnly: true,
                enableSearch: false,
                isClearController: false,
                isShowSuffixIcon: true,
                hintText: 'Chọn ${label.toLowerCase()}',
                textAlign: TextAlign.left,
                textAlignItem: TextAlign.left,
                sizeBorderCircular: 10,
                contentPadding: const EdgeInsets.only(
                  left: 10,
                  top: 8,
                  bottom: 8,
                ),
                onChanged: (value) {
                  log('message');
                  controller.text = value ?? '';
                },
              ),
            )
            : Expanded(
              child: SGInputText(
                height: 35,
                controller: controller,
                borderRadius: 10,
                enabled: isEditing,
                textAlign: TextAlign.left,
                readOnly: !isEditing,
                onlyLine: true,
                color: Colors.black,
                showBorder: isEditing,
                hintText: !isEditing ? '' : '${'common.hint'.tr} $label',
              ),
            ),
      ],
    );
  }
}
