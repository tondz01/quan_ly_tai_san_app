import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
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
  late TextEditingController controllerGroupCCDC = TextEditingController();
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

  // Data
  ToolsAndSuppliesDto? data;
  PhongBan? selectedPhongBan;
  CcdcGroup? selectedGroupCCDC;

  List<DropdownMenuItem<PhongBan>> itemsPhongBan = [];
  List<DropdownMenuItem<CcdcGroup>> itemsGroupCCDC = [];
  List<DetailAssetDto> newDetailAssetDto = [];
  Map<String, bool> validationErrors = {};

  @override
  void initState() {
    isEditing = widget.isEditing ?? false;

    // Khởi tạo controller với callbacks
    _controller = ToolsAndSuppliesController(
      onStateChanged: () => setState(() {}),
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

  bool validateForm() {
    Map<String, bool> newValidationErrors = {};
    if (controllerImportUnit.text.trim().isEmpty) {
      newValidationErrors['idPhongBan'] = true;
    }
    // Validate tên công cụ dụng cụ
    if (controllerName.text.trim().isEmpty) {
      newValidationErrors['ten'] = true;
    }

    // Validate mã công cụ dụng cụ
    final String code = controllerCode.text.trim();
    if (code.isEmpty || code.contains(' ')) {
      newValidationErrors['id'] = true;
    }

    // Validate đơn vị nhập
    final String idDonVi =
        (selectedPhongBan?.id ?? controllerImportUnit.text).trim();
    if (idDonVi.isEmpty) {
      newValidationErrors['idDonVi'] = true;
    }

    // Validate nhóm CCDC
    final String idGroupCCDC =
        (selectedGroupCCDC?.id ?? controllerGroupCCDC.text).trim();
    if (idGroupCCDC.isEmpty) {
      newValidationErrors['idNhomCcdc'] = true;
    }
    // Validate đơn vị tính
    if (controllerUnit.text.trim().isEmpty) {
      newValidationErrors['donViTinh'] = true;
    }

    // Validate giá trị
    double? value = double.tryParse(controllerValue.text.trim());
    if (value == null || value <= 0) {
      newValidationErrors['giaTri'] = true;
    }

    // Check if validation errors have changed
    bool hasChanges = !mapEquals(validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        validationErrors = newValidationErrors;
      });
    }
    SGLog.debug('validateForm', 'validationErrors: $validationErrors');
    SGLog.debug('validateForm', 'newValidationErrors: $newValidationErrors');
    return newValidationErrors.isEmpty;
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
            onEdit: _handleEdit,
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
                    validationErrors: validationErrors,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ToolsAndSuppliesFormRight(
                    isEditing: isEditing,
                    item: data,
                    controllerGroupCCDC: controllerGroupCCDC,
                    controllerSymbol: controllerSymbol,
                    controllerNote: controllerNote,
                    controllerQuantity: controllerQuantity,
                    controllerValue: controllerValue,
                    validationErrors: validationErrors,
                    onGroupCCDCChanged: (value) {
                      setState(() {
                        selectedGroupCCDC = value;
                      });
                    },
                    itemsGroupCCDC: itemsGroupCCDC,
                    listGroupCCDC: widget.provider.dataGroupCCDC,
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
                // Đảm bảo dữ liệu được copy đúng cách và validate
                newDetailAssetDto =
                    dataChange.map((e) {
                      // Validate và fix null values
                      return DetailAssetDto(
                        id: e.id,
                        idTaiSan: e.idTaiSan,
                        ngayVaoSo: e.ngayVaoSo,
                        ngaySuDung: e.ngaySuDung,
                        soKyHieu: e.soKyHieu ?? '',
                        congSuat: e.congSuat ?? '',
                        soLuong: e.soLuong ?? 0,
                        nuocSanXuat: e.nuocSanXuat ?? '',
                        namSanXuat: e.namSanXuat ?? 0,
                        idDonVi: selectedPhongBan?.id ?? '',
                      );
                    }).toList();

                // Cập nhật tổng số lượng
                final totalQuantity = newDetailAssetDto
                    .map((e) => e.soLuong ?? 0)
                    .fold(0.0, (sum, quantity) => sum + quantity);

                controllerQuantity.text = totalQuantity.toString();
              });
            },
          ),
        ],
      ),
    );
  }

  void _saveItem() {
    // Validate form trước khi lưu thông qua controller

    setState(() {});

    if (!validateForm()) {
      AppUtility.showSnackBar(
        context,
        'Vui lòng nhập đầy đủ thông tin (*)',
        isError: true,
      );
      return;
    }

    // Validate chi tiết tài sản nếu có
    if (newDetailAssetDto.isNotEmpty) {
      final detailErrors = _controller.getDeletedItems(
        oldList: data?.chiTietTaiSanList ?? [],
        newList: newDetailAssetDto,
      );

      if (detailErrors.isNotEmpty) {
        AppUtility.showSnackBar(
          context,
          'Chi tiết tài sản có lỗi. Vui lòng kiểm tra lại',
          isError: true,
        );
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
        selectedGroupCCDC: selectedGroupCCDC,
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

      SGLog.debug(
        '_saveItem',
        'jsonEncode data: ${jsonEncode(newDetailAssetDto)}',
      );
      // Gọi API thông qua Bloc
      if (data == null) {
        context.read<ToolsAndSuppliesBloc>().add(
          CreateToolsAndSuppliesEvent(request, jsonEncode(newDetailAssetDto)),
        );
      } else {
        final deletedItems = _controller.getDeletedItems(
          oldList: data?.chiTietTaiSanList ?? [],
          newList: newDetailAssetDto,
        );

        List<String> listIdAssetDetail =
            deletedItems
                .where((detail) => detail.id != null && detail.id!.isNotEmpty)
                .map((detail) => detail.id!)
                .toList();

        final jsonIdAssetDetail = jsonEncode(listIdAssetDetail);

        context.read<ToolsAndSuppliesBloc>().add(
          UpdateToolsAndSuppliesEvent(
            request,
            jsonEncode(newDetailAssetDto),
            jsonIdAssetDetail,
          ),
        );
      }
    } catch (e) {
      SGLog.error('_saveItem', 'Error saving item: $e');
      AppUtility.showSnackBar(
        context,
        'Có lỗi xảy ra khi lưu dữ liệu. Vui lòng thử lại.',
        isError: true,
      );
    }
  }

  void initData() {
    // Khởi tạo dropdown items cho phòng ban thông qua controller
    itemsPhongBan = _controller.buildPhongBanDropdownItems(
      widget.provider.dataPhongBan,
    );

    itemsGroupCCDC = _controller.buildGroupCcdcDropdownItems(
      widget.provider.dataGroupCCDC,
    );

    if (widget.provider.dataDetail != null) {
      isEditing = false;
      data = widget.provider.dataDetail;

      // Khởi tạo các controller với null-safety
      controllerName.text = _controller.formatDisplayValue(data?.ten);
      controllerCode.text = _controller.formatDisplayValue(data?.id);
      controllerImportDate.text = _controller.formatDateDisplay(data?.ngayNhap);
      controllerUnit.text = _controller.formatDisplayValue(data?.donViTinh);
      controllerQuantity.text = _controller.formatDisplayValue(
        data?.soLuong,
        defaultValue: '0',
      );
      controllerValue.text = _controller.formatDisplayValue(
        data?.giaTri,
        defaultValue: '0.0',
      );
      controllerSymbol.text = _controller.formatDisplayValue(data?.kyHieu);
      controllerNote.text = _controller.formatDisplayValue(data?.ghiChu);

      controllerImportUnit.text = data?.tenDonVi ?? '';

      controllerGroupCCDC.text = data?.tenNhomCCDC ?? '';

      // Copy danh sách chi tiết tài sản với null safety
      if (data?.chiTietTaiSanList != null &&
          data!.chiTietTaiSanList.isNotEmpty) {
        newDetailAssetDto =
            data!.chiTietTaiSanList
                .map(
                  (e) => DetailAssetDto(
                    id: e.id,
                    idTaiSan: e.idTaiSan,
                    ngayVaoSo: e.ngayVaoSo,
                    ngaySuDung: e.ngaySuDung,
                    soKyHieu: e.soKyHieu ?? '',
                    congSuat: e.congSuat ?? '',
                    soLuong: e.soLuong ?? 0,
                    nuocSanXuat: e.nuocSanXuat ?? '',
                    namSanXuat: e.namSanXuat ?? 0,
                  ),
                )
                .toList();
      } else {
        newDetailAssetDto = [];
      }

      SGLog.debug(
        'initData',
        'Initialized newDetailAssetDto with ${newDetailAssetDto.length} items from existing data',
      );
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
    validationErrors.clear();
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
      controllerQuantity.text = _controller.formatDisplayValue(
        data?.soLuong,
        defaultValue: '0',
      );
      controllerValue.text = _controller.formatDisplayValue(
        data?.giaTri,
        defaultValue: '0.0',
      );
      controllerSymbol.text = _controller.formatDisplayValue(data?.kyHieu);
      controllerNote.text = _controller.formatDisplayValue(data?.ghiChu);

      controllerImportUnit.text = data?.tenDonVi ?? '';
      controllerGroupCCDC.text = data?.tenNhomCCDC ?? '';

      // Reset danh sách chi tiết
      newDetailAssetDto =
          data?.chiTietTaiSanList != null
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

  /// Xử lý khi nhấn Edit - đảm bảo dữ liệu được preserve
  void _handleEdit() {
    // Đảm bảo dữ liệu được khởi tạo đúng nếu chưa có
    if (newDetailAssetDto.isEmpty &&
        data?.chiTietTaiSanList != null &&
        data!.chiTietTaiSanList.isNotEmpty) {
      newDetailAssetDto = _controller.safeCopyDetailAssets(
        data!.chiTietTaiSanList,
      );
    }

    // Validate và fix null values thông qua controller
    newDetailAssetDto = _controller.safeCopyDetailAssets(newDetailAssetDto);

    setState(() {
      isEditing = true;
    });
  }
}
