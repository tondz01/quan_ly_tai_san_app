// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:provider/provider.dart';
import 'package:se_gay_components/common/sg_button_icon.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_indicator.dart';

class ToolsAndSuppliesDetail extends StatefulWidget {
  final ToolsAndSuppliesDto? item;
  final bool? isEditing;

  const ToolsAndSuppliesDetail({super.key, this.item, this.isEditing = false});

  @override
  State<ToolsAndSuppliesDetail> createState() => _ToolsAndSuppliesDetailState();
}

class _ToolsAndSuppliesDetailState extends State<ToolsAndSuppliesDetail> {
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

  // Validation states
  bool isNameValid = true;
  bool isImportUnitValid = true;
  bool isCodeValid = true;
  bool isImportDateValid = true;
  bool isUnitValid = true;
  bool isQuantityValid = true;
  bool isValueValid = true;
  bool isYearOfManufactureValid = true;

  @override
  void initState() {
    isEditing = widget.isEditing ?? false;
    initData();
    super.initState();
  }

  @override
  void didUpdateWidget(ToolsAndSuppliesDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      initData();
    }
  }

  void initData() {
    if (widget.item != null) {
      controllerImportUnit.text = widget.item?.importUnit ?? '';
      controllerName.text = widget.item?.name ?? '';
      controllerCode.text = widget.item?.code ?? '';
      controllerImportDate.text = widget.item?.importDate ?? '';
      controllerUnit.text = widget.item?.unit ?? '';
      controllerQuantity.text = widget.item?.quantity.toString() ?? '0';
      controllerValue.text = widget.item?.value.toString() ?? '0.0';
      controllerReferenceNumber.text = widget.item?.referenceNumber ?? '';
      controllerSymbol.text = widget.item?.symbol ?? '';
      controllerCapacity.text = widget.item?.capacity ?? '';
      controllerCountryOfOrigin.text = widget.item?.countryOfOrigin ?? '';
      controllerYearOfManufacture.text = widget.item?.yearOfManufacture ?? '';
    } else {
      isEditing = widget.item == null;
      controllerImportUnit.clear();
      controllerName.clear();
      controllerCode.clear();
      controllerImportDate.clear();
      controllerUnit.clear();
      controllerQuantity.clear();
      controllerValue.clear();
      controllerReferenceNumber.clear();
      controllerSymbol.clear();
      controllerCapacity.clear();
      controllerCountryOfOrigin.clear();
      controllerYearOfManufacture.clear();
    }
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
    // controllerImportUnit.dispose();
    // controllerName.dispose();
    // controllerCode.dispose();
    // controllerImportDate.dispose();
    // controllerUnit.dispose();
    // controllerQuantity.dispose();
    // controllerValue.dispose();
    // controllerReferenceNumber.dispose();
    // controllerSymbol.dispose();
    // controllerCapacity.dispose();
    // controllerCountryOfOrigin.dispose();
    // controllerYearOfManufacture.dispose();
    // controllerNote.dispose();
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
              Row(
                children: [
                  if (widget.item != null)
                    SGButtonIcon(
                      text: isEditing ? 'tas.create_ccdc'.tr : 'common.edit'.tr,
                      borderRadius: 10,
                      sizeText: 14,
                      width:
                          screenWidth * 0.12 <= 120 ? 120 : screenWidth * 0.12,
                      height: 40,
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
                  if (isEditing) ...[
                    SGButtonIcon(
                      text: 'Save'.tr,
                      borderRadius: 10,
                      sizeText: 14,
                      width:
                          screenWidth * 0.12 <= 120 ? 120 : screenWidth * 0.12,
                      height: 40,
                      defaultBGColor: Colors.blue,
                      colorHover: Colors.blueGrey,
                      colorTextHover: Colors.white,
                      isOutlined: false,
                      onPressed: () {
                        _saveItem();
                      },
                    ),
                    const SizedBox(width: 10),
                    SGButtonIcon(
                      text: 'common.cancel'.tr,
                      borderRadius: 10,
                      sizeText: 14,
                      width:
                          screenWidth * 0.12 <= 120 ? 120 : screenWidth * 0.12,
                      height: 40,
                      defaultBGColor: Colors.red,
                      colorHover: Colors.red.shade700,
                      colorTextHover: Colors.white,
                      isOutlined: false,
                      onPressed: () {
                        _cancelEdit();
                      },
                    ),
                  ],
                ],
              ),
              SgIndicator(
                steps: ['Nháp', 'Khóa'],
                currentStep: !isEditing && widget.item != null ? 1 : 0,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTableDetail(),
        ],
      ),
    );
  }

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
          CommonFormInput(
            label: 'tas.unit'.tr,
            controller: controllerImportUnit,
            isEditing: isEditing,
            textContent: widget.item?.importUnit ?? '',
            isDropdown: true,
            validationErrors: {
              'importUnit': !isImportUnitValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.name'.tr,
            controller: controllerName,
            isEditing: isEditing,
            textContent: widget.item?.name ?? '',
            validationErrors: {
              'name': !isNameValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.code'.tr,
            controller: controllerCode,
            isEditing: isEditing,
            textContent: widget.item?.code ?? '',
            validationErrors: {
              'code': !isCodeValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.import_date'.tr,
            controller: controllerImportDate,
            isEditing: isEditing,
            textContent: widget.item?.importDate ?? '',
            validationErrors: {
              'importDate': !isImportDateValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.unit'.tr,
            controller: controllerUnit,
            isEditing: isEditing,
            textContent: widget.item?.unit ?? '',
            validationErrors: {
              'unit': !isUnitValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.quantity'.tr,
            controller: controllerQuantity,
            isEditing: isEditing,
            textContent: widget.item?.quantity.toString() ?? '0',
            inputType: TextInputType.number,
            validationErrors: {
              'quantity': !isQuantityValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.value'.tr,
            controller: controllerValue,
            isEditing: isEditing,
            textContent: widget.item?.value.toString() ?? '0.0',
            inputType: TextInputType.number,
            validationErrors: {
              'value': !isValueValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.reference_number'.tr,
            controller: controllerReferenceNumber,
            isEditing: isEditing,
            textContent: widget.item?.referenceNumber ?? '',
          ),
          CommonFormInput(
            label: 'tas.symbol'.tr,
            controller: controllerSymbol,
            isEditing: isEditing,
            textContent: widget.item?.symbol ?? '',
          ),
          CommonFormInput(
            label: 'tas.capacity'.tr,
            controller: controllerCapacity,
            isEditing: isEditing,
            textContent: widget.item?.capacity ?? '',
          ),
          CommonFormInput(
            label: 'tas.country_of_origin'.tr,
            controller: controllerCountryOfOrigin,
            isEditing: isEditing,
            textContent: widget.item?.countryOfOrigin ?? '',
          ),
          CommonFormInput(
            label: 'tas.year_of_manufacture'.tr,
            controller: controllerYearOfManufacture,
            isEditing: isEditing,
            textContent:
                widget.item?.yearOfManufacture ??
                DateTime.now().year.toString(),
            inputType: TextInputType.number,
            validationErrors: {
              'yearOfManufacture': !isYearOfManufactureValid && isEditing,
            },
          ),
          CommonFormInput(
            label: 'tas.note'.tr,
            controller: controllerNote,
            isEditing: isEditing,
            textContent: widget.item?.note ?? '',
          ),
        ],
      ),
    );
  }

  void _saveItem() {
    // Validate form trước khi lưu
    if (!_validateForm()) {
      return;
    }

    // Tạo object mới từ dữ liệu form
    final newItem = ToolsAndSuppliesDto(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: controllerName.text.trim(),
      importUnit: controllerImportUnit.text.trim(),
      code: controllerCode.text.trim(),
      importDate: controllerImportDate.text.trim(),
      unit: controllerUnit.text.trim(),
      quantity: int.tryParse(controllerQuantity.text) ?? 0,
      value: double.tryParse(controllerValue.text) ?? 0.0,
      referenceNumber: controllerReferenceNumber.text.trim(),
      symbol: controllerSymbol.text.trim(),
      capacity: controllerCapacity.text.trim(),
      countryOfOrigin: controllerCountryOfOrigin.text.trim(),
      yearOfManufacture: controllerYearOfManufacture.text.trim(),
      note: controllerNote.text.trim(),
    );

    // Nếu là item mới (widget.item == null), thêm vào danh sách
    if (widget.item == null) {
      // Thêm item mới vào provider
      final provider = Provider.of<ToolsAndSuppliesProvider>(
        context,
        listen: false,
      );
      provider.addNewItem(newItem);
    } else {
      // Cập nhật item hiện tại
      final provider = Provider.of<ToolsAndSuppliesProvider>(
        context,
        listen: false,
      );
      provider.updateItem(newItem);
    }

    // Reset validation states
    isNameValid = true;
    isImportUnitValid = true;
    isCodeValid = true;
    isImportDateValid = true;
    isUnitValid = true;
    isQuantityValid = true;
    isValueValid = true;
    isYearOfManufactureValid = true;

    // Thoát khỏi chế độ edit
    setState(() {
      isEditing = false;
    });

    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.item == null ? 'Thêm mới thành công!' : 'Cập nhật thành công!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _validateForm() {
    List<String> errors = [];
    bool isValid = true;

    // Validate tên công cụ dụng cụ
    isNameValid = controllerName.text.trim().isNotEmpty;
    if (!isNameValid) {
      errors.add('Tên công cụ dụng cụ không được để trống');
      isValid = false;
    }

    // Validate đơn vị nhập
    isImportUnitValid = controllerImportUnit.text.trim().isNotEmpty;
    if (!isImportUnitValid) {
      errors.add('Đơn vị nhập không được để trống');
      isValid = false;
    }

    // Validate mã công cụ dụng cụ
    isCodeValid = controllerCode.text.trim().isNotEmpty;
    if (!isCodeValid) {
      errors.add('Mã công cụ dụng cụ không được để trống');
      isValid = false;
    }

    // Validate ngày nhập
    if (controllerImportDate.text.trim().isEmpty) {
      isImportDateValid = false;
      errors.add('Ngày nhập không được để trống');
      isValid = false;
    } else {
      // Kiểm tra định dạng ngày (dd/mm/yyyy)
      final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
      isImportDateValid = dateRegex.hasMatch(controllerImportDate.text.trim());
      if (!isImportDateValid) {
        errors.add('Ngày nhập phải có định dạng dd/mm/yyyy');
        isValid = false;
      }
    }

    // Validate đơn vị tính
    isUnitValid = controllerUnit.text.trim().isNotEmpty;
    if (!isUnitValid) {
      errors.add('Đơn vị tính không được để trống');
      isValid = false;
    }

    // Validate số lượng
    if (controllerQuantity.text.trim().isEmpty) {
      isQuantityValid = false;
      errors.add('Số lượng không được để trống');
      isValid = false;
    } else {
      final quantity = int.tryParse(controllerQuantity.text.trim());
      isQuantityValid = quantity != null && quantity > 0;
      if (!isQuantityValid) {
        errors.add('Số lượng phải là số nguyên dương');
        isValid = false;
      }
    }

    // Validate giá trị
    if (controllerValue.text.trim().isEmpty) {
      isValueValid = false;
      errors.add('Giá trị không được để trống');
      isValid = false;
    } else {
      final value = double.tryParse(controllerValue.text.trim());
      isValueValid = value != null && value >= 0;
      if (!isValueValid) {
        errors.add('Giá trị phải là số không âm');
        isValid = false;
      }
    }

    // Validate năm sản xuất
    if (controllerYearOfManufacture.text.trim().isNotEmpty) {
      final year = int.tryParse(controllerYearOfManufacture.text.trim());
      isYearOfManufactureValid =
          year != null && year >= 1900 && year <= DateTime.now().year + 1;
      if (!isYearOfManufactureValid) {
        errors.add(
          'Năm sản xuất phải là số hợp lệ (1900 - ${DateTime.now().year + 1})',
        );
        isValid = false;
      }
    } else {
      isYearOfManufactureValid = true; // Optional field
    }

    // Cập nhật UI
    setState(() {});

    // Hiển thị lỗi nếu có
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vui lòng sửa các lỗi sau:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              ...errors.map((error) => Text('• $error')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return isValid;
  }

  void _cancelEdit() {
    // Reset form về giá trị ban đầu
    if (widget.item != null) {
      controllerImportUnit.text = widget.item!.importUnit;
      controllerName.text = widget.item!.name;
      controllerCode.text = widget.item!.code;
      controllerImportDate.text = widget.item!.importDate;
      controllerUnit.text = widget.item!.unit;
      controllerQuantity.text = widget.item!.quantity.toString();
      controllerValue.text = widget.item!.value.toString();
      controllerReferenceNumber.text = widget.item!.referenceNumber;
      controllerSymbol.text = widget.item!.symbol;
      controllerCapacity.text = widget.item!.capacity;
      controllerCountryOfOrigin.text = widget.item!.countryOfOrigin;
      controllerYearOfManufacture.text = widget.item!.yearOfManufacture;
      controllerNote.text = widget.item!.note;
    } else {
      // Nếu là item mới, clear form
      controllerImportUnit.clear();
      controllerName.clear();
      controllerCode.clear();
      controllerImportDate.clear();
      controllerUnit.clear();
      controllerQuantity.clear();
      controllerValue.clear();
      controllerReferenceNumber.clear();
      controllerSymbol.clear();
      controllerCapacity.clear();
      controllerCountryOfOrigin.clear();
      controllerYearOfManufacture.clear();
      controllerNote.clear();
    }

    // Thoát khỏi chế độ edit
    setState(() {
      isEditing = false;
    });
      // context.read<ToolsAndSuppliesProvider>().onTapBackHeader();
  }
}
