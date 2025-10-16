import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
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
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
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
  late TextEditingController controllerTypeCCDC = TextEditingController();
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
  TypeCcdc? selectedTypeCCDC;
  UnitDto? selectedUnit;

  List<DropdownMenuItem<PhongBan>> itemsPhongBan = [];
  List<DropdownMenuItem<CcdcGroup>> itemsGroupCCDC = [];
  List<DropdownMenuItem<TypeCcdc>> itemsTypeCCDC = [];
  List<DropdownMenuItem<UnitDto>> itemsUnit = [];
  List<DetailAssetDto> newDetailAssetDto = [];
  Map<String, bool> validationErrors = {};

  @override
  void initState() {
    isEditing = widget.isEditing ?? false;

    // Khởi tạo controller với callbacks
    _controller = ToolsAndSuppliesController(
      onStateChanged: () {
        setState(() {});
      },
    );

    initData();
    super.initState();
  }

  @override
  void didUpdateWidget(ToolsAndSuppliesDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.data != data && widget.provider.isUpdateDetail) {
      widget.provider.isUpdateDetail = false;
      initData();
    }
  }

  @override
  void dispose() {
    controllerImportUnit.dispose();
    controllerGroupCCDC.dispose();
    controllerTypeCCDC.dispose();
    controllerName.dispose();
    controllerCode.dispose();
    controllerImportDate.dispose();
    controllerUnit.dispose();
    controllerQuantity.dispose();
    controllerValue.dispose();
    controllerSymbol.dispose();
    controllerNote.dispose();
    controllerDropdown.dispose();
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

    // Validate loại CCDC
    final String idTypeCCDC =
        (selectedTypeCCDC?.id ?? controllerTypeCCDC.text).trim();
    if (idTypeCCDC.isEmpty) {
      newValidationErrors['idLoaiCCDCCon'] = true;
    }

    // Validate đơn vị tính
    if (controllerUnit.text.trim().isEmpty || selectedUnit == null) {
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
            child: Column(
              children: [
                Row(
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
                        listUnit: widget.provider.dataUnit,
                        itemsUnit: itemsUnit,
                        onUnitChanged: (value) {
                          setState(() {
                            selectedUnit = value;
                          });
                        },
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
                        controllerTypeCCDC: controllerTypeCCDC,
                        controllerSymbol: controllerSymbol,
                        controllerQuantity: controllerQuantity,
                        controllerValue: controllerValue,
                        validationErrors: validationErrors,
                        itemsTypeCCDC: itemsTypeCCDC,
                        listTypeCCDC: widget.provider.dataTypeCCDC,
                        onTypeCCDCChanged: (value) {
                          setState(() {
                            selectedTypeCCDC = value;
                          });
                        },
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

                CommonFormInput(
                  label: 'Ghi chú',
                  controller: controllerNote,
                  isEditing: isEditing,
                  textContent: data?.ghiChu ?? '',
                  fieldName: 'ghiChu',
                  validationErrors: validationErrors,
                  width: double.infinity,
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
      final detailErrors = _controller.validateDetailAssets(
        newDetailAssetDto,
        data?.chiTietTaiSanList ?? [],
        controllerCode.text.trim(),
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
        selectedTypeCCDC: selectedTypeCCDC,
      );

      // Tạo request object thông qua controller
      final request = _controller.buildToolsAndSuppliesRequest(
        processedData: processedData,
        nameText: controllerName.text,
        codeText: controllerCode.text,
        unitText: selectedUnit?.id ?? '',
        symbolText: controllerSymbol.text,
        noteText: controllerNote.text,
        existingData: data,
      );

      // Gọi API thông qua Bloc
      if (data == null) {
        context.read<ToolsAndSuppliesBloc>().add(
          CreateToolsAndSuppliesEvent(
            request,
            newDetailAssetDto.isNotEmpty ? jsonEncode(newDetailAssetDto) : '',
          ),
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

        context.read<ToolsAndSuppliesBloc>().add(
          UpdateToolsAndSuppliesEvent(
            request,
            newDetailAssetDto.isNotEmpty ? jsonEncode(newDetailAssetDto) : '',
            listIdAssetDetail.isNotEmpty ? jsonEncode(listIdAssetDetail) : '',
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

    itemsTypeCCDC = _controller.buildTypeCcdcDropdownItems(
      widget.provider.dataTypeCCDC,
    );

    itemsUnit = _controller.buildUnitDropdownItems(widget.provider.dataUnit);

    if (widget.provider.dataDetail != null) {
      isEditing = false;
      data = widget.provider.dataDetail;

      // Khởi tạo các controller với null-safety
      controllerName.text = _controller.formatDisplayValue(data?.ten);
      controllerCode.text = _controller.formatDisplayValue(data?.id);
      controllerImportDate.text = AppUtility.formatFromISOString(
        data?.ngayNhap ?? '',
      );
      controllerQuantity.text = _controller.formatDisplayValue(
        data?.soLuong,
        defaultValue: '0',
      );
      controllerValue.text = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '',
      ).format(data?.giaTri ?? 0.0);
      controllerSymbol.text = _controller.formatDisplayValue(data?.kyHieu);
      controllerNote.text = _controller.formatDisplayValue(data?.ghiChu);

      controllerImportUnit.text = data?.tenDonVi ?? '';
      controllerGroupCCDC.text = data?.tenNhomCCDC ?? '';

      if (data?.donViTinh != null && data?.donViTinh != '') {
        SGLog.debug(
          '_cancelEdit',
          'data?.donViTinh initData: ${data?.donViTinh}',
        );
        try {
          controllerUnit.text =
              widget.provider.dataUnit
                  .firstWhere((element) => element.id == data?.donViTinh)
                  .tenDonVi ??
              '';
        } catch (e) {
          SGLog.debug('_cancelEdit', 'Error initData: $e');
          controllerTypeCCDC.text = '';
        }
      } else {
        controllerUnit.text = '';
      }

      if (data?.idLoaiCCDCCon != null && data?.idLoaiCCDCCon != '') {
        SGLog.debug(
          '_cancelEdit',
          'data?.idLoaiCCDCCon initData: ${data?.idLoaiCCDCCon}',
        );
        try {
          controllerTypeCCDC.text =
              widget.provider.dataTypeCCDC
                  .firstWhere((element) => element.id == data?.idLoaiCCDCCon)
                  .tenLoai ??
              '';
        } catch (e) {
          SGLog.debug('_cancelEdit', 'Error initData: $e');
          controllerTypeCCDC.text = '';
        }
      } else {
        controllerTypeCCDC.text = '';
      }

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
    controllerGroupCCDC.clear();
    controllerTypeCCDC.clear();
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
      controllerImportDate.text = AppUtility.formatFromISOString(
        data?.ngayNhap ?? '',
      );

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

      if (data?.donViTinh != null && data?.donViTinh != '') {
        SGLog.debug('_cancelEdit', 'data?.donViTinh: ${data?.donViTinh}');
        try {
          controllerUnit.text =
              widget.provider.dataUnit
                  .firstWhere((element) => element.id == data?.donViTinh)
                  .tenDonVi ??
              '';
        } catch (e) {
          SGLog.debug('_cancelEdit', 'Error _cancelEdit: $e');
          controllerUnit.text = '';
        }
      } else {
        controllerUnit.text = '';
      }

      if (data?.idLoaiCCDCCon != null && data?.idLoaiCCDCCon != '') {
        SGLog.debug(
          '_cancelEdit',
          'data?.idLoaiCCDCCon: ${data?.idLoaiCCDCCon}',
        );
        try {
          controllerTypeCCDC.text =
              widget.provider.dataTypeCCDC
                  .firstWhere((element) => element.id == data?.idLoaiCCDCCon)
                  .tenLoai ??
              '';
        } catch (e) {
          SGLog.debug('_cancelEdit', 'Error _cancelEdit: $e');
          controllerTypeCCDC.text = '';
        }
      } else {
        controllerTypeCCDC.text = '';
      }
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
