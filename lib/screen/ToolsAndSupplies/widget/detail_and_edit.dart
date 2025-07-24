import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/model/tools_and_supplies_dto.dart';
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
  late TextEditingController controllerImportUnit;
  late TextEditingController controllerName;
  late TextEditingController controllerCode;
  late TextEditingController controllerImportDate;
  late TextEditingController controllerUnit;
  late TextEditingController controllerQuantity;
  late TextEditingController controllerValue;
  late TextEditingController controllerReferenceNumber;
  late TextEditingController controllerSymbol;
  late TextEditingController controllerCapacity;
  late TextEditingController controllerCountryOfOrigin;
  late TextEditingController controllerYearOfManufacture;
  late TextEditingController controllerNote;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với dữ liệu từ item
    controllerImportUnit = TextEditingController(
      text: widget.item?.importUnit ?? 'Chưa xác định / C.Ty TNHH MTV Môi trường - Vinacomin',
    );
    controllerName = TextEditingController(text: widget.item?.name ?? 'Test');
    controllerCode = TextEditingController(text: widget.item?.code ?? 'MaCCDCTest');
    controllerImportDate = TextEditingController(text: widget.item?.importDate ?? '09/04/2025');
    controllerUnit = TextEditingController(text: widget.item?.unit ?? 'Bộ');
    controllerQuantity = TextEditingController(text: (widget.item?.quantity ?? 10).toString());
    controllerValue = TextEditingController(text: (widget.item?.value ?? 3600000).toString());
    controllerReferenceNumber = TextEditingController(text: widget.item?.referenceNumber ?? '');
    controllerSymbol = TextEditingController(text: widget.item?.symbol ?? '');
    controllerCapacity = TextEditingController(text: widget.item?.capacity ?? '');
    controllerCountryOfOrigin = TextEditingController(text: widget.item?.countryOfOrigin ?? 'Anguilla');
    controllerYearOfManufacture = TextEditingController(text: widget.item?.yearOfManufacture ?? '2025');
    controllerNote = TextEditingController(text: widget.item?.note ?? 'Mua mới');
  }

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
          _buildDetailRow(
            label: 'tas.import_unit'.tr,
            controller: controllerImportUnit,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.name'.tr,
            controller: controllerName,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.code'.tr,
            controller: controllerCode,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.import_date'.tr,
            controller: controllerImportDate,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.unit'.tr,
            controller: controllerUnit,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.quantity'.tr,
            controller: controllerQuantity,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.value'.tr,
            controller: controllerValue,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.reference_number'.tr,
            controller: controllerReferenceNumber,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.symbol'.tr,
            controller: controllerSymbol,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.capacity'.tr,
            controller: controllerCapacity,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.country_of_origin'.tr,
            controller: controllerCountryOfOrigin,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.year_of_manufacture'.tr,
            controller: controllerYearOfManufacture,
            isEditing: widget.isEditing,
          ),
          _buildDetailRow(
            label: 'tas.note'.tr,
            controller: controllerNote,
            isEditing: widget.isEditing,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return value
        .toStringAsFixed(2)
        .replaceAll('.00', '')
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  Widget _buildDetailRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SGInputText(
              controller: controller,
              borderRadius: 10,
              enabled: isEditing,
              readOnly: !isEditing,
              onlyLine: true,
              showBorder: isEditing,
              hintText: '${'common.hint'.tr} $label',
            ),
          ),
        ],
      ),
    );
  }
}