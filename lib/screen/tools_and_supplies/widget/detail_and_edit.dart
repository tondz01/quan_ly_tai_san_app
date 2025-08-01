// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/note/widget/note_view.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_button_icon.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
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
    const DropdownMenuItem(value: 'Phòng CV', child: Text('Phòng CV')),
    const DropdownMenuItem(value: 'Kho Công ty', child: Text('Kho Công ty')),
    const DropdownMenuItem(value: 'Phòng IT', child: Text('Phòng IT')),
    const DropdownMenuItem(
      value: 'Phòng hành chính',
      child: Text('Phòng hành chính'),
    ),
    const DropdownMenuItem(
      value: 'Phòng Kỹ thuật',
      child: Text('Phòng Kỹ thuật'),
    ),
    const DropdownMenuItem(
      value: 'Phòng Kế toán',
      child: Text('Phòng Kế toán'),
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
    log('widget.item?.importUnit : ${widget.item?.importUnit}');
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialTextButton(
                text: isEditing ? 'tas.create_ccdc'.tr : 'common.edit'.tr,
                icon: isEditing ? Icons.add : Icons.edit,
                backgroundColor: isEditing
                    ? ColorValue.neutral300
                    : ColorValue.primaryBlue,
                foregroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
              ),
              SgIndicator(
                steps: ['Nháp', 'Khóa'],
                currentStep: !isEditing && widget.item != null ? 1 : 0,
              ),
            ],
          ),

          const SizedBox(height: 10),
          _showResponsive(),
        ],
      ),
    );
  }

  Widget _showResponsive() {
    final size = MediaQuery.of(context).size;
    log('message ${size.width}');
    if (size.width < 1444) {
      return Column(
        children: [
          _buildTableDetail(),
          const SizedBox(height: 10),
          _buildNoteSection(),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildTableDetail()),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _buildNoteSection()),
        ],
      );
    }
  }

  Widget _buildNoteSection() {
    return SizedBox(
      height: 400,
      // padding: const EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //   // color: Colors.white,
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: Colors.grey.shade300),
      // ),
      child: IgnorePointer(
        ignoring: false,
        child: AbsorbPointer(
          absorbing: false,
          child: RepaintBoundary(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return const NoteView();
              },
            ),
          ),
        ),
      ),
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
  Widget _buildTableDetail() {
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
          _buildDetailRow(
            label: 'tas.unit'.tr,
            controller: controllerImportUnit,
            isEditing: isEditing,
            textContent: widget.item?.importUnit ?? '',
            isDropdown: true,
          ),
          _buildDetailRow(
            label: 'tas.name'.tr,
            controller: controllerName,
            isEditing: isEditing,
            textContent: widget.item?.name ?? '',
          ),
          _buildDetailRow(
            label: 'tas.code'.tr,
            controller: controllerCode,
            isEditing: isEditing,
            textContent: widget.item?.code ?? '',
          ),
          _buildDetailRow(
            label: 'tas.import_date'.tr,
            controller: controllerImportDate,
            isEditing: isEditing,
            textContent: widget.item?.importDate ?? '',
          ),
          _buildDetailRow(
            label: 'tas.unit'.tr,
            controller: controllerUnit,
            isEditing: isEditing,
            textContent: widget.item?.unit ?? '',
          ),
          _buildDetailRow(
            label: 'tas.quantity'.tr,
            controller: controllerQuantity,
            isEditing: isEditing,
            textContent: widget.item?.quantity.toString() ?? '0',
            inputType: TextInputType.number,
          ),
          _buildDetailRow(
            label: 'tas.value'.tr,
            controller: controllerValue,
            isEditing: isEditing,
            textContent: widget.item?.value.toString() ?? '0.0',
            inputType: TextInputType.number,
          ),
          _buildDetailRow(
            label: 'tas.reference_number'.tr,
            controller: controllerReferenceNumber,
            isEditing: isEditing,
            textContent: widget.item?.referenceNumber ?? '',
          ),
          _buildDetailRow(
            label: 'tas.symbol'.tr,
            controller: controllerSymbol,
            isEditing: isEditing,
            textContent: widget.item?.symbol ?? '',
          ),
          _buildDetailRow(
            label: 'tas.capacity'.tr,
            controller: controllerCapacity,
            isEditing: isEditing,
            textContent: widget.item?.capacity ?? '',
          ),
          _buildDetailRow(
            label: 'tas.country_of_origin'.tr,
            controller: controllerCountryOfOrigin,
            isEditing: isEditing,
            textContent: widget.item?.countryOfOrigin ?? '',
          ),
          _buildDetailRow(
            label: 'tas.year_of_manufacture'.tr,
            controller: controllerYearOfManufacture,
            isEditing: isEditing,
            textContent:
                widget.item?.yearOfManufacture ??
                DateTime.now().year.toString(),
          ),
          _buildDetailRow(
            label: 'tas.note'.tr,
            controller: controllerNote,
            isEditing: isEditing,
            textContent: widget.item?.note ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String textContent,
    required TextEditingController controller,
    required bool isEditing,
    bool isDropdown = false,
    bool isValidate = false,
    TextInputType? inputType,
  }) {
    log('message $inputType');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 180,
          child: Text(
            '$label :',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color:
                  !isEditing ? Colors.black87.withOpacity(0.6) : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isDropdown && isEditing
                  ? SGDropdownInputButton<String>(
                    height: 35,
                    controller: controller,
                    textOverflow: TextOverflow.ellipsis,
                    // Use value directly rather than setting controller.text
                    value: textContent,
                    defaultValue: textContent,
                    items: itemsPhongBan,
                    colorBorder: SGAppColors.neutral400,
                    showUnderlineBorderOnly: true,
                    enableSearch: false,
                    isClearController: false,
                    fontSize: 16,
                    inputType: inputType,
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
                      if (value != null) {
                        controller.text = value;
                      }
                    },
                  )
                  : SGInputText(
                    height: 35,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    controller: controller..text = textContent,
                    borderRadius: 10,
                    enabled: isEditing,
                    textAlign: TextAlign.left,
                    readOnly: !isEditing,
                    inputFormatters: inputType == TextInputType.number
                        ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))]
                        : null,
                    onlyLine: true,
                    color: Colors.black,
                    showBorder: isEditing,
                    hintText: !isEditing ? '' : '${'common.hint'.tr} $label',
                  ),
              if (isValidate) const Divider(height: 1, color: Colors.red),
            ],
          ),
        ),
      ],
    );
  }
}
