import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/header_detail.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/table_child_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/tools_and_supplies_form_right.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/controller/tools_and_supplies_controller.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/tools_and_supplies_form_left.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
  late TextEditingController controllerSymbol = TextEditingController();
  late TextEditingController controllerNote = TextEditingController();
  late TextEditingController controllerDropdown = TextEditingController();

  bool isEditing = false;

  // Business logic controller
  late ToolsAndSuppliesController _controller;

  // Form validation states
  final FormValidationStates _validationStates = FormValidationStates();

  // Data
  ToolsAndSuppliesDto? data;
  PhongBan? selectedPhongBan;
  List<DropdownMenuItem<PhongBan>> itemsPhongBan = [];
  List<DetailAssetDto> newDetailAssetDto = [];

  @override
  void initState() {
    isEditing = widget.isEditing ?? false;
    
    // Khởi tạo controller với callbacks
    _controller = ToolsAndSuppliesController(
      onStateChanged: () => setState(() {}),
      onShowValidationErrors: _showValidationErrors,
      onShowErrorMessage: _showErrorSnackBar,
    );
    
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
    newDetailAssetDto.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeaderDetail(
            isEditing: isEditing,
            onSave: _saveItem,
            onCancel: _cancelEdit,
            onEdit: () {
              setState(() {
                isEditing = true;
              });
            },
          ),
          const SizedBox(height: 5),
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
                      setState(() {
                        selectedPhongBan = value;
                      });
                    },
                    onImportDateChanged: (value) {},
                    listPhongBan: widget.provider.dataPhongBan,
                    itemsPhongBan: itemsPhongBan,
                    controllerImportUnit: controllerImportUnit,
                    controllerName: controllerName,
                    controllerCode: controllerCode,
                    controllerImportDate: controllerImportDate,
                    controllerUnit: controllerUnit,
                    isNameValid: _validationStates.isNameValid,
                    isImportUnitValid: _validationStates.isImportUnitValid,
                    isCodeValid: _validationStates.isCodeValid,
                    isImportDateValid: _validationStates.isImportDateValid,
                    isUnitValid: _validationStates.isUnitValid,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ToolsAndSuppliesFormRight(
                    isEditing: isEditing,
                    item: data,
                    controllerSymbol: controllerSymbol,
                    controllerNote: controllerNote,
                    controllerQuantity: controllerQuantity,
                    controllerValue: controllerValue,
                    isQuantityValid: _validationStates.isQuantityValid,
                    isValueValid: _validationStates.isValueValid,
                  ),
                ),
              ],
            ),
          ),
          TableChildCcdc(
            context,
            isEditing: isEditing,
            initialDetails: newDetailAssetDto,
            onDataChanged: (dataChange) {
              setState(() {
                newDetailAssetDto =
                    dataChange
                        .map(
                          (e) => DetailAssetDto(
                            id: e.id,
                            idTaiSan: e.idTaiSan,
                            ngayVaoSo: e.ngayVaoSo,
                            ngaySuDung: e.ngaySuDung,
                            soKyHieu: e.soKyHieu,
                            congSuat: e.congSuat,
                            soLuong: e.soLuong,
                            nuocSanXuat: e.nuocSanXuat,
                            namSanXuat: e.namSanXuat,
                          ),
                        )
                        .toList();

                controllerQuantity.text =
                    newDetailAssetDto
                        .map(
                          (e) =>
                              int.tryParse(e.soLuong?.toString() ?? '0') ?? 0,
                        )
                        .fold(0, (sum, quantity) => sum + quantity)
                        .toString();

                SGLog.debug(
                  'TableChildCcdc',
                  'message newDetailAssetDto: ${jsonEncode(dataChange)}',
                );
              });
            },
          ),
        ],
      ),
    );
  }

  void _saveItem() {
    // Validate form trước khi lưu thông qua controller
    final validationResult = _controller.validateForm(
      nameText: controllerName.text,
      codeText: controllerCode.text,
      importDateText: controllerImportDate.text,
      unitText: controllerUnit.text,
      quantityText: controllerQuantity.text,
      valueText: controllerValue.text,
      selectedPhongBan: selectedPhongBan,
      importUnitText: controllerImportUnit.text,
    );

    // Cập nhật validation states
    _validationStates.isNameValid = validationResult.validationStates.isNameValid;
    _validationStates.isImportUnitValid = validationResult.validationStates.isImportUnitValid;
    _validationStates.isCodeValid = validationResult.validationStates.isCodeValid;
    _validationStates.isImportDateValid = validationResult.validationStates.isImportDateValid;
    _validationStates.isUnitValid = validationResult.validationStates.isUnitValid;
    _validationStates.isQuantityValid = validationResult.validationStates.isQuantityValid;
    _validationStates.isValueValid = validationResult.validationStates.isValueValid;

    setState(() {});

    if (!validationResult.isValid) {
      _showValidationErrors('Vui lòng sửa các lỗi sau:', validationResult.errors);
      return;
    }

    // Validate chi tiết tài sản nếu có
    if (newDetailAssetDto.isNotEmpty) {
      final detailErrors = _controller.validateDetailAssets(
        newDetailAssetDto,
        controllerCode.text.trim(),
      );
      if (detailErrors.isNotEmpty) {
        _showValidationErrors('Chi tiết tài sản có lỗi:', detailErrors);
        return;
      }
    }

    try {
      // Chuẩn hóa dữ liệu thông qua controller
      final processedData = _controller.processFormData(
        importDateText: controllerImportDate.text,
        quantityText: controllerQuantity.text,
        valueText: controllerValue.text,
        selectedPhongBan: selectedPhongBan,
        importUnitText: controllerImportUnit.text,
      );
      
      // Tạo request object thông qua controller
      final request = _controller.buildToolsAndSuppliesRequest(
        processedData: processedData,
        nameText: controllerName.text,
        codeText: controllerCode.text,
        unitText: controllerUnit.text,
        symbolText: controllerSymbol.text,
        noteText: controllerNote.text,
        existingData: data,
      );
      
      // Gọi API thông qua Bloc
      if (data == null) {
        context.read<ToolsAndSuppliesBloc>().add(
          CreateToolsAndSuppliesEvent(request, jsonEncode(newDetailAssetDto)),
        );
      } else {
        context.read<ToolsAndSuppliesBloc>().add(
          UpdateToolsAndSuppliesEvent(request),
        );
      }
    } catch (e) {
      SGLog.error('_saveItem', 'Error saving item: $e');
      _showErrorSnackBar('Có lỗi xảy ra khi lưu dữ liệu. Vui lòng thử lại.');
    }
  }

  void initData() {
    // Khởi tạo dropdown items cho phòng ban thông qua controller
    itemsPhongBan = _controller.buildPhongBanDropdownItems(widget.provider.dataPhongBan);

    if (widget.provider.dataDetail != null) {
      isEditing = false;
      data = widget.provider.dataDetail;

      // Khởi tạo các controller với null-safety
      controllerName.text = _controller.formatDisplayValue(data?.ten);
      controllerCode.text = _controller.formatDisplayValue(data?.id);
      controllerImportDate.text = _controller.formatDateDisplay(data?.ngayNhap);
      controllerUnit.text = _controller.formatDisplayValue(data?.donViTinh);
      controllerQuantity.text = _controller.formatDisplayValue(data?.soLuong, defaultValue: '0');
      controllerValue.text = _controller.formatDisplayValue(data?.giaTri, defaultValue: '0.0');
      controllerSymbol.text = _controller.formatDisplayValue(data?.kyHieu);
      controllerNote.text = _controller.formatDisplayValue(data?.ghiChu);

      // Tìm và set selectedPhongBan một cách an toàn thông qua controller
      selectedPhongBan = _controller.findPhongBanById(
        widget.provider.dataPhongBan,
        data?.idDonVi,
      );
      controllerImportUnit.text = selectedPhongBan?.tenPhongBan ?? '';

      // Copy danh sách chi tiết tài sản
      newDetailAssetDto = data?.chiTietTaiSanList != null
          ? List<DetailAssetDto>.from(data!.chiTietTaiSanList)
          : [];
    } else {
      // Reset tất cả dữ liệu cho item mới
      data = null;
      isEditing = true;
      selectedPhongBan = null;
      newDetailAssetDto = [];

      // Clear tất cả controllers
      _clearAllControllers();
      _resetValidationStates();
    }

    setState(() {});
  }

  /// Clear tất cả controllers
  void _clearAllControllers() {
    controllerImportUnit.clear();
    controllerName.clear();
    controllerCode.clear();
    controllerImportDate.clear();
    controllerUnit.clear();
    controllerQuantity.clear();
    controllerValue.clear();
    controllerSymbol.clear();
    controllerNote.clear();
  }

  /// Reset tất cả validation states về true
  void _resetValidationStates() {
    _validationStates.resetAll();
  }

  /// Hiển thị lỗi validation
  void _showValidationErrors(String title, List<String> errors) {
    if (errors.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...errors.map((error) => Text('• $error')),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Đóng',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Hiển thị lỗi chung
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Đóng',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void _cancelEdit() {
    widget.provider.onCloseDetail(context);

    // Reset form về giá trị ban đầu
    if (data != null) {
      // Reset controllers với null safety thông qua controller
      controllerName.text = _controller.formatDisplayValue(data?.ten);
      controllerCode.text = _controller.formatDisplayValue(data?.id);
      controllerImportDate.text = _controller.formatDateDisplay(data?.ngayNhap);
      controllerUnit.text = _controller.formatDisplayValue(data?.donViTinh);
      controllerQuantity.text = _controller.formatDisplayValue(data?.soLuong, defaultValue: '0');
      controllerValue.text = _controller.formatDisplayValue(data?.giaTri, defaultValue: '0.0');
      controllerSymbol.text = _controller.formatDisplayValue(data?.kyHieu);
      controllerNote.text = _controller.formatDisplayValue(data?.ghiChu);

      // Reset selectedPhongBan thông qua controller
      selectedPhongBan = _controller.findPhongBanById(
        widget.provider.dataPhongBan,
        data?.idDonVi,
      );
      controllerImportUnit.text = selectedPhongBan?.tenPhongBan ?? '';

      // Reset danh sách chi tiết
      newDetailAssetDto = data?.chiTietTaiSanList != null
          ? List<DetailAssetDto>.from(data!.chiTietTaiSanList)
          : [];
    } else {
      // Nếu là item mới, clear tất cả form
      newDetailAssetDto = [];
      selectedPhongBan = null;
      _clearAllControllers();
    }

    // Reset validation states
    _resetValidationStates();

    // Thoát khỏi chế độ edit
    setState(() {
      isEditing = false;
    });
  }
}