// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/tools_and_supplies_form_right.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/tools_and_supplies_header_actions.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/tools_and_supplies_form_left.dart';

class ToolsAndSuppliesDetail extends StatefulWidget {
  final ToolsAndSuppliesProvider provider;
  final bool? isEditing;

  const ToolsAndSuppliesDetail({
    super.key,
    this.isEditing = false,
    required this.provider,
  });

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

  ToolsAndSuppliesDto? data;
  PhongBan? selectedPhongBan;
  List<DropdownMenuItem<PhongBan>> itemsPhongBan = [];

  @override
  void initState() {
    isEditing = widget.isEditing ?? false;
    initData();
    super.initState();
  }

  @override
  void didUpdateWidget(ToolsAndSuppliesDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.data != data) {
      initData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void findPhongBan(String? value) {
    log('message');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ToolsAndSuppliesHeaderActions(
                  isEditing: isEditing,
                  showToggle: data != null,
                  toggleText:
                      isEditing ? 'tas.create_ccdc'.tr : 'common.edit'.tr,
                  onToggleEdit: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  onSave: _saveItem,
                  onCancel: _cancelEdit,
                ),
              ),
              SgIndicator(
                steps: ['Nháp', 'Khóa'],
                currentStep: !isEditing && data != null ? 1 : 0,
                fontSize: 10,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ToolsAndSuppliesFormLeft(
                    isEditing: isEditing,
                    item: data,
                    provider: widget.provider,
                    onPhongBanChanged: (value) {
                      log('message: $value');
                      setState(() {
                        selectedPhongBan = value;
                      });
                    },
                    onImportDateChanged: (value) {
                      log('message: $value');
                      setState(() {
                        // controllerImportDate.text = value?.toString() ?? '';
                        log('message: ${controllerImportDate.toString()}');
                      });
                    },
                    listPhongBan: widget.provider.dataPhongBan,
                    itemsPhongBan: itemsPhongBan,
                    controllerImportUnit: controllerImportUnit,
                    controllerName: controllerName,
                    controllerCode: controllerCode,
                    controllerImportDate: controllerImportDate,
                    controllerUnit: controllerUnit,
                    controllerQuantity: controllerQuantity,
                    controllerValue: controllerValue,
                    isNameValid: isNameValid,
                    isImportUnitValid: isImportUnitValid,
                    isCodeValid: isCodeValid,
                    isImportDateValid: isImportDateValid,
                    isUnitValid: isUnitValid,
                    isQuantityValid: isQuantityValid,
                    isValueValid: isValueValid,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ToolsAndSuppliesFormRight(
                    isEditing: isEditing,
                    item: data,
                    controllerReferenceNumber: controllerReferenceNumber,
                    controllerSymbol: controllerSymbol,
                    controllerCapacity: controllerCapacity,
                    controllerCountryOfOrigin: controllerCountryOfOrigin,
                    controllerYearOfManufacture: controllerYearOfManufacture,
                    controllerNote: controllerNote,
                    isYearOfManufactureValid: isYearOfManufactureValid,
                  ),
                ),
              ],
            ),
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

    // Chuẩn hóa dữ liệu
    DateTime importDate;
    try {
      importDate = DateFormat(
        'dd/MM/yyyy',
      ).parseStrict(controllerImportDate.text.trim());
    } catch (_) {
      importDate = DateTime.now();
    }

    final String sanitizedQuantity = controllerQuantity.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final int quantity = int.tryParse(sanitizedQuantity) ?? 0;

    final String rawValue = controllerValue.text.trim();
    final String sanitizedValue = rawValue
        .replaceAll('.', '')
        .replaceAll(',', '.');
    final double value = double.tryParse(sanitizedValue) ?? 0.0;

    final String sanitizedYear = controllerYearOfManufacture.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final int year = int.tryParse(sanitizedYear) ?? 0;

    if (data == null) {
      // Gọi API tạo mới qua Bloc
      final req = ToolsAndSuppliesRequest(
        id: '',
        idDonVi: controllerImportUnit.text.trim(),
        ten: controllerName.text.trim(),
        ngayNhap: importDate,
        donViTinh: controllerUnit.text.trim(),
        soLuong: quantity,
        giaTri: value,
        soKyHieu: controllerCode.text.trim(),
        kyHieu: controllerSymbol.text.trim(),
        congSuat: controllerCapacity.text.trim(),
        nuocSanXuat: controllerCountryOfOrigin.text.trim(),
        namSanXuat: year,
        ghiChu: controllerNote.text.trim(),
        idCongTy: 'ct001',
        ngayTao: DateTime.now(),
        ngayCapNhat: DateTime.now(),
        nguoiTao: '',
        nguoiCapNhat: '',
        isActive: true,
      );

      context.read<ToolsAndSuppliesBloc>().add(
        CreateToolsAndSuppliesEvent(req),
      );
    } else {
      // Gọi API cập nhật qua Bloc
      final req = ToolsAndSuppliesRequest(
        id: data!.id,
        idDonVi: controllerImportUnit.text.trim(),
        ten: controllerName.text.trim(),
        ngayNhap: importDate,
        donViTinh: controllerUnit.text.trim(),
        soLuong: quantity,
        giaTri: value,
        soKyHieu: controllerCode.text.trim(),
        kyHieu: controllerSymbol.text.trim(),
        congSuat: controllerCapacity.text.trim(),
        nuocSanXuat: controllerCountryOfOrigin.text.trim(),
        namSanXuat: year,
        ghiChu: controllerNote.text.trim(),
        idCongTy: data?.idCongTy ?? 'ct001',
        ngayTao: data?.ngayTao ?? DateTime.now(),
        ngayCapNhat: DateTime.now(),
        nguoiTao: data?.nguoiTao ?? '',
        nguoiCapNhat: '',
        isActive: data?.isActive ?? true,
      );

      context.read<ToolsAndSuppliesBloc>().add(
        UpdateToolsAndSuppliesEvent(req),
      );
    }
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
    log('message: ${controllerValue.text}');
    if (controllerValue.text.trim().replaceAll('.', '').isEmpty) {
      isValueValid = false;
      errors.add('Giá trị không được để trống');
      isValid = false;
    } else {
      final rawText = controllerValue.text.trim().replaceAll('.', '');
      final value = double.tryParse(rawText);
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
    if (data != null) {
      controllerImportUnit.text = data!.idDonVi;
      controllerName.text = data!.ten;
      controllerCode.text = data!.soKyHieu;
      controllerImportDate.text = data!.ngayNhap.toString();
      controllerUnit.text = data!.donViTinh;
      controllerQuantity.text = data!.soLuong.toString();
      controllerValue.text = data!.giaTri.toString();
      controllerReferenceNumber.text = data!.soKyHieu;
      controllerSymbol.text = data!.kyHieu;
      controllerCapacity.text = data!.congSuat;
      controllerCountryOfOrigin.text = data!.nuocSanXuat;
      controllerYearOfManufacture.text = data!.namSanXuat.toString();
      controllerNote.text = data!.ghiChu;
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

  void initData() {
    if (widget.provider.dataDetail != null) {
      data = widget.provider.dataDetail;
      controllerImportUnit.text = data?.idDonVi ?? '';
      controllerName.text = data?.ten ?? '';
      controllerCode.text = data?.soKyHieu ?? '';
      controllerImportDate.text =
          data?.ngayNhap != null
              ? DateFormat('dd/MM/yyyy').format(data!.ngayNhap)
              : '';
      controllerUnit.text = data?.donViTinh ?? '';
      controllerQuantity.text = data?.soLuong.toString() ?? '0';
      controllerValue.text = data?.giaTri.toString() ?? '0.0';
      controllerReferenceNumber.text = data?.soKyHieu ?? '';
      controllerSymbol.text = data?.kyHieu ?? '';
      controllerCapacity.text = data?.congSuat ?? '';
      controllerCountryOfOrigin.text = data?.nuocSanXuat ?? '';
      controllerYearOfManufacture.text = data?.namSanXuat.toString() ?? '';
    } else {
      data = null;
      isEditing = data == null;
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
    if (widget.provider.dataPhongBan != null) {
      itemsPhongBan = [
        for (var element in widget.provider.dataPhongBan)
          DropdownMenuItem<PhongBan>(
            value: element,
            child: Text(element.tenPhongBan ?? ''),
          ),
      ];
    }
  }
}
